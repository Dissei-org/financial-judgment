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
dataroom get-exhibit 2 >/dev/null 2>&1 || true
dataroom get-exhibit 3 >/dev/null 2>&1 || true
dataroom get-exhibit 4 >/dev/null 2>&1 || true
dataroom get-exhibit 5 >/dev/null 2>&1 || true
dataroom get-exhibit 1 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
One possible excellent response would say that the margin pressure mattered because it was the central test of whether Company CI depressed earnings were a temporary price-cost mismatch or evidence that the business had lost structural quality. The historical exhibit showed recent gross and EBITDA margin compression, so Company ED could not simply capitalize peak earnings. But the case materials also pointed to a specific mechanism: raw materials were a large part of cost of goods sold and many customer contracts reset prices only infrequently, creating a lag before inflation could be recovered. That made the pressure important because it created both risk and potential upside. If the lag proved temporary, normalized margins could support the base-case projection; if not, the deal price would overstate sustainable cash flow.

The response would also connect this to the broader investment case. Company CI position in compressors and the domestic supply position made the pressure less likely to be purely competitive erosion, while the operational diligence and identified plant-efficiency savings gave Company ED a concrete path to improve margins rather than relying only on market recovery. At the same time, the carve-out introduced execution risk because the company had to become standalone while depending on transition support from Company BR. The margin issue therefore mattered because it concentrated the deal debate: earnings quality, pricing power, operational self-help, and standalone execution all had to be credible for the investment to work.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
