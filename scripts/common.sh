#!/usr/bin/env bash
# Shared preamble for registry scripts: locates the repo root and verifies weaver.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v weaver >/dev/null 2>&1; then
  echo "error: weaver not found on PATH." >&2
  echo "Install a release binary from https://github.com/open-telemetry/weaver/releases" >&2
  echo "or run 'cargo install weaver', and make sure it is on PATH." >&2
  exit 1
fi

PINNED_WEAVER_VERSION="$(<"${REPO_ROOT}/.weaver-version")"
INSTALLED_WEAVER_VERSION="$(weaver --version | awk '{print $2}')"
if [[ "${INSTALLED_WEAVER_VERSION}" != "${PINNED_WEAVER_VERSION}" ]]; then
  echo "warning: weaver ${INSTALLED_WEAVER_VERSION} installed, but this repo pins ${PINNED_WEAVER_VERSION} (see .weaver-version)." >&2
fi
