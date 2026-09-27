# Running Financial Judgment 2.0.0 locally

**Local release candidate; public publication is pending approval.** These instructions operate on the complete delivered directory described in [README.md](README.md): minimal Harbor task files plus three Docker image archives. Both parts are required; images alone do not define a Harbor dataset. They do not require a live Harbor dataset or a private proxy. No hosted job, provider access or compute is provisioned by downloading the package.

## 1. Prerequisites and scope

- A Docker host able to run `linux/amd64` or `linux/arm64` containers, with Docker Compose support. Each delivered image archive contains both architectures. A containerd-backed image store can retain the multi-platform image index; a classic image store may require importing only its supported platform using Docker's supported platform-loading options.
- `uv` and Harbor **0.23.0** on the runner. The example shell syntax is POSIX-compatible except where Bash is named explicitly.
- The full `tasks/` directory, all three image archives, and the matching `image-inventory.json`. Each eight-file task retains `instruction.md`, `task.toml`, a one-line `environment/Dockerfile`, `tests/` and `solution/`. Runtime and evidence are inside the images, not duplicated under `environment/`. Do not substitute older images with similar names.
- Your own authorized agent/provider access and your own compatible judge endpoint and credentials. No commercial agent CLI is bundled; a Harbor agent that needs one installs it under its own normal requirements and provider terms.
- Sufficient resources for both phases: each task requests 2 CPUs and 4096 MB memory; agent timeout is 1800 seconds and verifier timeout is 900 seconds. Start with one concurrent trial.

Install the harness:

```bash
uv tool install harbor==0.23.0
```

Local `--path` execution does not require Harbor Hub login. Provider calls can incur charges. Decide which agent and judge may receive the prompts, answers, evidence and grading material before running; the package does not supply authorization to disclose those materials to an arbitrary provider. Never paste credentials into task files, shared commands or published logs.

## 2. Load the three clean images

From the release root, verify each archive's SHA-256 against the supplied checksum file and compare the recorded values with `image-inventory.json`. Paths in `images/SHA256SUMS` are relative to the release root. On macOS or a host with `shasum`:

```bash
shasum -a 256 -c images/SHA256SUMS
```

Do not load an archive if verification fails. After all three checks pass, load:

```bash
docker load --input images/financial-judgment-2021-12.tar.gz
docker load --input images/financial-judgment-2022-06.tar.gz
docker load --input images/financial-judgment-2022-09.tar.gz
```

Docker accepts the compressed archives directly. Expected local tags:

| Anchor | Local tag |
|---|---|
| 2021-12 | `dissei/financial-judgment-2021-12:20260927-clean` |
| 2022-06 | `dissei/financial-judgment-2022-06:20260927-clean` |
| 2022-09 | `dissei/financial-judgment-2022-09:20260927-clean` |

Inspect the loaded images:

```bash
docker image inspect dissei/financial-judgment-2021-12:20260927-clean
docker image inspect dissei/financial-judgment-2022-06:20260927-clean
docker image inspect dissei/financial-judgment-2022-09:20260927-clean
```

Check the inventory's index and platform descriptors using the identifiers exposed by your image store. An archive SHA-256, multi-platform index digest, platform manifest digest and image configuration ID identify different bytes; do not compare them interchangeably. Tags alone are mutable and do not enforce digest pinning. Loading an archive from an untrusted origin and comparing it only with a checksum from that same untrusted origin does not establish authenticity.

Load all images before running. Each task's `task.toml` selects its prebuilt `docker_image`; its one-line `environment/Dockerfile` contains only `FROM` followed by that same local image tag. This file satisfies Harbor 0.23.0's required environment layout; it does not rebuild the runtime or evidence. `tests/Dockerfile` uses the same tag as the base for the separate verifier. A missing tag can cause Docker to attempt an unrelated registry pull; the proposed tags are not a claim that public registry images exist. No runtime, evidence, wrappers, requirements or environment rebuild inputs accompany the minimal Dockerfile. Running the release requires the supplied images, not private build inputs or private image registry access.

The images contain inspectable runtime source at `/opt/dissei/runtime` and evidence at `/corpus`. Recipients controlling Docker can extract those files; image delivery is not source secrecy or an intellectual-property protection mechanism. Task-specific rubric source remains host-side in `tests/task.yaml`, with the reference answer in `solution/solve.sh`; Harbor supplies grading assets to the separate verifier rather than the task agent. Keep those files and historical answers outside agent mounts. Private environment build contexts are not part of the public delivery.

## 3. Configure the separate judge

The verifier uses an OpenAI-compatible chat-completions endpoint, with an optional Responses API mode. It has **no default judge endpoint or model**. Configure the following environment variables on your runner using your provider's secure credential workflow:

| Variable | Meaning |
|---|---|
| `DISSEI_JUDGE_BASE_URL` | Required: your judge's API base URL, reachable from the verifier container. |
| `DISSEI_JUDGE_MODEL` | Required: default model identity for all four judge roles. |
| `DISSEI_JUDGE_API_KEY` | Required unless your chosen endpoint is unauthenticated. |
| `DISSEI_JUDGE_MODEL_GRADED` | Optional model override for graded assessment. |
| `DISSEI_JUDGE_MODEL_CRITICAL` | Optional model override for critical criteria. |
| `DISSEI_JUDGE_MODEL_PITFALL` | Optional model override for pitfalls. |
| `DISSEI_JUDGE_MODEL_CONTRADICTION` | Optional model override for contradiction checks. |
| `DISSEI_JUDGE_VOTES` | Optional majority-vote count per verdict, 1–10; default 1. |
| `DISSEI_JUDGE_API` | Optional: `responses` for a Responses-only endpoint. |

An address reachable on the host is not necessarily reachable inside Docker. In particular, container loopback refers to the container itself. Supply a deployment-appropriate reachable endpoint; do not recover or reuse redacted historical infrastructure addresses.

Pass judge settings using Harbor's **`--ve KEY=VALUE`**, not agent environment options. A shell export alone does not replace explicitly forwarding the setting into the separate verifier. The commands below forward the three required settings. Forward any optional setting you choose with another `--ve`, for example `--ve DISSEI_JUDGE_VOTES=1` or `--ve DISSEI_JUDGE_API=responses`.

Harbor configurations and process arguments can contain expanded credentials. Restrict access to the runner and its output directories, avoid shell tracing, and sanitize artifacts before sharing. These examples are for a trusted local runner, not a secret-management system.

## 4. Grade one supplied reference answer

This invokes the included oracle solution and your real judge. It is a paid/API-bearing operation if your endpoint charges; it is **not** the deterministic offline release smoke and is not a model benchmark result.

```bash
harbor run --path ./tasks/fab01-2209-st06 \
  -a oracle -n 1 -k 1 \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

`-n 1` means one concurrent trial; `-k 1` means one attempt per task. To grade all seven supplied reference answers, change only the path to `--path ./tasks`. An oracle answer can receive less than full reward depending on the judge; executing it successfully does not certify grading quality.

## 5. Run your own agent

Configure the provider credentials required by Harbor's chosen agent on the runner, such as `OPENAI_API_KEY` when using the corresponding provider. Set `DISSEI_AGENT_MODEL` to the authorized `provider/model` identifier. Agent and judge credentials are separate even if you choose the same provider.

Start with one task using Terminus-2:

```bash
harbor run --path ./tasks/fab01-2209-st06 \
  -a terminus-2 -m "${DISSEI_AGENT_MODEL:?Set your authorized provider/model ID}" \
  -n 1 -k 1 --ak max_turns=40 --ak reasoning_effort=high \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

After reviewing that run, execute all seven with:

```bash
harbor run --path ./tasks \
  -a terminus-2 -m "${DISSEI_AGENT_MODEL:?Set your authorized provider/model ID}" \
  -n 1 -k 1 --ak max_turns=40 --ak reasoning_effort=high \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

These are runnable setup examples, **not exact historical replication commands**. In particular, they do not configure every provider-specific output-token limit or historical client setting. The recorded comparison used a 16,384-token output limit per request and a `gemini-3.1-pro-preview` judge with low reasoning and one vote. Consult `evaluation-protocol.json` and the sanitized selected-run configs when designing a comparable run, and record every deliberate difference. Private routes and redacted secrets are not reproduction prerequisites. Do not claim bit-identical replication from new package digests or a changed endpoint.

`dataset.toml` uses registry package names and content digests measured from the minimal task packages. It cannot resolve those packages remotely until a separately approved publication creates them. `local-task-index.json` describes local package artifacts; **use `--path ./tasks` for local execution**. Do not run at the candidate root, substitute image archives for task packages or replace the seven full tasks with preview packages.

## 6. Agent-facing dataroom

These commands run **inside the task container**, not on the host. The runtime supplies the corpus, case and anchor defaults.

| Command | Effect |
|---|---|
| `dataroom list-timelines` | List visible timeline stems and line counts. |
| `dataroom view-timeline STEM START END` | Read a line window; optional `--start-char N`. |
| `dataroom list-exhibits` | List visible exhibit IDs, titles and kinds. |
| `dataroom get-exhibit ID` | Read one exhibit. |
| `dataroom list-sources` | List visible primary sources. |
| `dataroom grep PATTERN` | Regex search; default scope is `sources`. |
| `dataroom view-source CITATION_ID START END` | Read source lines; optional `--start-char N`. |
| `dataroom status` | Read budget and submission state, without recording a retrieval. |
| `dataroom submit FILE` | Submit the final answer; required for scoring and terminal. |

Search accepts `--scope sources|timelines|exhibits|all`, `--case-sensitive`, `--max-results N` (default 20) and `--context-lines N` (default 2). Submission also supports `dataroom submit -` for standard input, `dataroom submit` with standard input by default, and `dataroom submit --text TEXT`.

The retrieval budget is 20. `status` is free and unlogged. Submission remains possible after budget exhaustion and is excluded from the verifier's retrieval-call budget check; the displayed remaining budget may nevertheless decrement on submission. Only successful dataroom retrievals earn retrieval credit. Direct file reads under `/corpus` do not earn that credit. Do not edit the episode's saved answer or retrieval log outside the tool.

The image-supplied runtime's global `--case`, `--anchor` and `--corpus-root` overrides are preserved. They precede the subcommand and are intended for controlled local inspection. Changing them is not a comparable benchmark run: the verifier still uses the task's own corpus and grading contract. The release does not silently tighten or remove the evaluated CLI behavior.

## 7. Inspect results and failures

Harbor prints the local job directory. Inspect each trial's result/error state alongside these files:

| Relative trial path | Meaning |
|---|---|
| `verifier/reward.json` | Headline continuous `reward`, when verification records one. |
| `verifier/score_breakdown.json` | Detailed scoring diagnostics when produced by grading. |
| `verifier/integrity.json` | Submission and retrieval-integrity diagnostics. |
| `artifacts/episode/` | Submitted answer, tool trajectory and episode state. |

| Situation | Verifier behavior |
|---|---|
| No valid submission | Record reward 0; no LLM grade is required. |
| Answer planted or changed outside valid submission | Treat as not submitted; reward 0. |
| Forged retrieval record | No retrieval credit for that record. |
| Rubric cannot compile | Exit 2; no reward. |
| Required judge configuration missing for a submitted answer | Exit 3; no reward. |
| Scoring exception reaches the entry point, or top-level `graded_unavailable` / `contradiction_unavailable` is true | Exit 4; no reward. The tested whole-endpoint outage and wholly unusable decisive verdicts take this path. |
| Critical-only or pitfall-only verdicts unavailable | Per-row unavailability is recorded; a reward can still be written. See the inherited limitation below. |
| Missing or malformed graded criterion diagnostics, with usable holistic score | Per-row unavailability is recorded; it does not by itself suppress the reward. |

**Inherited limitation, not a new fix:** the unavailable-result check examines top-level graded/contradiction flags, not every criterion row. Unavailable critical verdicts are excluded from the gate denominator; when none are available, `gate_score` defaults to **1.0**. Unavailable pitfall verdicts contribute no penalty. Thus isolated failures in those roles can leave a successful exit and a reward despite incomplete judging. With multiple votes, some unusable votes can be discarded while a usable aggregate remains under the existing voting rules. Review `critical_results`, `pitfall_results`, `graded_results` and their `unavailable` reasons in `score_breakdown.json`, not only the reward or trial exception. These semantics are preserved from the evaluated runtime; do not describe this release as rejecting every judge failure or silently treat unavailable diagnostics as complete judgments.

A timeout may leave a non-submission zero together with a trial exception. Do not ignore exceptions, fill missing rewards with zero or select only convenient successful attempts. Declare your selection/recovery rules and retain unsuccessful attempts. A deterministic stub judge can test mechanics only; its scores must never be ranked as model financial performance.

Both phases permit outbound network access by default. Restrict the deployment if required, while allowing the configured model/judge endpoints and any agent installation dependencies. Harbor's network restrictions depend on host capabilities; do not assume the package provides host isolation or blocks every sensitive network destination. Keep host-side rubrics, solutions and historical answers outside the agent's mounts.

## 8. Inspect the historical archive

The archive is separate from a new run. Extract it into a new local directory:

```bash
mkdir review-records
tar -xzf run-records.tar.gz -C review-records
```

Use `run-index.json` to locate pseudonymous jobs/trials, selected outcomes and archive paths. `redaction-summary.json` declares transformations; redaction markers are intentional, not missing files to retrieve from a private service.

The scope is 16 jobs and 86 attempts, not 86 independent benchmark scores. The six-model table uses 42 selected outcomes. Seven further selected outcomes belong to the separately labeled historical baseline. Execution QA/no-op/stub runs and failure/recovery attempts remain distinguishable. Historical numerical outcomes are preserved, but sanitized logs are not byte-identical originals and are not executable configurations without your own credentials and endpoints.

Local execution and archive extraction do not publish anything. Native Harbor job pages and interactive trajectories have independent access controls. Any upload or public sharing of your own run is a separate action: inspect licenses, credentials, provider terms and logs first. The package contains no automatic result upload step.
