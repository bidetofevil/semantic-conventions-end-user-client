#!/usr/bin/env bash
# Shared preamble for registry scripts: locates the repo root, loads the shared
# version pins from versions.env, and verifies weaver.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=../versions.env
source "${REPO_ROOT}/versions.env"
PINNED_WEAVER_VERSION="${WEAVER_VERSION#v}"

if ! command -v weaver >/dev/null 2>&1; then
  echo "error: weaver not found on PATH." >&2
  echo "Run scripts/install-weaver.sh to install the pinned version, or download a" >&2
  echo "release binary from https://github.com/open-telemetry/weaver/releases and" >&2
  echo "make sure it is on PATH." >&2
  exit 1
fi

INSTALLED_WEAVER_VERSION="$(weaver --version | awk '{print $2}')"
if [[ "${INSTALLED_WEAVER_VERSION}" != "${PINNED_WEAVER_VERSION}" ]]; then
  echo "warning: weaver ${INSTALLED_WEAVER_VERSION} installed, but this repo pins ${PINNED_WEAVER_VERSION} (see versions.env)." >&2
fi
