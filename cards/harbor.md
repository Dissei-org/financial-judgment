# Dissei Financial Judgment — Full Evaluation Package

**Proposed new dataset: `dissei/financial-judgment-full@2.0.0`. Local release candidate; public publication pending approval.** This card does not claim the dataset or task packages exist publicly, that image downloads are live, or that a hosted New Job environment has been provisioned.

Financial Judgment measures point-in-time financial analysis: identifying material evidence, explaining its implications and reaching a calibrated conclusion. The package contains **all seven runnable tasks and 79 rubric criteria**, not question previews. Delivery has two required parts: minimal Harbor task files and three Docker image archives. Together they include instructions, evidence, task YAML, rubrics, judge prompts, scoring implementation, reference answers, dataroom tools and separate-verifier assets. Image archives alone are not a Harbor dataset.

## Seven complete tasks

These are proposed new task identities, all version `2.0.0`. Local instance IDs are retained for comparison with historical records.

| Proposed task package | Local instance | Anchor | Family | Criteria |
|---|---|---|---|---|
| `dissei/financial-judgment-dg04` | `fab01-2112-dg04` | 2021-12 | Diagnostic | 12 |
| `dissei/financial-judgment-pr02` | `fab01-2112-pr02` | 2021-12 | Predictive | 11 |
| `dissei/financial-judgment-ex01` | `fab01-2206-ex01` | 2022-06 | Explanatory | 13 |
| `dissei/financial-judgment-qn02` | `fab01-2206-qn02` | 2022-06 | Quantitative | 10 |
| `dissei/financial-judgment-cf01` | `fab01-2209-cf01` | 2022-09 | Counterfactual | 13 |
| `dissei/financial-judgment-cp02` | `fab01-2209-cp02` | 2022-09 | Comparative | 10 |
| `dissei/financial-judgment-st06` | `fab01-2209-st06` | 2022-09 | Strategic | 10 |

All tasks concern one completed transaction. Each is a single question at one decision date. Three image snapshots support `linux/amd64` and `linux/arm64`; evidence, exact financial facts and source notices remain unchanged.

**Inspectability:** the evaluator, rubrics, judge prompts and reference answers disclose grading methods by design. Runtime source and evidence remain inside the supplied images and can be extracted by recipients; Docker does not hide code. Separate-verifier execution limits ordinary task-agent access to task-specific grading files; it does not hide them from recipients who control the host. Task-authoring machinery and unrelated private production workflows are excluded. No inference-proof guarantee is made.

**Identity:** case names are suppressed (`name_suppressed`), but dates, amounts and market figures are retained. These facts can permit re-identification; name suppression is not a guarantee of anonymity.

## Run locally with Harbor 0.23.0

Use the complete release mirror layout with `tasks/fab01-*/`, the root attachments and the three `images/` archives. Each task has eight files: `instruction.md`, `task.toml`, `environment/Dockerfile`, `tests/Dockerfile`, `tests/verify.py`, `tests/test.sh`, `tests/task.yaml` and `solution/solve.sh`. The host-side task YAML retains rubric source, and the solution retains the reference answer. Harbor 0.23.0 requires `environment/`; it contains only a one-line `Dockerfile` with `FROM` referencing the supplied image. Runtime and evidence come from that image, with no duplicated runtime/evidence directory or public environment rebuild inputs. `tests/Dockerfile` builds the separate verifier from the same loaded image.

The existing mirror targets are currently private: [GitHub](https://github.com/Dissei-org/financial-judgment) and [Hugging Face](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment). Image delivery and exact release links are pending approval; do not assume the local image tags are publicly pullable. Recipients need both the task packages and the image archives, whether delivered together or downloaded separately.

From a complete local mirror, check archive hashes against `images/SHA256SUMS` and `image-inventory.json`, then load:

```bash
docker load --input images/financial-judgment-2021-12.tar.gz
docker load --input images/financial-judgment-2022-06.tar.gz
docker load --input images/financial-judgment-2022-09.tar.gz
```

Supply your own authorized agent/provider access and judge credentials. From the mirror root:

```bash
harbor run --path ./tasks \
  -a terminus-2 -m "${DISSEI_AGENT_MODEL:?Set your authorized provider/model ID}" \
  -n 1 -k 1 --ak max_turns=40 --ak reasoning_effort=high \
  --ve DISSEI_JUDGE_BASE_URL="${DISSEI_JUDGE_BASE_URL:?Set your judge base URL}" \
  --ve DISSEI_JUDGE_MODEL="${DISSEI_JUDGE_MODEL:?Set your judge model}" \
  --ve DISSEI_JUDGE_API_KEY="${DISSEI_JUDGE_API_KEY:-}"
```

Use `--path ./tasks/fab01-2209-st06` to start with one task. The manifest pins content digests measured from the minimal task packages for future registry resolution; it is not a local-path manifest and does not establish that a remote `--dataset` run works before publication. A direct Harbor export can use a different directory layout; the command above is specifically for the documented full mirror after image loading. `USAGE.md` provides image, credential, output and failure details.

The separate verifier has no default judge endpoint or model. `--ve` forwards your settings into it. No private proxy, bundled commercial agent CLI or Dissei-hosted scoring service is required. Calls may incur charges and send evidence/answers to the provider you select. Local jobs are not automatically uploaded. The generic New Job or Run interface is not proof of hosted execution support.

Each task has a 20-call dataroom retrieval budget and a 30-minute agent timeout. The historical harness used 40 agent turns. The verifier checks submission provenance and replays credited retrievals before applying the original rubric. A valid non-submission zero is distinct from an error without a reward. Missing required judge configuration produces exit 3; a scoring exception reaching the entry point or top-level `graded_unavailable` / `contradiction_unavailable` produces exit 4. The tested whole-endpoint outage and wholly unusable decisive verdicts take the latter path, but not every judge failure does. Read trial errors and score diagnostics alongside rewards.

**Inherited judge-failure limitation, not a new fix:** critical/pitfall per-row unavailability does not itself prevent a reward. Unavailable critical verdicts are excluded from the gate denominator; with no available critical verdicts, `gate_score` defaults to **1.0**. Unavailable pitfall verdicts add no penalty. Missing or malformed graded criterion diagnostics can coexist with a usable holistic score, and multiple-vote aggregation can retain a usable verdict despite some unusable votes. These scoring semantics are preserved, not newly hardened. A reward file is not proof of complete judging; inspect per-row `unavailable` flags in `score_breakdown.json`. See `USAGE.md` for details.

## Historical comparison

These results were recorded on 2026-09-24–25 (UTC) and preserved, including a GLM-5.3 recovery completed after midnight UTC; they are not new version-2.0.0 model evaluations. Reward / 100 is the equal-weight mean of seven continuous task rewards, multiplied by 100, not accuracy.

| Model | Historical reward / 100 | Submitted / 7 |
|---|---|---|
| Claude Fable 5.1 | 60.73 | 7 |
| GPT-6 Astra | 52.45 | 7 |
| Claude Opus 5.5 | 52.17 | 7 |
| GLM-5.3 | 44.91 | 7 |
| Kimi K3 | 35.79 | 7 |
| Gemini 3.8 Flash | 9.01 | 1 |

The 42 selected outcomes used the same seven historical task versions, Harbor 0.23.0, Terminus-2 JSON, high agent reasoning, 40 turns, 16,384 output tokens per request and a `gemini-3.1-pro-preview` judge with low reasoning and one vote. Historical pins are provenance, not executable dependencies of this new release. The setup command above does not configure every historical provider/token setting; no exact replication claim is made.

Gemini 3.8 Flash is protocol-limited: one submission, six turn-limit outcomes and 50 rejected JSON responses; five infrastructure-failed tasks were recovered without replacing the original valid outcomes. GLM-5.3's completed recovery is retained alongside its original timeout and interrupted recovery; six original successful outcomes were preserved. No successful trial was rerun to seek a higher score. This single-case pilot does not establish repeated-run variance or significance of small ranking differences.

## Included historical attachments

| File | Contents |
|---|---|
| `run-records.tar.gz` | Sanitized derivative of 16 jobs and 86 attempts, including submitted answers, trajectories, verifier outputs, failures/recoveries and separately labeled execution QA/no-op/stub runs. |
| `run-index.json` | Stable pseudonymous job/trial relationships, archive paths and selected outcomes. |
| `evaluation-protocol.json` | Historical task provenance, exact model identities, parameter values and selection rules; private endpoints are redacted. |
| `redaction-summary.json` | Declared identity, infrastructure and historical source-excerpt transformations and limitations. |
| `image-inventory.json` | Measured archive checksums and clean image index/platform descriptors for the three supplied images; the minimal-task layout reuses the archives unchanged. |

The current comparison is **42 selected outcomes**, not 86 benchmark scores. Seven additional selected outcomes belong to a separately labeled historical Gemini 3.1 Pro baseline (seven submissions, mean reward 0.3124). All numerical outcomes remain preserved. Sanitized logs are not byte-identical originals; duplicated trajectory and terminal representations carry declared redactions. Native Harbor jobs and interactive trajectories are separate private resources, not made public by the archive.

No new model benchmark results are produced by release preparation. Deterministic local judge smoke checks test dataroom/verifier mechanics only, not financial grading accuracy or model quality.

## Rights and pending publication

License category: **Other / restricted**. The owner confirmed source redistribution rights, but this is not a blanket permissive downstream training, adaptation or redistribution grant. Preserve copyright and source notices; read `LICENSE.md` for the rights boundary. The proposal distributes the full local evaluation rather than requiring hosted-only access or withholding grading assets.

New Harbor identities prevent this release from inheriting old private package history. Original histories, images, source records and native job pages remain private. No global deletion, recall of downloads or inference-proof protection is promised. Follow `publication-plan.md` before any upload or visibility change.

Contact [tech@dissei.credit](mailto:tech@dissei.credit) for licensing, questions and private security reports.
