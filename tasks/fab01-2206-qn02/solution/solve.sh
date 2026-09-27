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
dataroom get-exhibit 1 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
One possible excellent response would say that the segment-share exhibit points to Company CI as a leading North American compressor franchise rather than a niche participant. It would first make clear that the exhibit's Company CI bars refer to Company CI, then read the bars against the other named suppliers in each displayed segment. The strongest implication is that Company CI had a particularly commanding position in residential HVAC and still appeared to be one of the leading suppliers across Product F, refrigeration, and transport. The response would avoid treating the chart as a single corporate market-share number; it would instead infer relative rank and breadth across the displayed segments. It would also calibrate why this matters for the investment case: North America represented 71% of Company CI trade sales, so the North American exhibit speaks to a core part of the business, while residential and Product F plus refrigeration represented 85% of revenue, so the shown end markets overlap heavily with Company CI economic base. A strong answer would add that the exhibit is consistent with the broader case description of Company CI as a market leader in scroll compressor technology and a global leader in scroll compressors and controls, while still noting that the chart is North America-specific and estimated from segment bars.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
