# Verifier image for one task: the anchor image plus this task's answer key at /tests.
#
# Harbor 0.23 does not upload tests/ into a separate verifier container; it builds
# this file from tests/ instead (a "dedicated verifier image"). The image is used
# only for the verifier phase, so the rubric, reference answer and level exemplars
# never exist in the container the agent works in.
FROM dissei/financial-judgment-2022-06:20260927-clean
COPY . /tests/
