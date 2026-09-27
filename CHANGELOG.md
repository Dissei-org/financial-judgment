# Changelog

## 2.0.0 — 2026-09-27 — local release candidate

Public distribution is proposed, not executed. New Harbor task and dataset identities avoid inheriting prior private package history. Existing GitHub and Hugging Face mirror targets remain private pending separate approval.

### Preserved

- All seven complete tasks, original instructions, supporting evidence and financial facts.
- All 79 rubric criteria, task YAML, judge prompt content, scoring math and reference answers.
- Runnable dataroom and separate verifier, including the evaluated CLI behavior and submission/retrieval integrity contract.
- Historical numerical rewards, score breakdowns, model identities and outcome-selection relationships. The six-model comparison remains 42 selected outcomes; the broader record remains 16 jobs and 86 attempts, including the separately labeled historical baseline, recovery/failure attempts and execution QA.
- Source copyright and third-party notices.

### Changed for distribution

- Minimal execution runtime excludes task-authoring machinery and unrelated production orchestration.
- Release-facing names and version labels use neutral Financial Judgment identities.
- Three clean dual-architecture image archives use new tags and measured digests; prior private image layers are not reused as release bases. The minimal-task layout reuses these clean archives byte-for-byte without rebuilding them.
- Each of the seven task packages now has eight files: instructions, task configuration, a one-line `environment/Dockerfile` referencing the supplied image, four `tests/` files and `solution/solve.sh`. Harbor 0.23.0 requires the environment directory; it contains no duplicated runtime, evidence, wrappers or requirements. Runtime/evidence remain inside the images, and private environment rebuild contexts stay outside the public payload.
- Delivery requires both minimal task packages and image archives. Task-package hashes are refreshed from the changed bytes; unchanged image archives retain their hashes. Image-only downloads are not standalone Harbor datasets.
- Historical records use stable pseudonymous identifiers and declared redactions for credentials, private infrastructure, local identities and revealing source excerpts across duplicated log formats.
- Local usage, full-package scope, evaluator inspectability, restricted rights and re-identification limits are documented consistently across proposed platform cards.
- Judge-failure documentation distinguishes top-level graded/contradiction unavailability from per-row critical/pitfall failures and malformed graded diagnostics. The inherited critical gate default of 1.0 when no verdicts are available, skipped unavailable pitfall penalties and partial-vote aggregation remain unchanged; this clarification is not an evaluator hardening fix.
- Clean package manifests separate new executable dependencies from historical task-version provenance.

### Interpretation

This is a distribution and disclosure-boundary revision, not a new model benchmark. Historical results remain attributed to the versions originally evaluated. Deterministic local judge smoke checks address execution mechanics only, not financial grading accuracy or model quality. A separate verifier protects normal task-agent inputs; it does not hide the included evaluator, rubrics, judge prompts or reference answers from package recipients. Runtime source and evidence can be extracted from the Docker images; the reduced host-side file layout is not source secrecy. No inference-proof guarantee is made.

No upload, public visibility change, deletion of historical content, website change or paid inference is part of preparing this candidate. Release status must be updated only from an approved publication receipt, not from this changelog's date or version number.
