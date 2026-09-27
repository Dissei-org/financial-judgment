# Dissei Financial Judgment — Sample

[Website](https://dissei.ai) · [Harbor](https://hub.harborframework.com/datasets/dissei/financial-judgment) · [Hugging Face](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment) · [GitHub](https://github.com/Dissei-org/financial-judgment)

Dissei Financial Judgment examines how AI models turn financial evidence into well-supported conclusions.

**Can a model identify what matters in a financial situation, connect the evidence to a conclusion, and distinguish what is supported from what remains uncertain?**

This sample contains seven tasks drawn from a single real-world deal, **Rung 3 anonymized while preserving the core financial reasoning**. The full evaluated sample includes a carefully designed environment, supporting exhibits, task-specific rubrics and reference answers. Across three dated evidence snapshots, the tasks span diagnosis, prediction, explanation, quantitative interpretation, counterfactual reasoning, comparison and strategy. Read [Financial judgment for LLMs](https://dissei.ai/guides/financial-judgment-for-llms) for our broader research perspective.

This repository contains the research README, not the runnable evaluation environment. Public question previews, methodology and recorded results are available on [Harbor](https://hub.harborframework.com/datasets/dissei/financial-judgment) and [Hugging Face](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment). Complete evaluation packages, including task-specific rubrics, a runner and supporting exhibits, are supplied separately under agreed terms.

## Explore the sample

| Family | Decision date | Question preview |
|---|---|---|
| Diagnostic | December 2021 | [Diagnose margin pressure](https://hub.harborframework.com/tasks/dissei/finance-preview-dg04) |
| Predictive | December 2021 | [Assess demand resilience](https://hub.harborframework.com/tasks/dissei/finance-preview-pr02) |
| Explanatory | June 2022 | [Explain investment significance](https://hub.harborframework.com/tasks/dissei/finance-preview-ex01) |
| Quantitative | June 2022 | [Read relative market position](https://hub.harborframework.com/tasks/dissei/finance-preview-qn02) |
| Counterfactual | September 2022 | [Reshape the financing structure](https://hub.harborframework.com/tasks/dissei/finance-preview-cf01) |
| Comparative | September 2022 | [Assess the entry valuation](https://hub.harborframework.com/tasks/dissei/finance-preview-cp02) |
| Strategic | September 2022 | [Choose the gating diligence workstream](https://hub.harborframework.com/tasks/dissei/finance-preview-st06) |

The [dataset viewer](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment/viewer/previews/test) keeps each question separate from its supporting brief. Linked Harbor instructions preserve the complete wording.

## Recorded results

| Model | Reward / 100 | Submitted |
|---|---|---|
| Claude Fable 5.1 | 60.73 | 7/7 |
| GPT-6 Astra | 52.45 | 7/7 |
| Claude Opus 5.5 | 52.17 | 7/7 |
| GLM-5.3 | 44.91 | 7/7 |
| Kimi K3 | 35.79 | 7/7 |
| Gemini 3.8 Flash | 9.01 | 1/7 |

Reward is the equal-weight mean of seven continuous task rewards, scaled to 0–100—not accuracy. A response can be partly sound while missing a material qualification or supporting evidence. Submission, required-check pass and answer quality are distinct; passing required checks does not earn full credit.

These are the existing six-model, seven-task results, not a new evaluation. Runs used Harbor 0.23.0, Terminus-2 JSON, 20 dataroom calls, 40 agent turns, a 30-minute task limit and a separate `gemini-3.1-pro-preview` judge. One outcome was selected per model and task; infrastructure recoveries were retained separately.

Gemini 3.8 Flash's result is protocol-limited: six attempts reached the turn limit without submission and received zero. GLM-5.3 includes one recovered task; successful original tasks were not rerun to improve scores. See the [full method and run notes](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment#evaluation-method) and [`results.json`](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment/blob/main/results.json).

This is a single-case pilot without repeated-run variance or judge-agreement estimates. Small score differences do not establish general model superiority. The broader [Dissei evaluation record](https://dissei.ai/bench) pools unequal case coverage and should be read separately from this matched seven-task sample.

An [inspectable historical assessment](https://dissei.ai/bench#assessment-first-lien-dispersion) illustrates the distinction between passing required checks and earning full credit: gate Passed, score 46.4/100. It is a separate case, not validation of this pilot's scores.

## Temporal judgment

Some context deliberately includes information outside a task's decision date. Models must distinguish relevant, contemporaneous evidence from distractors rather than treating every visible date as usable. The tasks are designed to permit full credit without relying on those distractors.

Dissei maintains separate holdout material. Rung 3 replaces names while retaining dates and financial figures, which can permit re-identification; neither this treatment nor separate holdouts establishes absence of prior model exposure to underlying sources.

## Contribute and discuss

Maintainers, researchers and practitioners are welcome to inspect the sample, challenge the methodology and propose evaluation runs under agreed terms.

Research directions we welcome:

- **Temporal relevance:** evidence selection at the decision date and controlled distractor ablations.
- **Failure analysis:** distinguishing evidence-selection errors, financial-judgment errors and harness failures.
- **Grading reliability:** judge agreement and how reward changes with answer quality.
- **Repeatability and efficiency:** variation across attempts and quality versus token, tool and inference cost.

These are proposed analyses, not additional results from this pilot.

Use [GitHub Issues](https://github.com/Dissei-org/financial-judgment/issues) for corrections and proposals, or the [Hugging Face Community tab](https://huggingface.co/datasets/Dissei-Data/Dissei-Financial-Judgment/discussions) for research discussion. Focused documentation pull requests are welcome. Run reports should identify task and model versions, harness and judge settings, who operated the run, and failures or recovery attempts. Discuss task or scoring changes before proposing them; results must remain tied to their evaluated versions.

Do not post credentials, protected case material, raw private run records or exploit details. Send access requests and private reports to [tech@dissei.credit](mailto:tech@dissei.credit).

## Access and licensing

This is a public research overview. The underlying evaluation environment and its evidence, rubrics, reference answers and runner are not distributed in this repository. Evaluation, retention, redistribution and training rights require agreement. Complete packages can be tailored to an agreed scope; task-authoring machinery and private production workflows are not part of the standard package.

Public availability and contribution do not expand those rights. An inquiry does not grant package access or subscribe anyone to a mailing list.

**Research proposals and evaluation inquiries:** [tech@dissei.credit](mailto:tech@dissei.credit) · [dissei.ai/contact](https://dissei.ai/contact).
