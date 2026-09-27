# Dissei Financial Judgment — Full Evaluation Package

**Version 2.0.0 — local release candidate, prepared for public distribution; publication pending approval.** This copy does not announce a live public release. The existing GitHub and Hugging Face destinations are private. The proposed Harbor identity is new: `dissei/financial-judgment-full@2.0.0`.

Financial Judgment evaluates whether an agent can identify what matters in a financial situation, connect evidence to a conclusion, and distinguish support from uncertainty. This is the **complete seven-task evaluation package**, not question previews: all instructions, evidence, 79 rubric criteria, judge prompts, scoring implementation, reference answers, dataroom tools and separate verifier are included. Delivery has two required parts: minimal Harbor task files and three Docker image archives containing the runtime and evidence.

| Item | Scope |
|---|---|
| Tasks | Seven, one per reasoning family |
| Case | One completed private-equity transaction, with names suppressed |
| Anchors | December 2021, June 2022 and September 2022 |
| Rubric criteria | 79 total; 10–13 per task |
| Environment images | Three dated snapshots, each for `linux/amd64` and `linux/arm64` |
| Harness | Harbor 0.23.0; local task directories and separate verifier containers |
| Reward | Continuous from 0 to 1; user-configured LLM judge |
| Historical records | Sanitized derivative of 16 jobs and 86 attempts |
| Current historical comparison | 42 selected outcomes: six models × seven tasks |
| License category | Other / restricted; see [LICENSE.md](LICENSE.md) |

## Included evaluation, excluded authoring

Recipients can inspect the evaluator source, judge prompts, rubric criteria and reference answers. Runtime source and evidence are supplied inside the Docker images and can be extracted by recipients; Docker packaging does not hide code. These assets reveal how answers are graded; their inclusion is intentional and necessary for a full, runnable evaluation. This release does **not** claim to hide grading methodology or make inference about task design impossible.

Task-authoring machinery, private production workflows and unnecessary authoring/build/orchestration modules are not included. The supplied runtime is limited to running the dataroom and evaluator. Private infrastructure addresses, local operator identities and revealing historical source excerpts are removed or visibly redacted from the derivative. Required copyright and third-party notices are retained.

A separate verifier isolates grading inputs from the task agent in an ordinary Harbor run. It is **not** an intellectual-property boundary against a recipient who controls the host or can read the downloaded package. Do not give the task agent access to the host-side `tests/`, `solution/` or historical answer archive when measuring performance.

## Tasks

| Local task directory | Anchor | Family | Analytical demand | Criteria |
|---|---|---|---|---|
| `fab01-2112-dg04` | 2021-12 | Diagnostic | Diagnose a financial outcome from dated evidence. | 12 |
| `fab01-2112-pr02` | 2021-12 | Predictive | Judge how a situation may develop as of the anchor. | 11 |
| `fab01-2206-ex01` | 2022-06 | Explanatory | Explain why a development matters for an investment or financing decision. | 13 |
| `fab01-2206-qn02` | 2022-06 | Quantitative | Read an exhibit quantitatively and state its implications. | 10 |
| `fab01-2209-cf01` | 2022-09 | Counterfactual | Analyze a changed capital structure and allocation of risk. | 13 |
| `fab01-2209-cp02` | 2022-09 | Comparative | Compare an entry price with relevant public-market evidence. | 10 |
| `fab01-2209-st06` | 2022-09 | Strategic | Recommend and defend a diligence priority. | 10 |

Each task is one question at one anchor date, not a multi-step workflow. All seven draw on the same transaction. The three snapshots contain timeline narratives, exhibits and primary-source documents. Financial facts, dates, figures and source notices are preserved, not perturbed to obtain a cleaner disclosure scan. Follow each task's original instructions and the dataroom's point-in-time retrieval behavior.

**Identity treatment.** The metadata uses `identity_tier = "name_suppressed"`: case names are suppressed while the original financial facts remain. Exact dates, amounts, market data, transaction structure and combinations of details can permit re-identification. This is not a guarantee of anonymity, irreversible de-identification or freedom from linkage to external sources.

## Package layout

Run commands from the directory containing this README:

```text
README.md
USAGE.md
CHANGELOG.md
LICENSE.md
publication-plan.md
cards/
dataset.toml
local-task-index.json
.financial-judgment-owned.json
tasks/
  fab01-2112-dg04/
    instruction.md
    task.toml
    environment/
      Dockerfile
    tests/
      Dockerfile
      verify.py
      test.sh
      task.yaml
    solution/
      solve.sh
  fab01-2112-pr02/
  fab01-2206-ex01/
  fab01-2206-qn02/
  fab01-2209-cf01/
  fab01-2209-cp02/
  fab01-2209-st06/
images/
  financial-judgment-2021-12.tar.gz
  financial-judgment-2022-06.tar.gz
  financial-judgment-2022-09.tar.gz
  SHA256SUMS
image-inventory.json
run-index.json
run-records.tar.gz
evaluation-protocol.json
redaction-summary.json
```

Each task has the same eight-file layout shown for `fab01-2112-dg04`: `instruction.md` is the agent prompt; `task.toml` selects the supplied image and defines execution and metadata; `tests/` contains the task YAML, rubric source and separate-verifier entry points; `solution/solve.sh` supplies the reference answer and oracle entry point. All seven tasks and all 79 criteria remain present. Harbor 0.23.0 requires an `environment/` directory: it contains only a one-line `Dockerfile` whose `FROM` references the corresponding supplied image. No runtime, evidence, wrappers, requirements or environment rebuild inputs are duplicated there.

The three image archives supply the dataroom and evaluator runtime at `/opt/dissei/runtime` and the dated evidence at `/corpus`. The task image does not include the task-specific rubric or reference solution. Harbor builds the separate verifier using `tests/Dockerfile` on top of the corresponding loaded image; this small verifier definition is retained, not a context for rebuilding the supplied environment. All grading assets remain accessible to the package recipient.

`dataset.toml` describes the proposed registry dataset using clean task-package names and content digests measured from the minimal task packages. It is not a local-path manifest and does not mean those packages are already uploaded. The Docker archives alone are not a runnable Harbor dataset: both the images and the seven task packages are required. For local execution, use **`harbor run --path ./tasks`**, not the candidate root or the proposed remote dataset name. [USAGE.md](USAGE.md) covers image loading, credentials and exact commands.

`.financial-judgment-owned.json` is a neutral file-hash inventory used to recognize this derivative's generated files; it contains no private authoring source or identity mapping.

## Quickstart

Run these commands from the full package directory containing both `tasks/` and `images/`. If downloaded separately, combine the minimal task files and the three image assets into that layout first; a source-only download or image-only download is insufficient. You need Docker with Compose support and `uv`; use a host that supports `linux/amd64` or `linux/arm64`. No environment rebuild context is needed: load the supplied images, then run the tasks below.

### 1. Install Harbor and load the supplied images

```bash
uv tool install harbor==0.23.0
shasum -a 256 -c images/SHA256SUMS
```

Continue only if all three checksums pass:

```bash
docker load --input images/financial-judgment-2021-12.tar.gz
docker load --input images/financial-judgment-2022-06.tar.gz
docker load --input images/financial-judgment-2022-09.tar.gz
```

### 2. Configure your judge

Set `DISSEI_JUDGE_BASE_URL` to your OpenAI-compatible API base URL and `DISSEI_JUDGE_MODEL` to your chosen judge model. Supply `DISSEI_JUDGE_API_KEY` through your normal secret-management workflow; it may be empty only for an intentionally unauthenticated endpoint. The endpoint must be reachable from inside Docker, not just from the host.

**The following runs send evidence, answers and grading material to your chosen provider and may incur charges.** Use an authorized endpoint. Harbor's saved configuration and process arguments can contain credentials: keep run directories private and do not enable shell tracing.

### 3. Run one included reference solution

```bash
harbor run --path ./tasks/fab01-2209-st06 \
  -a oracle -n 1 -k 1 \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

This executes the supplied reference answer and grades it; it is not a model benchmark or a guarantee of full reward. To run all seven reference solutions, replace the path with `./tasks`.

### 4. Evaluate your agent on all seven tasks

Configure the agent provider's credentials separately and set `DISSEI_AGENT_MODEL` to its authorized `provider/model` identifier:

```bash
harbor run --path ./tasks \
  -a terminus-2 -m "${DISSEI_AGENT_MODEL:?Set your agent provider/model}" \
  -n 1 -k 1 --ak max_turns=40 --ak reasoning_effort=high \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

Here `-n 1` limits concurrency to one trial and `-k 1` selects one attempt per task. Inspect the job directory printed by Harbor: each trial's `verifier/reward.json`, `verifier/score_breakdown.json` and `verifier/integrity.json`, together with its exception state. Missing required judge configuration and reported graded/contradiction unavailability produce errors without a reward. A reward file does not prove every judge role succeeded: inspect per-criterion `unavailable` flags and the inherited limitation below.

These are local setup commands, not exact historical replication settings. No Harbor Hub login or public registry upload is required after loading the supplied images. For optional judge settings, network configuration, dataroom commands and troubleshooting, see [the full run guide](USAGE.md).


## Reward and verifier

The evaluator preserves the original task-specific rubrics, judge prompts, scoring math and reference answers:

- Critical criteria gate or scale the score according to which required claims are satisfied.
- Graded assessment returns a holistic 0–10 judgment and per-criterion pass, partial or fail diagnostics; criterion weights guide the assessment.
- Negative-weight pitfall criteria penalize specified reasoning errors.
- A contradiction finding halves the score.
- A retrieval modulator between 0.7 and 1.0 can reduce, but never increase, the answer score according to credited evidence retrieval.

The verifier runs in a fresh container and receives only declared episode artifacts from the agent. It checks submission provenance, replays retrievals against its own corpus and enforces the dataroom call budget. A missing or invalid submission receives zero. Missing required judge configuration produces exit 3 without a reward. A scoring exception that reaches the entry point, or a breakdown with top-level `graded_unavailable` or `contradiction_unavailable`, produces exit 4 without a reward. These checks do not reject every per-role judge failure. See [USAGE.md](USAGE.md) for error states and output files.

**Inherited judge-failure limitation, preserved rather than fixed:** unavailable critical verdicts are flagged in `critical_results` but excluded from the gate denominator; if no critical verdicts are available, `gate_score` defaults to **1.0**. Unavailable pitfall verdicts are flagged in `pitfall_results` and contribute no penalty. Neither per-row condition triggers the top-level unavailable check, so a critical-only or pitfall-only failure can still produce a reward. Missing or malformed graded criterion diagnostics can likewise coexist with a usable holistic score. With multiple judge votes, some unusable votes can be discarded while an aggregate verdict remains usable under the existing voting rules. Inspect diagnostics, not just process success or the headline reward. This release preserves those scoring semantics; it does not claim fail-closed handling of every judge failure or a new hardening fix.

The measured capability combines evidence retrieval, financial reasoning, judged writing and harness control. It is not a pure financial-reasoning test. The historical agent protocol allowed 20 dataroom calls, 40 turns and 30 minutes per task. A model that never submits receives zero without an LLM grade.

### What the failure-case checks mean

The release checks deliberately injected failure and edge conditions; they were not 20 failed tests or spontaneous model failures. Ten scenarios ran on both `linux/amd64` and `linux/arm64`, comparing the original and cleaned runtime on `fab01-2209-cf01`. Separate reference-answer comparisons covered all seven tasks.

The responsibilities are distinct:

- **Dataroom runtime:** tracks the retrieval budget and records evidence access and final submission.
- **Dissei verifier:** checks submission integrity, replays retrievals against the corpus, rejects tampering and handles judge failures.
- **Harbor:** runs the agent and verifier phases, transfers declared artifacts and records rewards or trial errors.

| Injected condition | Verified behavior |
|---|---|
| No submission | Reward 0; no judge call. |
| Retrieval budget exhausted, then submission | Submission remains accepted; terminal submission is not counted as an extra retrieval. |
| Forged evidence-retrieval record | Replay mismatch detected; integrity marked failed. |
| Answer edited after submission | Invalid submission; reward 0 and no judge call. |
| Missing judge configuration | Verifier exits 3; no reward file. |
| Whole judge endpoint unreachable in the injected scenario | Verifier exits 4; no fabricated zero score. |
| Wholly unusable decisive judge verdicts in the injected scenario | Verifier exits 4; no reward file. |
| Forged calls beyond the budget | Excess records dropped; integrity marked failed. |
| Answer file planted without submission | Reward 0; no judge call. |
| Old reward file present, followed by configuration failure | Stale reward is not reused; verifier exits 3 with no reward file. |

All comparisons matched the original behavior. Two additional cutoff checks confirmed that later-dated evidence remained inaccessible on both architectures.

The checked distinction is narrower than a blanket judge-failure guarantee: **an absent or invalid agent submission receives zero; the injected whole-endpoint outage and wholly unusable decisive verdicts produced errors without scores.** Per-role or per-criterion unavailability can still yield a reward as described above. These checks establish that sanitization preserved the tested execution rules, not that every judge failure is excluded from scoring. They do not establish that Harbor caused any historical model failure; that requires inspecting the particular recorded attempt.

## Preserved historical results

### Preliminary comparison recorded on 2026-09-24–25 (UTC)

The following numbers are **historical outcomes**, not a new evaluation of version 2.0.0. Their original task-version provenance and selection rules remain in the records. Sanitization and new package/image digests do not retroactively change the versions on which models ran.

The selected GLM-5.3 recovery completed at 2026-09-25T00:46:07Z; the other 41 selected outcomes completed on 2026-09-24 UTC.

The comparison used Harbor 0.23.0, Terminus-2's JSON harness, high agent reasoning, 40 turns, a 16,384-token output limit per request and one selected outcome per task. The common judge was `gemini-3.1-pro-preview`, with low reasoning and one vote. Provider/model identities and parameters are retained; private endpoint details are redacted. Different provider clients can frame requests differently.

Reward / 100 is the equal-weight mean of seven saved continuous task rewards, multiplied by 100. Means use unrounded rewards before display. This is not accuracy, a probability of correctness or a percentage of professional work completed.

| Model | Reward / 100 | Submitted / 7 |
|---|---|---|
| Claude Fable 5.1 | 60.73 | 7 |
| GPT-6 Astra | 52.45 | 7 |
| Claude Opus 5.5 | 52.17 | 7 |
| GLM-5.3 | 44.91 | 7 |
| Kimi K3 | 35.79 | 7 |
| Gemini 3.8 Flash | 9.01 | 1 |

| Task | Claude Fable 5.1 | GPT-6 Astra | Claude Opus 5.5 | GLM-5.3 | Kimi K3 | Gemini 3.8 Flash |
|---|---|---|---|---|---|---|
| `fab01-2112-dg04` | 0.7882 | 0.7338 | 0.7094 | 0.4892 | 0.0000 | 0.6306 |
| `fab01-2112-pr02` | 0.7094 | 0.7338 | 0.7094 | 0.5708 | 0.5518 | 0.0000 |
| `fab01-2206-ex01` | 0.4570 | 0.2285 | 0.2285 | 0.2285 | 0.2340 | 0.0000 |
| `fab01-2206-qn02` | 0.4333 | 0.4000 | 0.4333 | 0.5000 | 0.3467 | 0.0000 |
| `fab01-2209-cf01` | 0.6688 | 0.5320 | 0.5964 | 0.6080 | 0.5250 | 0.0000 |
| `fab01-2209-cp02` | 0.7455 | 0.7455 | 0.7455 | 0.5218 | 0.6171 | 0.0000 |
| `fab01-2209-st06` | 0.4490 | 0.2982 | 0.2294 | 0.2251 | 0.2307 | 0.0000 |
| **Equal-weight mean** | **0.6073** | **0.5245** | **0.5217** | **0.4491** | **0.3579** | **0.0901** |

**Selection and failures.** The 42 selected outcomes cover six models, not all 86 retained attempts. Genuine non-submission zeros are retained; unresolved trial exceptions are not converted into model-quality scores. Infrastructure recovery attempts remain linked in the sanitized records. No successful trial was rerun to seek a higher score.

- Gemini 3.8 Flash submitted once; six selected attempts reached the 40-turn cap, and the JSON parser rejected 50 responses. Five infrastructure-failed tasks were retried, while the original valid submission and genuine no-submission zero were retained. Its score is protocol-limited.
- GLM-5.3 retained six original successful outcomes. The remaining task's original timeout and interrupted recovery are preserved alongside the completed recovery, which scored 0.608 on `fab01-2209-cf01`.
- Kimi K3's zero on `fab01-2112-dg04` is a judged critical-criterion failure, not a non-submission.
- The separately labeled historical Gemini 3.1 Pro baseline has seven selected outcomes, seven submissions and mean reward 0.3124. It is not a seventh row in the six-model comparison above.

### Record scope and redaction

`run-records.tar.gz` preserves the full 16-job, 86-attempt audit scope, including the current comparison, historical baseline, failures, recoveries and separately labeled execution QA/no-op/stub runs. Numerical rewards, score breakdowns, model identities and selection relationships are retained. Archive content is a declared sanitized derivative, not a claim of byte-identical original logs.

`run-index.json` links stable pseudonymous jobs and trials to archive paths and selected outcomes. `evaluation-protocol.json` records historical settings and provenance; historical task digests are **not** executable dependencies of the new release. `redaction-summary.json` describes replaced identities, infrastructure and source excerpts. Redaction covers duplicated representations, including trajectories and terminal recordings. Original private records and the private identity mapping are not distributed. Native Harbor job pages are separate resources and are not made public by releasing this archive.

### Limits and local execution checks

No new model benchmark results are claimed for this release. Deterministic local judge smoke runs are checks of dataroom, submission, verifier and scoring mechanics, **not** evidence that the judge correctly assesses finance or that historical rankings replicate. Release preparation does not establish a repeated-run variance estimate, contamination-free status or independent certification.

This is a small, single-case pilot with one selected outcome per model/task. It does not measure general financial knowledge, spreadsheet/model-building skill or long-horizon workflows. Small score differences are not established as statistically significant. Public access to reference answers also matters when designing future uncontaminated evaluations; disclose prior exposure and keep independent holdouts separate.

## Running and rights

Use your own Docker host, agent/provider access and judge credentials. No private proxy, Dissei-operated grading service or bundled commercial agent CLI is required. Model and judge calls can incur charges and transmit prompts, evidence or answers to your chosen provider; select endpoints and spending limits deliberately. Local runs do not automatically upload results.

The owner has confirmed authority to redistribute the included source material. That confirmation is **not** a blanket permissive license for downstream training, adaptation or redistribution. Copyright and source-specific notices remain effective. Public availability and permitted reuse are different questions; see [LICENSE.md](LICENSE.md), and obtain any rights not already granted by applicable terms. This full distribution proposal is not limited to hosted-only evaluation or question previews.

## Proposed destinations — not live-release claims

- New Harbor dataset: [dissei/financial-judgment-full](https://hub.harborframework.com/datasets/dissei/financial-judgment-full), proposed version `2.0.0`.
- Existing GitHub mirror target, currently private: [Dissei-org/financial-judgment](https://github.com/Dissei-org/financial-judgment).
- Existing Hugging Face mirror target, currently private: [Dissei-Data/Dissei-Financial-Judgment](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment).

The new Harbor package history must contain only reviewed release bytes. Existing private package/image histories and original records remain private and unchanged. See [publication-plan.md](publication-plan.md) for the approval-gated sequence; no upload, visibility change or deletion is authorized by this document.

Questions, licensing and private security reports: [tech@dissei.credit](mailto:tech@dissei.credit). When reporting a run, identify task and image digests, model identities, harness/judge settings, attempts, selection and failures. Do not publish credentials or unreviewed logs.
