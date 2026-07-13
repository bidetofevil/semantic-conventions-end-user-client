# Releasing

Releases are cut from `main` as GitHub prereleases with the OTEP 4815 publication
artifacts attached: the publication manifest (`manifest.yaml`, `file_format:
manifest/2.0`) and the resolved registry (`resolved.yaml`, `file_format:
resolved/2.0`), both produced by `scripts/package.sh`.

The **single source of truth for the release version** is the version segment of
the `schema_url` in [`model/manifest.yaml`](model/manifest.yaml) — e.g.
`…/end-user-client-dev/0.2.0-dev` releases as tag `v0.2.0-dev`. Everything else
(the workflow, `scripts/package.sh`, the resolved-schema URI baked into the
artifacts) derives from it by parsing.

## When to release

Cut a release only when `model/` has changed since the last tag — the model is
the entire surface consumers see through `…@<tag>[model]`. Changes to scripts,
templates, generated docs, or CI are invisible to consumers and just ride along
in the next model-driven release.

## How to release

1. Land the model changes on `main` (regenerate docs; CI must be green).
2. In the same or a follow-up PR, bump the version segment of `schema_url` in
   `model/manifest.yaml` (e.g. `0.2.0-dev` → `0.3.0-dev`).
3. Run the **Release (dev)** workflow from the Actions tab
   (`workflow_dispatch`). It will:
   - derive the tag from the manifest and **refuse** if the tag already exists
     or the version lacks the `-dev` suffix;
   - validate the registry (`scripts/check.sh`), including the shared policy
     pack;
   - package the publication artifacts (`scripts/package.sh`);
   - create the `v<version>` tag at the workflow's commit and publish it as a
     GitHub **prerelease** with `manifest.yaml` and `resolved.yaml` attached
     and auto-generated notes.

## Rules

- **Tags are immutable.** Never move or delete a pushed tag; consumers pin
  exact tags. A bad release is fixed by a new version, not a re-tag.
- Dev-channel versions (`X.Y.Z-dev`) are cheap — burn version numbers freely.
- Consumers pin
  `registry_path: https://github.com/bidetofevil/semantic-conventions-end-user-client@v<version>[model]`.

## History

- `v0.1.0-dev`, `v0.2.0-dev` — tagged manually before this workflow existed;
  they have no release artifacts, which is fine for git-ref consumers.
