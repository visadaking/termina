#!/usr/bin/env bash
set -euo pipefail

# termina bootstrap/install helper
# Safe by design: this script does NOT partition or format disks.
# Run from a NixOS live ISO (recommended) or any environment with nixos-install available.

usage() {
  cat <<'EOF'
Usage: ./install.sh [--flake PATH] [--host HOST] [--mount MOUNTPOINT] [--no-install]

Options:
  --flake PATH       Path to this flake/repo (default: directory containing this script)
  --host HOST        nixosConfiguration/host to install (default: termina)
  --mount MOUNTPOINT Target root mountpoint (default: /mnt)
  --no-install       Print checks/summary only; do not run nixos-install
  -h, --help         Show this help

Examples:
  sudo ./install.sh
  sudo ./install.sh --host termina --flake /mnt/home/visa/termina
  ./install.sh --no-install --host termina

Notes:
  - Partitioning/formatting is manual on purpose (hardware-specific and destructive).
  - Ensure the selected host's hardware config matches this machine before installing.
  - Future hosts (e.g. Intel/AMD laptop) can be added under hosts/<name>/ and installed with --host <name>.
EOF
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FLAKE="$SCRIPT_DIR"
HOST="termina"
MNT="/mnt"
DO_INSTALL=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --flake) FLAKE="$2"; shift 2 ;;
    --host) HOST="$2"; shift 2 ;;
    --mount) MNT="$2"; shift 2 ;;
    --no-install) DO_INSTALL=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

FLAKE="$(cd -- "$FLAKE" 2>/dev/null && pwd || echo "$FLAKE")"

echo "== termina install helper =="
echo "flake:      $FLAKE"
echo "host:       $HOST"
echo "mountpoint: $MNT"
echo

# Basic checks
if [[ ! -f "$FLAKE/flake.nix" ]]; then
  echo "ERROR: flake.nix not found at '$FLAKE'" >&2
  exit 1
fi
if [[ ! -d "$FLAKE/hosts/$HOST" ]]; then
  echo "ERROR: host '$HOST' not found under '$FLAKE/hosts/'" >&2
  echo "Available hosts:" >&2
  ls -1 "$FLAKE/hosts" 2>/dev/null >&2 || true
  exit 1
fi
if [[ ! -f "$FLAKE/hosts/$HOST/hardware.nix" ]]; then
  echo "ERROR: '$FLAKE/hosts/$HOST/hardware.nix' is missing" >&2
  exit 1
fi

echo "Host config found: $FLAKE/hosts/$HOST"
echo "Hardware config:   $FLAKE/hosts/$HOST/hardware.nix"
echo

echo "Pre-install checklist (manual):"
echo "  1) Network is working (needed to fetch flake inputs/substituters if not cached)."
echo "  2) Disks are partitioned/formatted for THIS machine (do not reuse another machine's layout blindly)."
echo "  3) Target filesystems are mounted under '$MNT' (including EFI/boot if used)."
echo "  4) '$FLAKE/hosts/$HOST/hardware.nix' matches this machine (UUIDs, disk IDs, kernel modules, CPU/GPU)."
echo "     - On a new machine, generate and review: nixos-generate-config --root $MNT"
echo "     - For a future Intel/AMD laptop, create/use a dedicated host (e.g. hosts/<laptop>/) and adjust modules accordingly."
echo "  5) Set user passwords during/after install as needed."
echo

if ! command -v nixos-install >/dev/null 2>&1; then
  echo "NOTE: nixos-install not found in PATH (expected on NixOS live ISO)."
fi

echo "Planned command:"
echo "  nixos-install --flake \"$FLAKE#$HOST\""
if [[ "$MNT" != "/mnt" ]]; then
  echo "  (with root set to '$MNT')"
fi
echo

if [[ "$DO_INSTALL" -eq 0 ]]; then
  echo "--no-install set; exiting without changes."
  exit 0
fi

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "ERROR: nixos-install requires root. Re-run with sudo." >&2
  exit 1
fi

read -r -p "Proceed with nixos-install for host '$HOST'? [y/N] " ans
case "$ans" in
  y|Y|yes|YES) ;;
  *) echo "Aborted."; exit 1 ;;
esac

if [[ "$MNT" == "/mnt" ]]; then
  nixos-install --flake "$FLAKE#$HOST"
else
  nixos-install --root "$MNT" --flake "$FLAKE#$HOST"
fi

echo
echo "Install command finished."
echo "Post-install (first boot):"
echo "  - Log in as the configured user, verify network/display/audio."
echo "  - In ~/termina (or repo path): git remote -v, git status, then run t-test / t-switch as needed."
echo "  - Set/change passwords and any secrets manually (never stored in this repo)."
