---
language:
- en
license: other
license_name: financial-judgment-restricted
license_link: LICENSE.md
pretty_name: Dissei Financial Judgment — Full Evaluation Package
tags:
- finance
- financial-reasoning
- evaluation
- harbor
- llm-judge
---

# Dissei Financial Judgment — Full Evaluation Package

**Version 2.0.0 — local release candidate; public publication pending approval.** Proposed replacement card for `Dissei-Data/Dissei-Financial-Judgment`. That destination is currently private; no public files, viewer or runnable hosted job are claimed by this card.

This is the **complete seven-task package**, not question previews: original instructions, financial evidence, all **79 rubric criteria**, task YAML, judge prompts, scoring code, reference answers, dataroom runtime and separate-verifier assets are intentionally included. Delivery requires both minimal Harbor task files and three dated Docker image archives supporting `linux/amd64` and `linux/arm64`. Runtime and evidence are inside the images; the task files retain host-side rubrics, reference answers and verifier entry points. No hosted-only service is required to inspect the evaluator or run the tasks locally.

## Scope

One completed private-equity transaction, three decision dates and seven families:

| Task directory | Anchor | Family | Criteria |
|---|---|---|---|
| `fab01-2112-dg04` | 2021-12 | Diagnostic | 12 |
| `fab01-2112-pr02` | 2021-12 | Predictive | 11 |
| `fab01-2206-ex01` | 2022-06 | Explanatory | 13 |
| `fab01-2206-qn02` | 2022-06 | Quantitative | 10 |
| `fab01-2209-cf01` | 2022-09 | Counterfactual | 13 |
| `fab01-2209-cp02` | 2022-09 | Comparative | 10 |
| `fab01-2209-st06` | 2022-09 | Strategic | 10 |

The capability measured combines evidence retrieval, financial analysis, calibrated writing and harness control. This is not a general-finance knowledge test, a multi-step workflow benchmark or a professional certification.

**Disclosure boundary:** grading methods are inspectable because the full evaluator, rubrics, judge prompts and reference answers are included. Runtime source and evidence can be extracted from the supplied Docker images; Docker does not hide code. A separate verifier limits ordinary task-agent access; it does not conceal files from the package recipient. Task-authoring machinery, private production workflows and unnecessary orchestration are excluded. No inference-proof claim is made.

**Identity treatment:** metadata uses `name_suppressed`. Exact financial facts, dates and market figures remain unchanged; retained details and external records can permit re-identification. Names suppressed does not mean anonymous. Copyright and source-specific notices remain intact.

## Files and running

The execution format is a Harbor task directory tree, **not** a preview JSONL/Parquet table or a `load_dataset()` training split. The complete mirror includes:

- `tasks/fab01-*/`: seven full tasks, each with eight files: `instruction.md`, `task.toml`, `environment/Dockerfile`, `tests/Dockerfile`, `tests/verify.py`, `tests/test.sh`, `tests/task.yaml` and `solution/solve.sh`. Harbor 0.23.0 requires `environment/`; its only file is a one-line `Dockerfile` containing `FROM` with the supplied image tag. There is no duplicated runtime/evidence directory or public environment rebuild input. `tests/Dockerfile` builds the separate verifier on the same supplied image.
- `images/financial-judgment-2021-12.tar.gz`, `images/financial-judgment-2022-06.tar.gz`, `images/financial-judgment-2022-09.tar.gz`, `images/SHA256SUMS` and root `image-inventory.json`.
- `run-records.tar.gz`, `run-index.json`, `evaluation-protocol.json` and `redaction-summary.json`.
- `README.md`, `USAGE.md`, `LICENSE.md`, `CHANGELOG.md`, `publication-plan.md`, `dataset.toml` and `local-task-index.json`.

Use both the complete task directory and actual image archive contents, not large-file pointer files. Image archives alone are not a Harbor dataset; task files alone do not supply the runtime or evidence. A platform dataset viewer is not proof that images or separate-verifier execution work. Consult [USAGE.md](USAGE.md), install Harbor 0.23.0 and check archive hashes before loading:

```bash
docker load --input images/financial-judgment-2021-12.tar.gz
docker load --input images/financial-judgment-2022-06.tar.gz
docker load --input images/financial-judgment-2022-09.tar.gz
```

With your own authorized agent/provider credentials and judge configuration, run from the mirror root:

```bash
harbor run --path ./tasks \
  -a terminus-2 -m "${DISSEI_AGENT_MODEL:?Set your authorized provider/model ID}" \
  -n 1 -k 1 --ak max_turns=40 --ak reasoning_effort=high \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

Start with `--path ./tasks/fab01-2209-st06` if you want one task first. `--ve` forwards judge settings into the separate verifier. No private proxy, default judge endpoint, bundled commercial agent CLI or automatic results upload is supplied. Calls can incur costs and disclose content to your chosen provider. These setup commands do not configure every historical provider/token setting and are not an exact-replication claim. The proposed registry manifest becomes remotely resolvable only after separate publication; local runs use `--path ./tasks`.

**Inherited judge-failure limitation:** missing required judge configuration produces exit 3 without a reward. A scoring exception reaching the entry point or top-level `graded_unavailable` / `contradiction_unavailable` produces exit 4 without a reward; the tested whole-endpoint outage and wholly unusable decisive verdicts take this path. Critical/pitfall per-row unavailability does not itself prevent a reward: unavailable critical verdicts are excluded from the gate denominator; when none are available, `gate_score` defaults to **1.0**. Unavailable pitfall verdicts add no penalty. Missing or malformed graded criterion diagnostics can coexist with a usable holistic score; multiple-vote aggregation can retain a usable verdict despite some unusable votes. These are preserved scoring semantics, not a new hardening fix. Inspect `score_breakdown.json` and its per-row `unavailable` flags alongside rewards and trial errors; see [USAGE.md](USAGE.md).

## Preserved historical results

Reward / 100 is the equal-weight mean of seven continuous task rewards, multiplied by 100, using unrounded values before display. It is not accuracy. The table preserves the comparison recorded on 2026-09-24–25 (UTC), including a GLM-5.3 recovery completed after midnight UTC, not new results from version 2.0.0.

| Model | Historical reward / 100 | Submitted / 7 |
|---|---|---|
| Claude Fable 5.1 | 60.73 | 7 |
| GPT-6 Astra | 52.45 | 7 |
| Claude Opus 5.5 | 52.17 | 7 |
| GLM-5.3 | 44.91 | 7 |
| Kimi K3 | 35.79 | 7 |
| Gemini 3.8 Flash | 9.01 | 1 |

Historical configuration: Harbor 0.23.0, Terminus-2 JSON harness, 20 dataroom calls, 40 agent turns, 30 minutes per task, high agent reasoning and 16,384 output tokens per request; `gemini-3.1-pro-preview` judge, low reasoning, one vote. Provider client framing can differ. Original task-version provenance is retained separately from the new executable release digests.

Gemini 3.8 Flash's result is protocol-limited: six selected attempts hit the turn cap and 50 responses were rejected by the JSON parser. Its one valid submission and genuine non-submission zero were retained while five infrastructure-failed tasks were recovered. GLM-5.3 retained six successful original outcomes and one completed recovery, with failed/interrupted attempts preserved. No successful trial was rerun to seek a higher score.

The sanitized archive contains **16 jobs and 86 attempts**. The table uses **42 selected outcomes**, not all archive attempts. A historical Gemini 3.1 Pro baseline has seven further selected outcomes, seven submissions and mean reward 0.3124; it is separately labeled, not mixed into the six-model table. QA/no-op/stub runs, failures and recovery attempts remain identifiable as such. Stable pseudonyms replace operational identities; private infrastructure and revealing historical source excerpts are visibly redacted across saved representations. Numerical rewards, breakdowns, model identities and outcome-selection relationships remain preserved. See `redaction-summary.json` for the derivative's scope and limits.

No new model benchmark results are claimed. Deterministic local judge smoke checks validate mechanics, not financial grading accuracy or model quality. This single-case pilot provides no repeated-run variance estimate or guarantee of statistical significance. Publicly accessible reference answers must be considered when designing future evaluations and assessing prior exposure.

## Rights and distribution status

License: **Other / restricted**; see [LICENSE.md](LICENSE.md). The owner confirmed source redistribution rights. This is not a blanket permissive grant for downstream training, adaptation or redistribution, and source notices remain effective. Public availability does not itself establish permitted reuse.

Proposed new Harbor dataset: [dissei/financial-judgment-full](https://hub.harborframework.com/datasets/dissei/financial-judgment-full), version `2.0.0` — pending approval. GitHub mirror target: [Dissei-org/financial-judgment](https://github.com/Dissei-org/financial-judgment) — currently private. Original private package histories, images, source records and native job pages stay private; distributing sanitized files does not expose those resources or promise erasure of prior copies.

This card is prepared locally only. See [publication-plan.md](publication-plan.md) for the exact approval-gated sequence. Contact [tech@dissei.credit](mailto:tech@dissei.credit) for licensing and private security reports.
