# Dissei Financial Judgment — Full Evaluation Package

**Version 2.0.0: local release candidate, prepared for public distribution; publication pending approval.** This is proposed copy for `Dissei-org/financial-judgment`, which is currently private. It does not announce a public repository or an available release asset.

Financial Judgment asks whether an agent can connect financial evidence to a well-supported conclusion. The complete package contains **seven runnable tasks and 79 rubric criteria** from one completed transaction at three anchor dates: December 2021, June 2022 and September 2022. It covers diagnostic, predictive, explanatory, quantitative, counterfactual, comparative and strategic judgment.

## Full contents and disclosure boundary

Included in two required delivery parts: minimal Harbor task files plus three dual-architecture Docker image archives. Together they supply all original task instructions and evidence, task YAML, rubrics, judge prompts, scoring implementation, reference answers, dataroom tools and separate-verifier assets. Runtime and evidence are inside the images; task-specific rubrics, reference answers and verifier entry points remain in the host-side task packages. This is not a question-preview repository or a hosted-only evaluator.

The evaluator and its grading methodology are intentionally inspectable. Recipients can extract runtime source and evidence from the supplied images; Docker does not hide code. The separate verifier keeps task-specific grading inputs out of the normal agent container, not away from a recipient controlling the downloaded package. Task-authoring machinery and unnecessary private production workflows are excluded. No inference-proof guarantee is made.

Case names are suppressed, but exact financial facts, dates, amounts and market figures are retained. These details may permit re-identification. Copyright and source notices remain included.

## Local execution

The complete mirror's layout is `tasks/fab01-*/` plus root documentation and attachments, with three archives under `images/`. Each task contains eight files: `instruction.md`, `task.toml`, `environment/Dockerfile`, `tests/Dockerfile`, `tests/verify.py`, `tests/test.sh`, `tests/task.yaml` and `solution/solve.sh`. Harbor 0.23.0 requires `environment/`; its one-line Dockerfile contains only `FROM` with the supplied image tag. Runtime and evidence are not duplicated there, and no public environment rebuild inputs are included. The separate verifier builds from `tests/Dockerfile` using the same loaded image. See `USAGE.md` for prerequisites, checksum checks, credentials and failure handling. From the release root, load all three images:

```bash
docker load --input images/financial-judgment-2021-12.tar.gz
docker load --input images/financial-judgment-2022-06.tar.gz
docker load --input images/financial-judgment-2022-09.tar.gz
```

Provide your own authorized agent/provider access and judge settings, then run:

```bash
harbor run --path ./tasks \
  -a terminus-2 -m "${DISSEI_AGENT_MODEL:?Set your authorized provider/model ID}" \
  -n 1 -k 1 --ak max_turns=40 --ak reasoning_effort=high \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

This is a setup example, not an exact historical replication command. To start with one task, use `--path ./tasks/fab01-2209-st06`. Model and judge calls may incur charges and disclose data to the chosen provider. No private proxy, bundled commercial agent CLI or automatic results upload is required. The proposed registry `dataset.toml` does not replace local `--path ./tasks` execution.

The proposed GitHub `v2.0.0` release will deliver the three unchanged clean image archives as assets, accompanied by inventory/checksums. Also obtain the minimal task files and root documentation/attachments from the matching approved revision; image assets alone are not a runnable Harbor dataset, and a source-only checkout does not supply the runtime or evidence. Place individually downloaded image assets at the `images/` paths above. Their existence and public access must be confirmed by a publication receipt, not inferred from this card.

**Inherited judge-failure limitation:** missing required judge configuration produces exit 3 without a reward. A scoring exception reaching the entry point or top-level `graded_unavailable` / `contradiction_unavailable` produces exit 4 without a reward; the tested whole-endpoint outage and wholly unusable decisive verdicts take this path. Critical/pitfall per-row unavailability does not itself prevent a reward: unavailable critical verdicts are excluded from the gate denominator; when none are available, `gate_score` defaults to **1.0**. Unavailable pitfall verdicts add no penalty. Missing or malformed graded criterion diagnostics can coexist with a usable holistic score; multiple-vote aggregation can retain a usable verdict despite some unusable votes. These are preserved scoring semantics, not a new hardening fix. Inspect `score_breakdown.json` and its per-row `unavailable` flags alongside rewards and trial errors; see `USAGE.md`.

## Historical outcomes, not a new benchmark

| Model | Historical reward / 100 | Submitted / 7 |
|---|---|---|
| Claude Fable 5.1 | 60.73 | 7 |
| GPT-6 Astra | 52.45 | 7 |
| Claude Opus 5.5 | 52.17 | 7 |
| GLM-5.3 | 44.91 | 7 |
| Kimi K3 | 35.79 | 7 |
| Gemini 3.8 Flash | 9.01 | 1 |

These are the preserved 2026-09-24–25 (UTC) outcomes: 42 selected results across six models and seven tasks, including a GLM-5.3 recovery completed after midnight UTC. Reward / 100 is an equal-weight mean of continuous task rewards, not accuracy. The historical protocol used Harbor 0.23.0, Terminus-2, 20 dataroom calls, 40 turns, 30 minutes, high agent reasoning, 16,384 output tokens per request, and `gemini-3.1-pro-preview` judging with low reasoning and one vote.

Gemini 3.8 Flash is protocol-limited: one submission, six turn-limit outcomes and 50 rejected JSON responses. GLM-5.3 includes one completed infrastructure recovery; successful original outcomes were not rerun for a higher score. This is a single-case pilot without repeated-run variance estimates.

The sanitized archive retains **16 jobs and 86 attempts**, including failures/recoveries, execution QA/no-op/stub runs and a separately labeled historical Gemini 3.1 Pro baseline (seven submissions, mean 0.3124). It is not an 86-score leaderboard. `run-index.json`, `evaluation-protocol.json` and `redaction-summary.json` explain selection, historical provenance and redaction. Numerical outcomes remain unchanged; private identities, infrastructure and revealing source excerpts are redacted across duplicated records. Native job pages remain separate private resources.

Version 2.0.0 introduces no new model benchmark results. Deterministic local judge smoke checks prove execution mechanics, not financial grading accuracy, historical replication or model quality. The new task/image digests are not the historical versions on which these results were recorded.

## Rights and proposed distribution

License category: **Other / restricted**; see `LICENSE.md`. The owner confirmed source redistribution rights, but this is not a blanket permissive downstream training, adaptation or redistribution grant. Public availability does not supersede source-specific notices or applicable agreements.

Proposed new Harbor dataset: [dissei/financial-judgment-full](https://hub.harborframework.com/datasets/dissei/financial-judgment-full), version `2.0.0` — pending approval. Proposed Hugging Face mirror: [Dissei-Data/Dissei-Financial-Judgment](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment) — currently private. Original private package histories, images and records remain private; no deletion or global erasure is promised.

See `publication-plan.md` for the approval-gated sequence. Questions, licensing and private security reports: [tech@dissei.credit](mailto:tech@dissei.credit).
