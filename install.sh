#!/data/data/com.termux/files/usr/bin/bash
#
# install.sh — entry point. Just delegates to scripts/setup.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/scripts/setup.sh"