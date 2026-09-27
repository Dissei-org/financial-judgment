#!/bin/bash
# Harbor verifier entry point. Copied to /tests/test.sh and run after the agent
# phase, in a separate verifier container (task.toml: environment_mode = "separate").
#
# /tests/verify.py checks the episode record for integrity (the answer was
# submitted through `dataroom`, every credited retrieval replays byte-for-byte
# against the corpus, the tool budget was respected), then runs the unchanged
# dissei_harbor.score grader, which writes /logs/verifier/reward.json (flat
# numeric metrics, `reward` first among them) and score_breakdown.json.
#
# The judge endpoint comes from the verifier environment:
#   --ve DISSEI_JUDGE_BASE_URL=...  --ve DISSEI_JUDGE_MODEL=...  --ve DISSEI_JUDGE_API_KEY=...
#
# Exit codes:
#   0  graded (including a recorded zero for an answer that was never submitted)
#   2  the rubric would not compile          - a corrupt package
#   3  no judge endpoint configured          - a missing --ve
#   4  the judges could not be reached       - infrastructure; retry the trial
# Only exit 0 leaves a reward file behind.
set -uo pipefail

VERIFIER_DIR="${DISSEI_VERIFIER_DIR:-/logs/verifier}"
mkdir -p "$VERIFIER_DIR"

# Harbor reads whichever reward file exists after this script returns, whether or
# not the script succeeded. A file left by an earlier attempt, or planted during the
# agent phase (Harbor makes /logs/verifier world-writable), must not survive into
# a failed grading run.
rm -f "$VERIFIER_DIR/reward.json" "$VERIFIER_DIR/reward.txt" "$VERIFIER_DIR/score_breakdown.json"

cd /
/usr/local/bin/python -I -B /tests/verify.py
status=$?

if [ "$status" -ne 0 ]; then
  echo "dissei-harbor: verification did not complete (exit ${status})" >&2
  rm -f "$VERIFIER_DIR/reward.json" "$VERIFIER_DIR/reward.txt"
fi

exit "$status"
