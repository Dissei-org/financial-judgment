"""Dissei Harbor verifier: episode integrity checks, then the unchanged grader.

Runs inside the verifier container as root (``python -I -B /tests/verify.py``).

What the grader (``dissei_harbor.score``) trusts is the episode record written by
``dataroom``: the submitted answer, the tool-call log that feeds the retrieval
modulator, and the budget state. In this build that record is written by a
root-owned process behind sudo, so an agent cannot edit it. This module is the
second line: it re-derives what the record claims from the corpus itself, so a
record that somehow bypassed that boundary (a sandbox that ignores the task's
agent user, a future runtime change) still cannot earn credit it did not earn.

Checks, in order:

1. Submission provenance. An answer file counts only if the state file says the
   episode finished through ``submit_answer``, the log carries that record, and
   the file's text is the text that was submitted. Anything else is graded as
   "not submitted" (reward 0, reason recorded), the same outcome as no answer.
2. Budget. The log cannot legitimately hold more budget-consuming calls than the
   tool budget; such records past the budget are dropped from scoring. The submit
   and budget-exhausted refusals are free and never count.
3. Replay. Every ``view_source`` / ``view_timeline`` / ``get_exhibit`` record
   that carries a success body is re-executed against ``/corpus`` with the same
   arguments; a body that does not match byte-for-byte loses its credit.

The sanitized log is handed to the grader; nothing about the reward formula, the
judges or the rubric changes. Findings are written to ``integrity.json`` beside
the reward file and merged into ``score_breakdown.json`` under ``integrity``.
"""

from __future__ import annotations

import contextvars
import json
import os
import shutil
import sys
from pathlib import Path
from typing import Any

sys.path.insert(0, "/opt/dissei/runtime")

from dissei_env import tools as T  # noqa: E402
from dissei_env.corpus import LocalCorpusSource  # noqa: E402
from dissei_env.tools import EpisodeState  # noqa: E402
from dissei_harbor import score as S  # noqa: E402
from dissei_harbor.dataroom import manifest_from_dir  # noqa: E402

EPISODE_DIR = Path(os.environ.get("DISSEI_LOG_DIR", "/var/lib/dissei/episode"))
ANSWER_PATH = Path(os.environ.get("DISSEI_ANSWER_PATH", str(EPISODE_DIR / "answer.md")))
TRAJECTORY_PATH = Path(os.environ.get("DISSEI_TRAJECTORY_PATH", str(EPISODE_DIR / "tool_calls.jsonl")))
STATE_PATH = EPISODE_DIR / "dataroom_state.json"
VERIFIER_DIR = Path(os.environ.get("DISSEI_VERIFIER_DIR", "/logs/verifier"))
TASK_YAML = Path(os.environ.get("DISSEI_TASK_YAML", "/tests/task.yaml"))
CORPUS_ROOT = Path(os.environ.get("DISSEI_CORPUS_ROOT", "/corpus"))
CASE = os.environ.get("DISSEI_CASE", "")
ANCHOR = os.environ.get("DISSEI_ANCHOR", "")
TOOL_BUDGET = int(os.environ.get("DISSEI_TOOL_BUDGET", "20"))

READ_TOOLS = {"view_source": T.view_source, "view_timeline": T.view_timeline, "get_exhibit": T.get_exhibit}
ID_FIELD = {"view_source": "citation_id", "view_timeline": "anchor", "get_exhibit": "exhibit_id"}


def _read_records(path: Path) -> tuple[list[dict[str, Any]], int]:
    if not path.is_file():
        return [], 0
    out: list[dict[str, Any]] = []
    bad = 0
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            rec = json.loads(line)
        except json.JSONDecodeError:
            bad += 1
            continue
        if isinstance(rec, dict) and rec.get("name"):
            out.append(rec)
        else:
            bad += 1
    return out, bad


def _consumes_budget(rec: dict[str, Any]) -> bool:
    if rec.get("name") == "submit_answer":
        return False
    result = rec.get("result")
    return not (isinstance(result, dict) and result.get("error") == "tool_budget_exhausted")


def _replay(name: str, args: dict[str, Any]) -> dict[str, Any]:
    state = EpisodeState(
        case_slug=CASE, anchor=ANCHOR, task_index=0, task_slug="", task_category="",
        task_complexity="", tool_budget=10**6, turn_limit=0,
    )
    case = manifest_from_dir(CORPUS_ROOT, CASE)
    source = LocalCorpusSource(CORPUS_ROOT)

    def _invoke() -> str:
        T.set_case(case)
        T.set_state(state)
        T.set_source(source)
        return READ_TOOLS[name](**args)

    try:
        return json.loads(contextvars.copy_context().run(_invoke))
    except Exception as exc:  # noqa: BLE001 - a replay crash is a mismatch, not a grader error
        return {"error": f"replay_failed: {type(exc).__name__}: {exc}"}


def _copy_for_inspection() -> None:
    VERIFIER_DIR.mkdir(parents=True, exist_ok=True)
    for src, dst in (
        (ANSWER_PATH, VERIFIER_DIR / "answer.md"),
        (TRAJECTORY_PATH, VERIFIER_DIR / "tool_calls.raw.jsonl"),
        (STATE_PATH, VERIFIER_DIR / "dataroom_state.json"),
    ):
        if src.is_file():
            shutil.copyfile(src, dst)


def _no_submission(reason: str, report: dict[str, Any], calls: int) -> int:
    breakdown = {
        "final_reward": 0.0,
        "outcome_reward": 0.0,
        "gate_passed": False,
        "gate_score": 0.0,
        "graded_score_raw": 0,
        "graded_score_normalised": 0.0,
        "retrieval_modulator": 1.0,
        "no_submission": True,
        "no_submission_reason": reason,
        "trajectory_calls": calls,
        "integrity": report,
    }
    S._write_outputs(VERIFIER_DIR, S._flat_rewards(breakdown, submitted=False) | {"integrity_ok": 0.0}, breakdown)
    print(f"dissei-harbor-verify: {reason} - reward 0.0", file=sys.stderr)
    return 0


def main() -> int:
    _copy_for_inspection()
    report: dict[str, Any] = {"ok": True, "findings": [], "replayed": 0, "replay_mismatches": 0,
                              "records_total": 0, "records_dropped_over_budget": 0, "unparseable_lines": 0}

    records, bad = _read_records(TRAJECTORY_PATH)
    report["records_total"] = len(records)
    report["unparseable_lines"] = bad
    answer = S.read_answer(ANSWER_PATH)

    if not answer:
        # The grader's own no-submission path: recorded zero, no judge calls.
        (VERIFIER_DIR / "integrity.json").write_text(json.dumps(report, indent=2) + "\n")
        return S.main(["--trajectory", str(TRAJECTORY_PATH)])

    # 1. Submission provenance -------------------------------------------------
    state: dict[str, Any] | None = None
    if STATE_PATH.is_file():
        try:
            state = json.loads(STATE_PATH.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            state = None
    submit_records = [r for r in records if r.get("name") == "submit_answer"]
    if state is None or not state.get("finished") or not submit_records:
        report["ok"] = False
        report["findings"].append("answer file present but the episode was not finished through `dataroom submit`")
        (VERIFIER_DIR / "integrity.json").write_text(json.dumps(report, indent=2) + "\n")
        return _no_submission("answer not submitted through dataroom (integrity)", report, len(records))
    if str(state.get("submitted_answer", "")).strip() != answer:
        report["ok"] = False
        report["findings"].append("answer file text differs from the text recorded by `dataroom submit`")
        (VERIFIER_DIR / "integrity.json").write_text(json.dumps(report, indent=2) + "\n")
        return _no_submission("answer file edited after submission (integrity)", report, len(records))
    if records[-1].get("name") != "submit_answer" or len(submit_records) != 1:
        report["findings"].append("submit_answer is not the single terminal record; later records are ignored")
        idx = next(i for i, r in enumerate(records) if r.get("name") == "submit_answer")
        records = records[: idx + 1]

    # 2. Budget --------------------------------------------------------------
    # `dataroom` logs every call, but two kinds spend nothing: the terminal submit and
    # the refusals returned once the budget is gone. Counting them would flag every
    # agent that uses its full budget and then submits.
    spent = [i for i, r in enumerate(records) if _consumes_budget(r)]
    if len(spent) > TOOL_BUDGET:
        excess = set(spent[TOOL_BUDGET:])
        report["ok"] = False
        report["records_dropped_over_budget"] = len(excess)
        report["findings"].append(f"{len(spent)} budget-consuming calls exceed the tool budget of {TOOL_BUDGET}; excess dropped")
        records = [r for i, r in enumerate(records) if i not in excess]

    # 3. Replay --------------------------------------------------------------
    sanitized: list[dict[str, Any]] = []
    for rec in records:
        name = str(rec.get("name", ""))
        result = rec.get("result")
        if name in READ_TOOLS and isinstance(result, dict) and "content" in result and not result.get("error"):
            args = dict(rec.get("args") or {})
            report["replayed"] += 1
            fresh = _replay(name, args)
            same = (
                isinstance(fresh, dict)
                and "content" in fresh
                and fresh.get("content") == result.get("content")
                and str(fresh.get(ID_FIELD[name], args.get(ID_FIELD[name]))) == str(result.get(ID_FIELD[name], args.get(ID_FIELD[name])))
            )
            if not same:
                report["ok"] = False
                report["replay_mismatches"] += 1
                report["findings"].append(f"{name} {json.dumps(args, sort_keys=True)} does not replay against the corpus; credit removed")
                rec = {"name": name, "args": args, "result": {"error": "integrity_replay_mismatch"}}
        sanitized.append(rec)

    verified_path = VERIFIER_DIR / "tool_calls.verified.jsonl"
    verified_path.write_text("".join(json.dumps(r, sort_keys=True) + "\n" for r in sanitized), encoding="utf-8")
    (VERIFIER_DIR / "integrity.json").write_text(json.dumps(report, indent=2) + "\n")

    rc = S.main(["--trajectory", str(verified_path)])
    if rc == 0:
        bd_path = VERIFIER_DIR / "score_breakdown.json"
        rw_path = VERIFIER_DIR / "reward.json"
        if bd_path.is_file() and rw_path.is_file():
            breakdown = json.loads(bd_path.read_text(encoding="utf-8"))
            rewards = json.loads(rw_path.read_text(encoding="utf-8"))
            breakdown["integrity"] = report
            rewards["integrity_ok"] = 1.0 if report["ok"] else 0.0
            # Same order as the grader: breakdown first, reward file last.
            bd_path.write_text(json.dumps(breakdown, indent=2, sort_keys=True, default=str) + "\n", encoding="utf-8")
            rw_path.write_text(json.dumps(rewards, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
