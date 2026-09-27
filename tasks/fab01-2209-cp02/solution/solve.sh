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
dataroom get-exhibit 8 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
On the entry multiple, Company CI is being taken private at roughly 12.4x LTM / 13.4x NTM Adjusted EBITDA on a headline basis, or about 10.4x / 11.3x pro forma for identified synergies. That sits essentially in line with — and on a pro-forma basis modestly below — the ~12.9x LTM / ~13.2x NTM commanded by publicly traded HVAC OEM peers, and well below the ~19x LTM carried by higher-growth comparable margin industrials. On a pure multiple screen the price therefore looks unremarkable rather than rich. The growth differential reframes that read: Company CI two-year forward EBITDA growth of ~3.3% badly trails the ~7.2% peer average, and its five-year historical EBITDA growth of ~1.9% versus ~8.4% is worse still — even though Company CI revenue has grown faster than peers (~5.2% vs ~2.1%), margin compression from slow contractual price pass-through means that revenue lead has not reached the EBITDA line. A slower-compounding asset should trade at a discount, so the comparable-to-slightly-cheaper multiple is largely warranted compensation for weaker earnings growth, not a free bargain. My most-likely verdict: the entry price is fairly-to-fully priced given the growth profile — attractive only if Company ED can convert margin resilience, non-discretionary replacement demand, and identified cost savings into growth the public comps do not yet reflect. The HVAC OEM set, not the pricier industrials, is the right benchmark; anchoring to industrials would overstate the discount.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
