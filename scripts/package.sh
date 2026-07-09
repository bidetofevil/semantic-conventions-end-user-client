#!/usr/bin/env bash
# Packages the publication manifest and resolved registry in build/package/
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

VERSION="$(awk '/^schema_url:/ { n = split($2, parts, "/"); print parts[n]; exit }' "${REPO_ROOT}/model/manifest.yaml")"
RESOLVED_SCHEMA_URI="https://github.com/bidetofevil/semantic-conventions-end-user-client/releases/download/v${VERSION}/resolved.yaml"

rm -rf "${REPO_ROOT}/build/package"
weaver registry package \
  -r "${REPO_ROOT}/model" \
  --v2 \
  --resolved-schema-uri "${RESOLVED_SCHEMA_URI}" \
  -o "${REPO_ROOT}/build/package"
echo "packaged version ${VERSION} -> ${REPO_ROOT}/build/package"
