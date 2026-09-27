You are answering a Dissei business-case question about **company-ci-carveout**, reasoning strictly as of **2022-09**.

Everything after that date is unknowable to you and is not in the dataroom. Do not reason from hindsight, and do not assert post-anchor events as fact.

## QUESTION

Which diligence workstream should Company ED treat as gating before signing the carve-out?

You are advising Company ED at the September 2022 signing decision for the Company CI. Use only the provided pre-anchor case materials to identify which diligence workstream should be treated as gating before signing, and explain why that workstream should control the go/no-go decision.

Timeline:

## AVAILABLE EVIDENCE — TIMELINE

You have read-tools for the case's pre-anchor narrative:

  - `dataroom list-timelines` -> the anchor stems visible at this task's anchor (2022-09), each with a line count
  - `dataroom view-timeline <stem> <start_line> <end_line> [--start-char N]` -> read a bounded window of that stem's narrative

Each content field is capped at 200 lines and 40,000 characters. If the response says `truncated`, continue from the exact `next_start_line` and `next_start_char` it returns. The tools enforce the anchor cutoff: narratives past 2022-09 are not retrievable.

Exhibits:

## AVAILABLE EVIDENCE — EXHIBITS

The case has 11 exhibits in total; the dataroom surfaces only those whose data is dated on or before 2022-09.

  - `dataroom list-exhibits` -> exhibit_id + title + kind (table | image) for the visible exhibits
  - `dataroom get-exhibit <exhibit_id>` -> the rendered table, or the image's quoted text

Sources:

## AVAILABLE EVIDENCE — PRIMARY SOURCES

The case has 7 primary sources; the dataroom surfaces only those dated on or before 2022-09 (sources with no date are timeless reference material and stay visible).

  - `dataroom list-sources` -> the catalogue: every visible source's id, title, date_published, preview and cited_as. Use this FIRST to triage.
  - `dataroom grep <pattern> [--scope sources|timelines|exhibits|all] [--case-sensitive] [--max-results N] [--context-lines N]` -> regex search across visible material
  - `dataroom view-source <citation_id> <start_line> <end_line> [--start-char N]` -> paginated read of one source body (same 200-line / 40,000-character cap)

The retrieval pattern is: list -> grep -> view.

## TOOL BUDGET

You may spend 20 `dataroom` calls on this task. `dataroom status` reports what is left and is free.
The evidence is also present as plain files under `/corpus`, and you may read it however you like — but only retrievals made through `dataroom` are recorded, and part of your score reflects whether you retrieved the evidence the rubric expects. Reading around the dataroom therefore costs you that credit without saving you anything.

## SUBMIT (REQUIRED)

You MUST finish by submitting your full final answer:

    dataroom submit /path/to/your/answer.md
    # or:  printf '%s' "$ANSWER" | dataroom submit -
    # or:  dataroom submit --text "your answer"

This is the ONLY action that is scored. Rules:

  - Do NOT stop with your answer sitting in a file, a comment, or your last message — an answer that
    is not submitted scores ZERO, no matter how good it is.
  - Don't over-investigate: budget your reads and submit BEFORE you run low. A complete
    answer submitted now beats more searching that never gets submitted.
  - `dataroom submit` is TERMINAL — later dataroom calls are refused.
