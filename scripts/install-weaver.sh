#!/usr/bin/env bash
# Installs the weaver release pinned in versions.env for the host platform.
#
# Downloads the official release binary from GitHub, verifies its sha256 checksum,
# and installs it to ~/.local/bin (or the directory given as the first argument).
# To update weaver, bump WEAVER_VERSION in versions.env and rerun this script.
#
# Usage: scripts/install-weaver.sh [install-dir]
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../versions.env
source "${REPO_ROOT}/versions.env"
VERSION="${WEAVER_VERSION#v}"
INSTALL_DIR="${1:-${HOME}/.local/bin}"

case "$(uname -s)" in
  Darwin) os="apple-darwin" ;;
  Linux) os="unknown-linux-gnu" ;;
  *)
    echo "error: unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac
case "$(uname -m)" in
  arm64 | aarch64) arch="aarch64" ;;
  x86_64 | amd64) arch="x86_64" ;;
  *)
    echo "error: unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

asset="weaver-${arch}-${os}.tar.xz"
url="https://github.com/open-telemetry/weaver/releases/download/v${VERSION}/${asset}"

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

echo "downloading ${url}"
curl -sSfL -o "${tmpdir}/${asset}" "${url}"
curl -sSfL -o "${tmpdir}/${asset}.sha256" "${url}.sha256"

expected="$(awk '{print $1}' "${tmpdir}/${asset}.sha256")"
if command -v sha256sum >/dev/null 2>&1; then
  (cd "${tmpdir}" && echo "${expected}  ${asset}" | sha256sum -c -)
else
  (cd "${tmpdir}" && echo "${expected}  ${asset}" | shasum -a 256 -c -)
fi

tar -xJf "${tmpdir}/${asset}" -C "${tmpdir}"

mkdir -p "${INSTALL_DIR}"
install -m 0755 "${tmpdir}/weaver-${arch}-${os}/weaver" "${INSTALL_DIR}/weaver"
echo "installed weaver ${VERSION} to ${INSTALL_DIR}/weaver"

case ":${PATH}:" in
  *":${INSTALL_DIR}:"*) ;;
  *) echo "warning: ${INSTALL_DIR} is not on PATH." >&2 ;;
esac

"${INSTALL_DIR}/weaver" --version
