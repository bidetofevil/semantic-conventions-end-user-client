# End User Client Semantic Conventions

A federated OpenTelemetry semantic convention registry for instrumentation that target 
end-user client applications running on mobile phones, browsers, desktop computers, or 
any other consumer device.

This registry follows the federated model established by [OTEP 4815](https://github.com/open-telemetry/opentelemetry-specification/blob/main/oteps/4815-semantic-conventions-schema-v2.md) and augments 
general OTel semantic conventions that are mostly defined with backend applications in 
mind with ones that unique to and common amongst end-user client application platforms.

It contains YAMLs that defines the semantic conventions, and scripts to generate associated
markdown files, but does not generate language-specific binaries that are directly
consumable in instrumentation projects.

## Relationship to other registries

- **Extends**: Base OTel semantic conventions ([`open-telemetry/semantic-conventions`](https://github.com/open-telemetry/semantic-conventions)).
  - The goal is not to redefine existing concepts and conventions, but add new ones that only apply in this specific scope.
- **Parents**: Registries for specific client platforms
  - It provides semantic conventions that are common to multiple end-user client platforms (e.g.  [`semconv` module in `opentelemetry-android`](https://github.com/open-telemetry/opentelemetry-android/tree/main/semconv))).
  - Semantic conventions that are specific to a platform can go here as a start, but they should eventually go into their own registries if possible.

## Repository layout

```
model/                    semantic convention definitions (the source of truth)
  manifest.yaml           registry name, schema_url, and pinned dependencies
  <domain>/registry.yaml  attribute definitions for one specific domain
  <domain>/events.yaml    event definitions for one specific domain
templates/                weaver Jinja2 templates for docs generation
docs/                     generated markdown
scripts/                  validation / resolution / docs generation
```

## Getting started

Install [weaver](https://github.com/open-telemetry/weaver) — download a release
binary matching [`.weaver-version`](.weaver-version) from the
[releases page](https://github.com/open-telemetry/weaver/releases), or
`cargo install weaver` and make sure it is on `PATH`. All scripts need network
access to fetch the pinned upstream registry.

```bash
scripts/check.sh          # validate the model (including dependency resolution)
scripts/resolve.sh        # produce build/resolved-registry.yaml
scripts/generate-docs.sh  # regenerate docs/ from the model
```

## Roadmap

This registry is *technically* consumable the moment it is pushed and tagged, but not
*usefully* consumable until real content migrates in. The sequencing:

1. Move registry into `open-telemetry` org. 
2. Create release workflows and release v1.
3. Validate correctness with consumers that build platform-specific artifacts for consumption and extends it further.
4. Migrate all appropriate semantic conventions from the core semantic conventions registry here.
