# Dissei Financial Judgment

[Harbor](https://hub.harborframework.com/datasets/dissei/financial-judgment-full) · [GitHub](https://github.com/Dissei-org/financial-judgment) · [Website](https://dissei.ai) · [Hugging Face](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment)

Dissei explores financial reasoning and analysis behind institutional investment and credit decisions: interpreting evidence, weighing trade-offs and reaching well-supported conclusions.

Seven tasks follow one completed private-equity deal at three dates: December 2021, June 2022 and September 2022. Each asks for a written judgment based on dated evidence and has a task-specific rubric. Version 2.0.0 includes all instructions, evidence, 79 rubric criteria, judge prompts, scoring code, reference answers, dataroom tools and a separate verifier.

## Quickstart

### Download the release

You need Git, the GitHub CLI (`gh`), Docker with Compose support and `uv`, on a host supporting `linux/amd64` or `linux/arm64`. Start in a parent directory where `financial-judgment-v2.0.0` does not already exist. These commands clone the task files into a new directory and download the three Docker image archives containing the runtime and evidence:

```bash
git clone --branch v2.0.0 --depth 1 \
  https://github.com/Dissei-org/financial-judgment.git financial-judgment-v2.0.0 &&
cd financial-judgment-v2.0.0 &&
gh release download v2.0.0 --repo Dissei-org/financial-judgment \
  --pattern 'financial-judgment-*.tar.gz' --dir images
```

Continue after the clone and all downloads succeed. Both parts are required: the repository provides `tasks/`, `images/SHA256SUMS`, the run guide and historical attachments; the image archives provide the runtime and evidence. Docker loads the compressed archives directly. Keep them under `images/` rather than unpacking them as task folders.

For direct downloads, save each archive below under the cloned repository's `images/` directory. The matching [SHA256SUMS](https://github.com/Dissei-org/financial-judgment/releases/download/v2.0.0/SHA256SUMS) is already included at `images/SHA256SUMS`; [image-inventory.json](https://github.com/Dissei-org/financial-judgment/releases/download/v2.0.0/image-inventory.json) records image/platform digests. Keep files from different releases separate.

| Snapshot | Docker image archive | SHA-256 |
|---|---|---|
| 2021-12 | [financial-judgment-2021-12.tar.gz](https://github.com/Dissei-org/financial-judgment/releases/download/v2.0.0/financial-judgment-2021-12.tar.gz) | `5f945820221ca7b3972b3044b2c5ac337eb6e39b0aff6e56bd1e7dfabb932edf` |
| 2022-06 | [financial-judgment-2022-06.tar.gz](https://github.com/Dissei-org/financial-judgment/releases/download/v2.0.0/financial-judgment-2022-06.tar.gz) | `f61750f2e4a1e84a3f5c80293c8758e7304d564808e92d16b7e62ba8b6180675` |
| 2022-09 | [financial-judgment-2022-09.tar.gz](https://github.com/Dissei-org/financial-judgment/releases/download/v2.0.0/financial-judgment-2022-09.tar.gz) | `b82a59b92f2bb1285cefff6923d01e9b5b3c7d3d1283173f991e0f4f66f39d6a` |

The [GitHub release](https://github.com/Dissei-org/financial-judgment/releases/tag/v2.0.0) and [Harbor dataset](https://hub.harborframework.com/datasets/dissei/financial-judgment-full) are public. The same release is available through [Hugging Face files](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment/tree/main), with login and manually approved access required for downloads and the gated viewer. Hugging Face approval applies only to that mirror.

Run the remaining commands from the package directory containing both `tasks/` and `images/`. If you downloaded the files separately, arrange them in that layout first. Use the supplied images directly; no environment rebuild is needed. You provide the Docker host, agent/provider access and judge credentials.

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

Set `DISSEI_JUDGE_BASE_URL` to your OpenAI-compatible API base URL and `DISSEI_JUDGE_MODEL` to your chosen judge model. Supply `DISSEI_JUDGE_API_KEY` through your normal secret-management workflow; it may be empty only for an intentionally unauthenticated endpoint. The endpoint must be reachable from inside Docker.

These runs send evidence, answers and grading material to your chosen provider and may incur charges. Use an authorized endpoint. Harbor's saved configuration and process arguments can contain credentials: keep run directories private and do not enable shell tracing.

### 3. Run one included reference solution

```bash
harbor run --path ./tasks/fab01-2209-st06 \
  -a oracle -n 1 -k 1 \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

This executes and grades the supplied reference answer. Use it to check your setup; the reference answer can receive less than full reward. To run all seven reference solutions, replace the path with `./tasks`. Step 4 runs your agent for a model evaluation.

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

Here `-n 1` limits concurrency to one trial and `-k 1` selects one attempt per task. Inspect the job directory printed by Harbor: each trial's `verifier/reward.json`, `verifier/score_breakdown.json` and `verifier/integrity.json`, together with its exception state. Missing required judge configuration and top-level `graded_unavailable` or `contradiction_unavailable` flags produce errors without a reward. Per-role failures can still produce a reward, so also inspect each criterion's `unavailable` flag and the judge-failure limitation below.

These commands cover local setup. Historical settings are recorded separately in `evaluation-protocol.json`. After loading the supplied images, local runs require neither a Harbor Hub login nor a public registry upload. For optional judge settings, network configuration, dataroom commands and troubleshooting, see [the full run guide](https://github.com/Dissei-org/financial-judgment/blob/main/USAGE.md).

## Package at a glance

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
| License category | Other / restricted; see [LICENSE.md](https://github.com/Dissei-org/financial-judgment/blob/v2.0.0/LICENSE.md) |

## Evaluation materials and access

The package includes evaluator source, judge prompts, rubric criteria and reference answers. Recipients can also extract the runtime source and evidence from the Docker images. These materials make the grading method available for inspection and can reveal aspects of task design.

The runtime contains the dataroom and evaluator. Task-authoring machinery, private production workflows and unnecessary authoring, build and orchestration modules are excluded. Private infrastructure addresses, local operator identities and revealing historical source excerpts have been removed or visibly redacted. Required copyright and third-party notices are retained.

A separate verifier keeps grading inputs apart from the task agent during an ordinary Harbor run. A recipient who controls the host or downloaded package can still read them. When measuring agent performance, keep host-side `tests/`, `solution/` and the historical answer archive outside the task agent's access.

## Tasks

| Local task directory | Anchor | Family | Analytical demand | Criteria |
|---|---|---|---|---|
| [`fab01-2112-dg04`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2112-dg04) | 2021-12 | Diagnostic | Diagnose a financial outcome from dated evidence. | 12 |
| [`fab01-2112-pr02`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2112-pr02) | 2021-12 | Predictive | Judge how a situation may develop as of the anchor. | 11 |
| [`fab01-2206-ex01`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2206-ex01) | 2022-06 | Explanatory | Explain why a development matters for an investment or financing decision. | 13 |
| [`fab01-2206-qn02`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2206-qn02) | 2022-06 | Quantitative | Read an exhibit quantitatively and state its implications. | 10 |
| [`fab01-2209-cf01`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2209-cf01) | 2022-09 | Counterfactual | Analyze a changed capital structure and allocation of risk. | 13 |
| [`fab01-2209-cp02`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2209-cp02) | 2022-09 | Comparative | Compare an entry price with relevant public-market evidence. | 10 |
| [`fab01-2209-st06`](https://github.com/Dissei-org/financial-judgment/tree/v2.0.0/tasks/fab01-2209-st06) | 2022-09 | Strategic | Recommend and defend a diligence priority. | 10 |

Each task is one question at one anchor date. All seven draw on the same transaction. The three evidence snapshots contain timeline narratives, exhibits and primary-source documents, with the original financial facts, dates, figures and source notices preserved. Follow each task's instructions and the dataroom's point-in-time retrieval behavior.

The metadata records `identity_tier = "name_suppressed"`: case names are suppressed while original financial facts remain. Exact dates, amounts, market data, transaction structure and combinations of details can permit re-identification or linkage to external sources. Names suppressed in this way do not guarantee anonymity or irreversible de-identification.

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

Each task uses the eight-file layout shown for `fab01-2112-dg04`. `instruction.md` is the agent prompt. `task.toml` selects the supplied image and defines execution and metadata. `tests/` contains the task YAML, rubric source and separate-verifier entry points. `solution/solve.sh` supplies the reference answer and oracle entry point. Together, the seven task packages contain all 79 criteria.

Harbor 0.23.0 requires an `environment/` directory. Each contains only a one-line `Dockerfile` whose `FROM` references the corresponding supplied image. The package uses that image directly and omits environment rebuild inputs.

The three image archives supply the dataroom and evaluator runtime at `/opt/dissei/runtime` and the dated evidence at `/corpus`. Task-specific rubrics and reference solutions are kept in the task packages, outside the task image. Harbor builds the separate verifier from `tests/Dockerfile` on top of the corresponding loaded image. That small build adds the verifier; it relies on the supplied environment image. All grading assets remain accessible to the package recipient.

`dataset.toml` describes the published registry dataset, with task-package names and content digests measured from the minimal task packages. For the local task directories, use `harbor run --path ./tasks`. Both the task packages and loaded images are required. The [Harbor dataset](https://hub.harborframework.com/datasets/dissei/financial-judgment-full) and its seven task packages are public. Hosted New Job support and remote `--dataset` execution have not been validated by these local commands. [USAGE.md](https://github.com/Dissei-org/financial-judgment/blob/main/USAGE.md) covers image loading, credentials and exact commands.

`.financial-judgment-owned.json` is a file-hash inventory used to recognize this derivative's generated files. It contains no private authoring source or identity mapping.

## Reward and verifier

The evaluator uses the original task-specific rubrics, judge prompts, scoring math and reference answers:

- Critical criteria gate or scale the score according to which required claims are satisfied.
- Graded assessment returns a holistic 0–10 judgment and per-criterion pass, partial or fail diagnostics; criterion weights guide the assessment.
- Negative-weight pitfall criteria penalize specified reasoning errors.
- A contradiction finding halves the score.
- A retrieval modulator between 0.7 and 1.0 can reduce, but never increase, the answer score according to credited evidence retrieval.

The verifier runs in a fresh container and receives only declared episode artifacts from the agent. It checks submission provenance, replays retrievals against its own corpus and enforces the dataroom call budget. A missing or invalid submission receives zero. Missing required judge configuration produces exit 3 without a reward. A scoring exception that reaches the entry point, or a breakdown with top-level `graded_unavailable` or `contradiction_unavailable`, produces exit 4 without a reward. See [USAGE.md](https://github.com/Dissei-org/financial-judgment/blob/main/USAGE.md) for error states and output files.

### Judge-failure limitation

The inherited evaluator can return a reward when some judge roles are unavailable. Unavailable critical verdicts are flagged in `critical_results` and excluded from the gate denominator. If no critical verdicts are available, `gate_score` defaults to 1.0. Unavailable pitfall verdicts are flagged in `pitfall_results` and contribute zero penalty. Neither per-row condition triggers the top-level unavailable check, so a critical-only or pitfall-only failure can still produce a reward.

Missing or malformed graded criterion diagnostics can coexist with a usable holistic score. With multiple judge votes, unusable votes can be discarded while an aggregate verdict remains usable under the existing voting rules. Read the per-criterion diagnostics alongside the reward and process status. Version 2.0.0 retains these scoring rules and their failure-handling limits.

Scores combine evidence retrieval, financial reasoning, judged writing and harness control. The historical agent protocol allowed 20 dataroom calls, 40 turns and 30 minutes per task. A model that never submits receives zero without an LLM grade.

### Failure-case checks

Twenty failure-case comparisons covered ten deliberately injected scenarios on both `linux/amd64` and `linux/arm64`. They compared the original and cleaned runtime on `fab01-2209-cf01`; all comparisons matched. These were controlled checks of failure handling. Separate reference-answer comparisons covered all seven tasks.

The dataroom runtime tracks the retrieval budget and records evidence access and final submission. The Dissei verifier checks submission integrity, replays retrievals against the corpus, rejects tampering and handles judge failures as described above. Harbor runs the agent and verifier phases, transfers declared artifacts and records rewards or trial errors.

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

Two additional cutoff checks confirmed that later-dated evidence remained inaccessible on both architectures.

The comparisons establish that the cleaned runtime preserved the tested execution rules. An absent or invalid submission received zero; the injected whole-endpoint outage and wholly unusable decisive verdicts produced errors without scores. Per-role or per-criterion unavailability can still yield a reward as described above. Determining the cause of a historical model failure, including any role played by Harbor, requires inspecting that recorded attempt.

## Historical results

### Preliminary comparison recorded on 2026-09-24–25 (UTC)

These results were recorded before version 2.0.0. The records retain their original task-version provenance and selection rules. The release's new package and image digests leave that historical provenance unchanged.

The selected GLM-5.3 recovery completed at 2026-09-25T00:46:07Z; the other 41 selected outcomes completed on 2026-09-24 UTC.

The comparison used Harbor 0.23.0, Terminus-2's JSON harness, high agent reasoning, 40 turns, a 16,384-token output limit per request and one selected outcome per task. The common judge was `gemini-3.1-pro-preview`, with low reasoning and one vote. Provider/model identities and parameters are retained; private endpoint details are redacted. Different provider clients can frame requests differently.

Reward / 100 is the equal-weight mean of seven saved continuous task rewards, multiplied by 100. Means use unrounded rewards before display. This measure describes reward under the specified rubric, harness and judge; it cannot be read as accuracy, probability of correctness or percentage of professional work completed.

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

### Selection and failures

The 42 selected outcomes cover six models within the 86 retained attempts. Genuine non-submission zeros are retained. Unresolved trial exceptions remain recorded as exceptions and are excluded from model-quality scores. Infrastructure recovery attempts remain linked in the sanitized records. No successful trial was rerun to seek a higher score.

- Gemini 3.8 Flash submitted once; six selected attempts reached the 40-turn cap, and the JSON parser rejected 50 responses. Five infrastructure-failed tasks were retried, while the original valid submission and genuine no-submission zero were retained. Its score is protocol-limited.
- GLM-5.3 retained six original successful outcomes. The remaining task's original timeout and interrupted recovery are preserved alongside the completed recovery, which scored 0.608 on `fab01-2209-cf01`.
- Kimi K3 submitted on `fab01-2112-dg04` and received zero for a judged critical-criterion failure.
- The separately labeled historical Gemini 3.1 Pro baseline has seven selected outcomes, seven submissions and mean reward 0.3124. It sits outside the six-model comparison above.

### Records and redaction

`run-records.tar.gz` contains sanitized records from all 16 jobs and 86 attempts: the current comparison, historical baseline, failures, recoveries and separately labeled execution QA/no-op/stub runs. Numerical rewards, score breakdowns, model identities and selection relationships are retained. The archive is a sanitized derivative of the original logs.

`run-index.json` links stable pseudonymous jobs and trials to archive paths and selected outcomes. `evaluation-protocol.json` records historical settings and provenance; its historical task digests identify past runs and are not executable dependencies of this release. `redaction-summary.json` describes replaced identities, infrastructure and source excerpts. Redaction covers duplicated representations, including trajectories and terminal recordings. Original private records and the private identity mapping remain private. Native Harbor job pages have separate access controls.

### Limits

Version 2.0.0 carries forward the historical results without a new model benchmark. Deterministic local judge smoke runs checked dataroom, submission, verifier and scoring mechanics. Finance-grading validity and replication of historical rankings remain unestablished by those checks. The release also provides no repeated-run variance estimate, contamination-free assurance or independent certification.

This small, single-case pilot has one selected outcome per model/task. Its scope excludes general financial knowledge, spreadsheet/model-building skill and long-horizon workflows. Scores reflect retrieval, writing and harness use alongside financial reasoning. The statistical significance of small score differences has not been established. Reference answers are public: disclose prior exposure when reporting future evaluations and keep independent holdouts separate.

## Running and rights

Run locally with your own Docker host, agent/provider access and judge credentials. A private proxy, Dissei-operated grading service and bundled commercial agent CLI are unnecessary. Downloading the package does not provision a hosted job, provider account or judge. Model and judge calls can incur charges and transmit prompts, evidence or answers to your chosen provider; select endpoints and spending limits deliberately. Local runs do not automatically upload results.

The owner has confirmed authority to redistribute the included source material. Downstream training, adaptation and redistribution remain subject to the applicable rights and terms. Copyright and source-specific notices remain effective. See [LICENSE.md](https://github.com/Dissei-org/financial-judgment/blob/v2.0.0/LICENSE.md), and obtain any rights not already granted. Public access alone grants no additional reuse rights.

## Published destinations and access

- [GitHub repository](https://github.com/Dissei-org/financial-judgment) and [version 2.0.0 release](https://github.com/Dissei-org/financial-judgment/releases/tag/v2.0.0): public; task files and historical attachments are in the repository, and the three Docker archives are release assets.
- [Harbor dataset](https://hub.harborframework.com/datasets/dissei/financial-judgment-full): public `dissei/financial-judgment-full@2.0.0`, with seven public task packages.
- [Hugging Face files](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment/tree/main): public mirror with manual gating; login and approved access are required for file downloads and the gated viewer. GitHub and Harbor copies remain publicly accessible.

Existing private package/image histories and original records remain private and unchanged. [publication-plan.md](https://github.com/Dissei-org/financial-judgment/blob/v2.0.0/publication-plan.md) records the plan written before publication. Native Harbor job pages and interactive trajectories retain separate access controls.

Run instructions: [Quickstart](#quickstart) · [Full run guide](https://github.com/Dissei-org/financial-judgment/blob/main/USAGE.md).

Questions, licensing and private security reports: [tech@dissei.credit](mailto:tech@dissei.credit). When reporting a run, identify task and image digests, model identities, harness/judge settings, attempts, selection and failures. Do not publish credentials or unreviewed logs.
