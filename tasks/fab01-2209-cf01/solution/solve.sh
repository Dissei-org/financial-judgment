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
dataroom get-exhibit 10 >/dev/null 2>&1 || true
dataroom get-exhibit 9 >/dev/null 2>&1 || true
dataroom get-exhibit 4 >/dev/null 2>&1 || true

cat > /tmp/reference_answer.md <<'DISSEI_REFERENCE_ANSWER_EOF'
If Company BR declines both to roll equity and to provide the seller note, the
transaction does not become cheaper — it becomes a replacement-capital problem.
The price is unchanged at $14.0 billion, total uses stay at $14,052 million, and
the question is only who funds the hole and on what terms. Framing it as a
reason to pay less, or as a reason the deal simply dies, misses what actually
changes: the sources table has to be rebuilt around the same number, and the
economics of who bears loss move with it.

The hole is the sum of the two seller-funded lines. The seller note is $2,250
million and Company BR's 40% common equity is $1,721 million, so $3,971 million
of the $14,052 million of sources disappears — a little over 28% of the funding
— together with the $50 million of balance-sheet cash Company BR was to provide.
Everything below follows from having to replace roughly $4.0 billion.

Incremental third-party debt cannot carry that on its own. The proposed package
is $5.5 billion of senior debt at about 4.0x leverage, which implies an earnings
base near $1.4 billion; adding $4.0 billion of debt would take total borrowings
to roughly $9.5 billion, or about 6.9x the same earnings. That is far beyond the
leverage the package was sized around and sits against a first-lien net leverage
covenant set at 6.5x EBITDA. The structure is also already reaching: alongside a
$2.9 billion Term Loan A at SOFR+4.50% with 97.5 OID, it carries a $2.6 billion
direct loan at SOFR+6.75% with 96.6 OID — pricing and original issue discount
that show the arrangers were already paying up for the last turns of leverage.

The pre-anchor credit backdrop limits the all-debt answer further. At the anchor
the leveraged finance market is constrained rather than accommodating, which is
why so much of the package sits with a direct lender at private-credit pricing
in the first place. Assuming another $4 billion of senior capacity would be
assuming exactly the market condition the record says was absent, and the
sponsor's size does not change that: capacity is priced by lenders against the
credit and the market, not granted on the strength of the buyer's brand. An
undrawn revolver does not help either — a revolver is working-capital liquidity,
not permanent acquisition financing, and treating it as a funding source
confuses a committed facility for a use of proceeds.

The credible replacement is junior capital, not more leverage. The natural move
is to expand the layer that already exists: the $2.0 billion of convertible
preferred at a 7% PIK rate converting at a 10% premium, deepened with additional
co-invest and third-party structured equity, plus a larger sponsor common
cheque. That preserves debt service against an earnings base that has not grown,
at the cost of a heavier PIK burden accreting ahead of common and a larger
preference stack sitting in front of the sponsor's own return.

The risk-sharing shift is the substantive answer. Today Company BR sits in two
places: $1,721 million of common equity taking first loss alongside the sponsor,
and a $2,250 million seller note that is 5% PIK and ranks senior to the
preferred but behind the third-party debt. That note is emphatically not
third-party senior debt — it is deferred, non-cash, seller-provided paper whose
subordination is part of what makes the senior package work. Remove both and the
first-loss position concentrates on Company ED and whatever new junior investors
step in; the preference stack ahead of common grows, so sponsor returns are
diluted and more sensitive to exit timing; and the deal loses a provider who was
economically motivated to see the separation succeed.

That last point matters for execution, not just for funding. Company BR's
retained stake and its note aligned the seller with a carve-out that still has to
stand up functions the business consumed from its parent. A seller with no
continuing economic interest is a less committed counterparty through
transition, so new capital would price that execution risk on top of the
leverage question — which is part of why the replacement is unlikely to come at
the same cost as what it replaces.

Two factors temper the downside. Company CI's demand is substantially
replacement-driven rather than discretionary, which supports a steadier earnings
base than the leverage arithmetic alone suggests and is exactly what a private
credit provider underwrites. Against that, input-cost inflation and the lag
before pricing catches up remain a live residual risk for any new capital: the
margin path is timing-sensitive, and a junior provider sitting behind $5.5
billion of senior debt absorbs that volatility first.

All of this is bounded by what is visible at September 2022. The record supports
the sizing, the structure and the direction of the risk shift; it does not
support claims about how financing conditions subsequently moved, whether such
replacement capital was in fact available, or the terms it would have carried.
The defensible conclusion is that the deal could still be closed at $14.0
billion, but only by replacing roughly $4.0 billion with junior capital rather
than debt, and the result would be a more expensive, more preference-heavy
structure in which Company ED and new investors absorb the loss position Company
BR had been sharing.
DISSEI_REFERENCE_ANSWER_EOF

dataroom submit /tmp/reference_answer.md
