#!/usr/bin/env bash
# Read-only (openSUSE): audit installed zypper/RPM packages and suggest nixpkgs equivalents
# for a nixpkgs-native NixOS (termina) setup. Does NOT install/remove anything.
#
# Usage:
#   ./scripts/check-zypper-vs-nixpkgs.sh              # summary of notable packages + mapping
#   ./scripts/check-zypper-vs-nixpkgs.sh --all        # also dump full rpm -qa name list to stdout (large)
#   ./scripts/check-zypper-vs-nixpkgs.sh --export FILE  # write notable mapping report to FILE
#
# Context: openSUSE repos/hacks are not carried to termina. Many libs/daemons differ on NixOS;
# focus on user-facing apps and tools.

set -euo pipefail

SHOW_ALL=0
EXPORT=""
for a in "${@:-}"; do
  case "$a" in
    --all) SHOW_ALL=1 ;;
    --export) shift; EXPORT="${1:-}";;
    -h|--help) sed -n '1,20p' "$0"; exit 0 ;;
  esac
done

has() { command -v "$1" >/dev/null 2>&1; }
if ! has rpm; then echo "error: rpm not found" >&2; exit 1; fi

report() {
  echo "zypper/RPM -> nixpkgs audit (read-only) - $(date -Iseconds 2>/dev/null || date)"
  echo "Host RPM count: $(rpm -qa | wc -l) (most are libs/openSUSE base - not all needed on NixOS)"
  echo "Termina: nixos-26.11 base + pkgs.unstable overlay; prefer nixpkgs-native."
  echo
  echo "== Notable user-facing packages detected -> nixpkgs/termina status =="
  printf "%-28s %-12s %-34s %s\n" "RPM/APP" "DETECTED" "NIXPKGS / STATUS" "NOTE"
  printf "%-28s %-12s %-34s %s\n" "-------" "--------" "----------------" "----"

  row() {
    local name="$1" pat="$2" nix="$3" note="$4"
    local det="no"
    if rpm -qa --qf '%{NAME}\n' 2>/dev/null | grep -qiE "^${pat}$|${pat}"; then det="yes"; fi
    printf "%-28s %-12s %-34s %s\n" "$name" "$det" "$nix" "$note"
  }

  row "firefox" "MozillaFirefox|firefox" "firefox ✅" "browser (if installed)"
  row "chromium" "chromium" "chromium (skip/not needed)" "you chose not needed"
  row "vivaldi" "vivaldi" "vivaldi ✅ (if used)" "verify on nixpkgs"
  row "ghostty" "ghostty" "ghostty ✅" "terminal"
  row "kitty" "kitty" "kitty ✅" "terminal"
  row "neovim/vim" "neovim|vim" "neovim/vim ✅" "editors"
  row "opencode" "opencode" "opencode ✅ added" "verify attr/channel"
  row "vscodium(code)" "vscodium|codium|code" "vscodium ✅ / vscode" "you use vscodium"
  row "git/gh/lazygit" "git$|gh$|lazygit" "git/gh/lazygit ✅" "dev"
  row "podman/distrobox" "podman|distrobox" "podman/distrobox ✅" "containers"
  row "virt/libvirt/qemu" "libvirt|qemu|virt-manager" "virtualisation module ✅" "termina"
  row "steam" "steam" "programs.steam ✅" "system; /games untouched"
  row "ProtonPlus" "ProtonPlus|protonplus" "protonplus ✅" "gaming"
  row "mangohud/gamescope" "mangohud|gamescope" "mangohud/gamescope ✅" "gaming"
  row "wine-staging(32/64)" "wine-staging" "wineWowPackages.staging ✅" "pkgs.unstable in termina"
  row "obs-studio" "obs-studio" "obs-studio ✅" "media"
  row "vlc/mpv" "vlc$|mpv" "vlc/mpv ✅" "media"
  row "audacity" "audacity" "audacity (add if wanted)" "native"
  row "fastfetch/hyfetch" "fastfetch|hyfetch" "fastfetch/hyfetch ✅" "configs migrated"
  row "keepassxc" "keepassxc" "keepassxc ✅" "migrate DB/keys manually"
  row "syncthing" "syncthing" "services.syncthing HM ✅" "keep identity/keys out of repo"
  row "Sunshine" "Sunshine|sunshine" "sunshine (optional)" "game streaming host"
  row "openvpn" "openvpn" "openvpn (optional)" "add if needed"
  row "filezilla" "filezilla" "filezilla ✅" "added"
  row "node/python/java/rust" "nodejs|python3|java-.*openjdk|cargo|rust" "add as needed" "toolchain; pin per-project via devShells/direnv often better"
  row "gcc/clang/cmake/ninja" "gcc$|clang|cmake$|ninja$" "gcc/gnumake etc. baseline ✅" "build deps vary"

  echo
  echo "== Notes =="
  echo "- openSUSE-specific patterns, YaST/zypper plugins, and base libs are NOT 1:1 on NixOS; declare user apps/services instead."
  echo "- Check untracked GUI apps installed outside rpm/flatpak (AppImages, tarballs in ~/Downloads/~/AppImages)."
  echo "- For anything missing: nix search nixpkgs <name> (or unstable) and add to termina."
  echo "- Compare with: docs/package-mapping.md and scripts/check-flatpaks-vs-nixpkgs.sh"
}

if [ -n "$EXPORT" ]; then
  report > "$EXPORT"
  echo "wrote: $EXPORT"
else
  report
fi

if [ "$SHOW_ALL" = "1" ]; then
  echo
  echo "== Full RPM name list (rpm -qa --qf '%{NAME}\n' | sort -u) =="
  rpm -qa --qf '%{NAME}\n' | sort -u
fi