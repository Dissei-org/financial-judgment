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
dataroom get-exhibit 1 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
One possible excellent response would diagnose Company CI recent margin pressure primarily as a price-cost timing problem rather than a clear sign of structural deterioration. The historical financial exhibit shows margins compressing recently after a longer period in which the business had supported healthy profitability, so the first question is not whether the company suddenly lost its franchise, but why price realization lagged cost movement. The most persuasive case-specific explanation is the contract structure described in the materials: long-term OEM arrangements with infrequent price adjustment terms can cause costs to hit the income statement before price increases catch up. That fits a temporary margin squeeze better than a demand-collapse story.

The response would still be careful. It would not treat "temporary" as "immaterial" or "automatically reversible." A proper diagnosis would ask whether the lag is repeatable whenever input costs move quickly, whether customers accept catch-up pricing, and whether the historical margin profile is a reliable guide after the most recent disruption. It would also use the North American segment-share exhibit as a Person AU-check: Company CI identified share position, with the chart note that Company CI corresponds to Company CI, makes an immediate competitive-displacement diagnosis less convincing, though share evidence alone does not prove pricing power. A strong answer would conclude that the anchor evidence supports a recoverable pass-through lag diagnosis, with residual risk around contract cadence, input-cost volatility, and the need to validate the mechanism through customer and procurement diligence.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
