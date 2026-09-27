#!/bin/bash
# Oracle solution — submits the authored reference answer.
#
# Harbor's `oracle` agent is the only thing that copies solution/ into the container.
# It exists so the harness can be tested independently of any model: build a bundle,
# run `harbor run -p tasks/ -a oracle`, and the rewards should land near the top of
# the scale. A low oracle score means the pipeline is broken — a bad rubric, a judge
# misconfiguration, a lost answer file — not that the model was bad.
#
# It first retrieves exactly the evidence the rubric's scored criteria cite. Without
# that the oracle would submit a perfect answer having retrieved nothing, the retrieval
# modulator would floor at 0.7, and the harness check would report that floor as its
# ceiling — hiding whatever the real ceiling is.
set -uo pipefail

dataroom list-sources  >/dev/null 2>&1 || true
dataroom list-exhibits >/dev/null 2>&1 || true
dataroom view-timeline 2022-09 1 200 >/dev/null 2>&1 || true
dataroom get-exhibit 4 >/dev/null 2>&1 || true
dataroom get-exhibit 2 >/dev/null 2>&1 || true
dataroom get-exhibit 5 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
One possible excellent response would make carve-out stand-up and TSA separation validation the gating workstream. The reason is not that every other risk is minor, but that this is the workstream most likely to turn an attractive industrial asset into a failed signing if it is not executable on day one. Company CI was not a clean standalone company; it would rely on Company BR for 156 different services (F030), so the diligence threshold should be a bottoms-up service-by-service view of what must transfer, what must remain under TSA, who owns each function, what failure modes interrupt customers or plants, and what standalone costs are truly embedded in the model.

The response would then contrast this gate with other major workstreams. Pricing and inflation are serious because raw materials were about 60% of cost of goods sold (F020) and customer contracts delayed pass-through by 6-18 months (F021), but that argues for stress testing margins and liquidity, not necessarily for stopping signing if the pass-through mechanics are understood. Financing also matters in a rising-rate market: the deal contemplated $5.5BN of third-party senior debt at about 4.0x leverage (F043), a leverage covenant below 6.5x EBITDA (F045), 30-day SOFR of 2.42% at the anchor date (F052), and an undrawn $700 million ABL (F057, F058). Still, the sponsor had a structured capital plan and meaningful Company BR alignment through a 60/40 common equity split (F042) and Company BR's retained equity interest (F081). Operating cost savings are value-critical, including a $105 million plant efficiency opportunity (F026), but upside can be repriced or reserved for; operational separation failure can impair control, reporting, payroll, procurement, IT, and customer continuity immediately after closing.

The conclusion would say Company ED should sign only if the carve-out workstream has verified executable TSAs, named personnel, stand-up roadmap, costs, governance, and fallback plans, while using pricing, recession, and financing diligence to calibrate price, covenants, and downside protections.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
