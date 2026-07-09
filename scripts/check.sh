#!/usr/bin/env bash
# Validates the registry model: schema validation, resolution of upstream
# dependencies, and the shared OpenTelemetry policy pack (naming conventions,
# attribute type rules, stability requirements). Requires network access to
# fetch the dependency registries pinned in model/manifest.yaml and the policy
# pack pinned below.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Shared OTel policy pack. Materialized as a local checkout under build/.
POLICY_REPO_URL="https://github.com/open-telemetry/opentelemetry-weaver-packages.git"
POLICY_REPO_REF="d84341cf20a1fef1a833ef44d318c41a770e6e64"
POLICY_DIR="${REPO_ROOT}/build/weaver-policies"
POLICY_STAMP="${POLICY_DIR}/.${POLICY_REPO_REF}"

if [[ ! -f "${POLICY_STAMP}" ]]; then
  rm -rf "${POLICY_DIR}"
  git init -q "${POLICY_DIR}"
  git -C "${POLICY_DIR}" remote add origin "${POLICY_REPO_URL}"
  git -C "${POLICY_DIR}" fetch -q --depth 1 origin "${POLICY_REPO_REF}"
  git -C "${POLICY_DIR}" checkout -q --detach FETCH_HEAD
  touch "${POLICY_STAMP}"
fi

weaver registry check \
  -r "${REPO_ROOT}/model" \
  --v2 \
  --policy "${POLICY_DIR}/policies/check"
