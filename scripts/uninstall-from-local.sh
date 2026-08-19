#!/usr/bin/env bash
# Remove installed wrappers + local data tree.
set -euo pipefail

BIN="${HOME}/.local/bin"
DATA_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/pii-intake-pseudonymizer"

rm -f "${BIN}/pii-intake-pseudonymizer" "${BIN}/verify-pii-intake-pseudonymizer"
rm -rf "${DATA_DIR}"

echo "Uninstalled pii-intake-pseudonymizer wrappers."
