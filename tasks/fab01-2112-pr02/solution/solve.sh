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
dataroom get-exhibit 2 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
One possible response at this level would expect Company CI to be relatively resilient, but not immune, if demand weakened after the anchor. It would start from the visible segment evidence: Exhibit 1 labels Company CI as Company CI and shows substantial North American positions across residential HVAC, Product F, refrigeration, and transport. It would add that the ledger-supported case materials identify Company CI as a leader in scroll compressors and controls. Those points support a forecast that volumes and margins should hold up better than many more exposed industrial businesses because customers appear to face meaningful substitution limits in several product categories.

The same answer would not treat resilience as certainty. It would use the long historical table to show that Company CI had experienced revenue and EBITDA declines in downturn-like periods, so the right prediction is relative resilience rather than no contraction. It would also flag the cost side: the exhibit note attributes recent margin pressure to long-term OEM contracts with infrequent price adjustment terms, so weaker demand combined with cost pressure could squeeze margins before pricing catches up. The conclusion would be a balanced probabilistic call: Company CI should likely outperform a more exposed industrial peer set in a demand slowdown, but the company still has earnings sensitivity through volume, pricing lag, customer mix, and carve-out execution.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
