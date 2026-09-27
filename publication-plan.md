# Financial Judgment 2.0.0 publication plan

**Status: local candidate only. No publication authorized by this plan.** Do not upload, push, change visibility, delete, rewrite remote history or launch paid inference without fresh approval identifying the exact target, scope and values. Website, CMS, marketing and unrelated repository settings are outside this release.

The proposed public product is the complete seven-task evaluation in two required parts: minimal Harbor task packages and three Docker image archives. Together they include original instructions and evidence, all 79 criteria, task YAML, rubrics, judge prompts, reference answers, dataroom runtime and separate verifier; sanitized historical records accompany the release. Runtime source and evidence are supplied inside the images, not duplicated in public task directories. Task-authoring machinery remains excluded. Recipients can extract code and evidence from the images; Docker is not source secrecy, and evaluator methods remain intentionally inspectable. No inference-proof protection is promised.

## Exact destination and identity contract

| Asset | Proposed destination or identity | Current status / constraint |
|---|---|---|
| Harbor dataset | `dissei/financial-judgment-full@2.0.0` | New identity; do not reuse an old dataset's package history. |
| Diagnostic task | `dissei/financial-judgment-dg04@2.0.0` | New package; local directory `tasks/fab01-2112-dg04`. |
| Predictive task | `dissei/financial-judgment-pr02@2.0.0` | New package; local directory `tasks/fab01-2112-pr02`. |
| Explanatory task | `dissei/financial-judgment-ex01@2.0.0` | New package; local directory `tasks/fab01-2206-ex01`. |
| Quantitative task | `dissei/financial-judgment-qn02@2.0.0` | New package; local directory `tasks/fab01-2206-qn02`. |
| Counterfactual task | `dissei/financial-judgment-cf01@2.0.0` | New package; local directory `tasks/fab01-2209-cf01`. |
| Comparative task | `dissei/financial-judgment-cp02@2.0.0` | New package; local directory `tasks/fab01-2209-cp02`. |
| Strategic task | `dissei/financial-judgment-st06@2.0.0` | New package; local directory `tasks/fab01-2209-st06`. |
| December image | `dissei/financial-judgment-2021-12:20260927-clean` | Local archive `images/financial-judgment-2021-12.tar.gz`; not a promise of a registry upload. |
| June image | `dissei/financial-judgment-2022-06:20260927-clean` | Local archive `images/financial-judgment-2022-06.tar.gz`; same constraint. |
| September image | `dissei/financial-judgment-2022-09:20260927-clean` | Local archive `images/financial-judgment-2022-09.tar.gz`; same constraint. |
| GitHub mirror | `Dissei-org/financial-judgment` | Existing destination is private; proposed release tag `v2.0.0`. |
| Hugging Face mirror | `Dissei-Data/Dissei-Financial-Judgment` | Existing destination is private; proposed full-package mirror. |

Expected dataset page after an approved publication: `https://hub.harborframework.com/datasets/dissei/financial-judgment-full`. This URL is a proposal, not evidence of a live page. Proposed task pages use the corresponding new package names under `https://hub.harborframework.com/tasks/`.

No original private task digest may serve as a new executable dependency. `dataset.toml` must pin hashes measured from the newly packaged minimal task bytes; replacing the duplicated environment tree with a one-line image-reference Dockerfile changes task-package digests even though the supplied clean image archives remain byte-for-byte unchanged. Refresh `local-task-index.json` and the owned-file inventory from the actual payload. Do not reuse superseded full-context task hashes, invent digest values or rebuild unchanged images merely to change the layout. Historical pins may remain clearly labeled in `evaluation-protocol.json` solely to explain the preserved results.

## Ordered release sequence

### 1. Freeze and review the exact local payload

Identify a single completed candidate and its checksums. Review both delivery parts: seven minimal task packages with instructions, task configuration, host-side rubric source, separate-verifier assets and solutions; and the three unchanged clean image archives containing runtime, evidence and notices. Review all documentation and attachments. Confirm each `environment/` contains only its one-line image-reference `Dockerfile`, with no duplicated runtime, evidence, wrappers, requirements or public environment rebuild inputs. Confirm the original private sources were not changed. Retain `tests/Dockerfile`, which builds only the separate verifier on top of a supplied image.

Confirm both architectures are present and that the supplied archives match the previously reviewed clean archive hashes. Reuse those archives unchanged rather than rebuilding for the minimal-task layout. The clean images must originate from clean inputs, not old private image layers with files deleted later. Review raw layers, configuration/history metadata and nested archives as well as the merged filesystem. Preserve unrelated upstream bytes and software notices; a literal scan hit in a checksum, certificate or dependency is not permission to corrupt it.

Require successful local execution evidence for the minimal task layout with the delivered images, including the dataroom and separate verifier, and comparison with the evaluated baseline on all seven tasks and both architectures. Use a deterministic local judge for mechanics; do not describe those checks as a new financial-quality benchmark. Retain detailed private validation evidence and environment build contexts outside the public payload. Do not publish private sanitizer/build scripts, source mappings, raw audit inventories or operator paths.

Reconcile the 16 jobs and 86 attempts, the 42 current selected numerical outcomes and the seven separately labeled historical-baseline selections. Verify rewards and score breakdowns survived redaction; check every duplicated trajectory/recording representation. Review `redaction-summary.json` and the distinction between historical provenance and clean executable digests.

Owner-confirmed source redistribution rights and preserved notices must remain accurately described. Keep the license category `other` / restricted; do not add permissive training or downstream redistribution terms that the owner has not actually granted. Keep name suppression and the re-identification caveat visible.

### 2. Obtain approval for private staging and intended public scope

Present the exact identities above, artifact hashes, three image archive hashes, source-rights notice, full evaluator inclusion and proposed public visibility scope. Request approval for the specific staging uploads and later visibility actions; an earlier request to prepare files is not upload approval.

Before any upload, verify each proposed new Harbor identity is genuinely unused or contains only this approved clean candidate. If one already has unrelated or unreviewed versions, stop and obtain approval for another clean identity; do not overwrite or toggle it.

Review reachable GitHub and Hugging Face history, branches, tags, releases and generated file references before proposing a visibility change to those existing mirrors. If any reachable bytes are outside the approved release boundary, keep the destination private. Resolve that conflict with fresh approval rather than assuming a clean latest commit hides history. Do not force-push, squash, delete or replace history as an automatic step.

### 3. Stage clean images and mirror payloads privately

After exact upload approval, stage the three archives as GitHub `v2.0.0` draft-release assets in the still-private repository, retaining these archive basenames:

- `financial-judgment-2021-12.tar.gz`
- `financial-judgment-2022-06.tar.gz`
- `financial-judgment-2022-09.tar.gz`

Stage the corresponding inventory and checksums with the release. Stage the minimal task files and root documentation/attachments in the same private GitHub mirror, and the complete candidate, including `images/`, in the still-private Hugging Face mirror. Do not upload the private source workspace or environment build contexts. Use the platform's supported large-file delivery rather than copying only the README or preview rows. Proposed platform cards are in `cards/`.

The GitHub release assets supply the image half of the delivery, not a standalone Harbor dataset or a container-registry push. Recipients also need the seven task packages and root files from the same approved revision. Users put each archive under the documented `images/` path; a complete downloaded mirror already has that layout. A registry distribution is optional and requires a separately approved exact registry target, not an implicit push caused by the local tag.

Do not publish stale preview viewer files as though they are the runnable dataset. If the existing Hugging Face mirror has preview-only data/configuration, migrate that selected mirror content to the reviewed full-package layout under the approved change, without claiming generated Parquet is the execution format. Review generated refs and any retained old blobs before public visibility.

### 4. Upload the seven new Harbor task packages privately

After exact upload approval, upload only the seven new task packages named above at `2.0.0`. Each must contain exactly eight files: `instruction.md`, `task.toml`, `environment/Dockerfile`, `tests/Dockerfile`, `tests/verify.py`, `tests/test.sh`, `tests/task.yaml` and `solution/solve.sh`. The task config selects the corresponding prebuilt image. Harbor 0.23.0 requires `environment/`; its Dockerfile must contain only `FROM` followed by that same supplied image tag. The test Dockerfile bases the separate verifier on the same image. No runtime copy, evidence copy, wrappers, requirements or environment rebuild inputs belong in these packages. Resolve each uploaded package while authenticated and compare the served archive's digest with the newly measured local minimal-package digest.

If any server-side transformation changes executable bytes or a digest does not match, stop before dataset creation or visibility changes. Investigate the difference; never fill the manifest with an old private digest merely to make resolution succeed.

### 5. Create the new Harbor dataset privately

Create `dissei/financial-judgment-full@2.0.0` from those seven exact clean package digests. Attach the root documentation and machine-readable review files, including `run-records.tar.gz`, `run-index.json`, `evaluation-protocol.json`, `redaction-summary.json` and `image-inventory.json`. Supply the proposed Harbor card.

The candidate-only `local-task-index.json` ships with the complete GitHub/Hugging Face mirrors, not as a Harbor dataset attachment. Its `tasks/` paths describe the mirror layout, not Harbor download paths; its dataset content digest identifies the manifest without creating a circular attachment digest. Run the complete mirror with `harbor run --path ./tasks` as documented in `USAGE.md`.

Make both delivery parts unambiguous: the complete mirror layout combines seven minimal task packages with the three image archives and measured checksums. The Harbor card must link the exact approved release/revision carrying those images and explain that recipients must load them before running the task packages. Image archives alone are not a Harbor dataset. Do not rely on private registry credentials, old image inventory references or an inaccessible attachment. If signed URLs or attachment sizes prevent complete delivery, keep the dataset private until an approved durable delivery route works.

Download the staged dataset and mirrors as an authorized recipient. Harbor's download layout may differ from the mirror's `tasks/` layout; ensure platform copy gives the actual downloaded paths, or direct users to the complete mirror for the documented `--path ./tasks` commands. Load the delivered images and exercise the real downloaded task/verifier path with deterministic local transport. Compare all served bytes and digests to the frozen candidate.

### 6. Approve and expose only the clean release

Immediately before public changes, confirm the exact package list, mirror destinations, release/revision identifiers, image hashes and intended public visibility. The approval must explicitly include all seven new task packages as well as the new dataset; Harbor can apply visibility at package level and may cascade to linked tasks.

After that approval, make the clean GitHub/Hugging Face mirror delivery accessible, publish the approved GitHub `v2.0.0` release, then make the seven clean Harbor task packages and the new dataset public. Inspect any provider cascade prompt; abort if its target list differs from the seven approved new packages. Do not accidentally expose old task histories through a broad organization or package-level action.

Only after actual publication should status text and image links be changed from proposed/local to published. Record the resulting revisions, archive hashes, task digests, index/platform digests and URLs in a release receipt. Do not assert the hosted New Job service is configured or tested unless that distinct deployment path was explicitly approved and exercised. No paid benchmark run is needed to publish verified local mechanics.

### 7. Verify anonymously, including negative historical controls

From an unauthenticated context, verify every new dataset/task page and direct download, all three image archives, GitHub release assets, Hugging Face files and any viewer/generated references. Exercise the delivered local path rather than treating a page's Run button as proof of executability. Check that every numerical historical outcome still matches the approved derivative and that restrictions and caveats render correctly.

Also recheck the previously inventoried old dataset revisions, old task archive digests, historical attachments, original image digests, exact-SHA mirror URLs and native job pages. Original private content must remain denied anonymously after the new publication. Use a new clean-public resource as a positive control so network failure is not mistaken for access denial. Record status codes and exact targets in the private receipt.

An anonymous denial check is evidence about those targets at that time. It is **not** a guarantee that caches, old signed URLs, prior downloads or other copies have been erased. Tags, yanking, a new latest version and history squashing must not be described as global byte deletion. Do not promise recall of copies already downloaded.

If a required positive or negative control fails, report the exact failure and stop claiming successful publication. Any corrective visibility or deletion action needs authorization for the exact affected target unless it was explicitly included in the approved incident response. Preserve evidence; do not silently change historical benchmark numbers or remove required evaluator assets to obtain a passing check.

## Histories and resources that stay private

Original Harbor dataset/task versions, old image histories, original logs, identity mappings, private environment build contexts and native job resources remain private. Do not grant job visibility merely because a sanitized archive is distributed. Do not overwrite or delete the originals. The clean release does not inherit a promise that previously published or downloaded bytes can be removed everywhere.

The existing GitHub/Hugging Face mirrors may become public only through the reviewed, approved sequence above. Old private Harbor histories must not be made public by changing their latest version's card or adding a clean revision to their package. This plan contains no website change, CMS change, credential provisioning, automatic upload or paid inference step.
