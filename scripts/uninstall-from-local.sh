#!/usr/bin/env bash
# Remove installed wrappers + local data tree.
set -euo pipefail

BIN="${HOME}/.local/bin"
DATA_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/pii-intake-scrubber"

rm -f "${BIN}/pii-intake-scrubber" "${BIN}/verify-pii-intake-scrubber"
rm -rf "${DATA_DIR}"

echo "Uninstalled pii-intake-scrubber wrappers."

