# Contributing

## Proposing a new convention

To be determined once this registry is moved into the `open-telemetry` org.

## Public API: group IDs and event names

Consumers depend on two kinds of identifiers from this registry, which are consider
public API surfaces:

- **Attribute group IDs**
  - Uses the naming convention `registry.end_user_client.<top-level-namespace>` (e.g.
    `registry.end_user_client.app`), declared with `visibility: public`. The
    `end_user_client` qualifier prevents collisions with other attribute group IDs
    for the same top-level namespace.
- **Event names**
  - Globally unique (e.g. no other registry should declare an event named `app.nav_complete`).

Renaming these are considered a breaking change.

## Renames and removals

Semantic conventions are never removed in a new version. Instead, deprecate any
that are no longer maintained and provide documentation regarding what to use instead.

## Tooling

Scripts expect the [weaver](https://github.com/open-telemetry/weaver) binary on `PATH`, at the version pinned
in [`versions.env`](versions.env), with network access to fetch pinned dependency registries.
Run `scripts/install-weaver.sh` to install the pinned version.
