#!/usr/bin/env bash
# Produces the resolved registry (local definitions plus everything referenced from
# dependencies) at build/resolved-registry.yaml. Requires network access.
#
# Note: weaver 0.24.x deprecates `registry resolve` in favor of `registry package`,
# which also emits the OTEP 4815 publication manifest. Switch to `package` when the
# publishing pipeline (roadmap phase 3) lands.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

mkdir -p "${REPO_ROOT}/build"
weaver registry resolve -r "${REPO_ROOT}/model" -o "${REPO_ROOT}/build/resolved-registry.yaml"
echo "wrote ${REPO_ROOT}/build/resolved-registry.yaml"
