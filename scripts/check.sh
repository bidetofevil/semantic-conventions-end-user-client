#!/usr/bin/env bash
# Validates the registry model, including resolution of upstream dependencies.
# Requires network access to fetch the dependency registries pinned in
# model/manifest.yaml.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

weaver registry check -r "${REPO_ROOT}/model"
