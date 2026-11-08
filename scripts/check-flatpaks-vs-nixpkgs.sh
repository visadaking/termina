#!/usr/bin/env bash
# Read-only (openSUSE-friendly): list installed Flatpaks and report which are likely
# available as native nixpkgs packages (so installing the Flatpak was avoidable for a
# NixOS/nixpkgs-native setup like termina). Does NOT install/remove anything.
#
# Usage:
#   ./scripts/check-flatpaks-vs-nixpkgs.sh            # static mapping report
#   ./scripts/check-flatpaks-vs-nixpkgs.sh --nix      # also try `nix search` if nix is installed
#
# Notes:
# - "native-likely/verify" = nixpkgs package usually exists; verify attr on your channel
#   (nixos-26.11 stable / nixos-unstable) via search.nixos.org or `nix search nixpkgs <name>`.
# - Your termina config uses 26.11 base + pkgs.unstable overlay.
# - This is guidance, not a guarantee (attrs change across channels).

set -euo pipefail

DO_NIX=0
for a in "${@:-}"; do
  case "$a" in
    --nix|--nix-search) DO_NIX=1 ;;
    -h|--help) sed -n '1,40p' "$0"; exit 0 ;;
  esac
done

has() { command -v "$1" >/dev/null 2>&1; }

if ! has flatpak; then
  echo "error: flatpak not found on PATH" >&2
  exit 1
fi

# mapping: app_id|nixpkgs_attr_candidates|channel_hint|status|note
# status: NATIVE-LIKELY, NATIVE-VERIFY, FLATPAK/MANUAL, SKIPPED(choice), NICHE-VERIFY
map_entry() {
  case "$1" in
    app.fluxer.Fluxer)                echo "fluxer?|unstable|NICHE-VERIFY|verify on search.nixos.org" ;;
    chat.simplex.simplex)             echo "simplex-chat-desktop, simplex-chat|unstable|NATIVE-VERIFY|attr name varies by channel" ;;
    com.anydesk.Anydesk)              echo "anydesk|unstable|NATIVE-VERIFY|unfree/proprietary; availability varies" ;;
    com.heroicgameslauncher.hgl)      echo "heroic|unstable|NATIVE-LIKELY|often newer on unstable (enabled in termina)" ;;
    com.moonlight_stream.Moonlight)   echo "moonlight-qt|stable/unstable|NATIVE-LIKELY|native available" ;;
    com.nuclearplayer.Nuclear)        echo "nuclear|stable/unstable|NATIVE-LIKELY|enabled in termina" ;;
    com.obsproject.Studio)            echo "obs-studio|stable/unstable|NATIVE-LIKELY|enabled in termina" ;;
    com.protonvpn.www)                echo "proton-vpn-gtk-app, proton-vpn-cli, protonvpn-gui|unstable|NATIVE-VERIFY|attr changed over time; verify (proton-vpn added in termina - verify)" ;;
    com.rtosta.zapzap)                echo "zapzap|unstable|NATIVE-VERIFY|verify attr" ;;
    com.spotify.Client)               echo "spotify|unstable|NATIVE-LIKELY|unfree (enabled in termina)" ;;
    com.usebottles.bottles)           echo "bottles|unstable|NATIVE-VERIFY|verify attr/unfree flags" ;;
    com.vscodium.codium)              echo "vscodium|stable/unstable|NATIVE-LIKELY|pkgs.unstable.vscodium for latest (enabled)" ;;
    dev.vencord.Vesktop)              echo "vesktop|unstable|NATIVE-LIKELY|often newer on unstable (enabled)" ;;
    fm.reaper.Reaper)                 echo "(none)|-|FLATPAK/MANUAL|proprietary DAW; no nixpkgs package" ;;
    hu.irl.cameractrls)              echo "cameractrls|stable/unstable|NATIVE-VERIFY|native likely; verify attr" ;;
    im.riot.Riot)                     echo "element-desktop|stable/unstable|NATIVE-LIKELY|enabled in termina" ;;
    info.mumble.Mumble)               echo "mumble|stable|NATIVE-LIKELY|native available" ;;
    io.ente.auth)                     echo "ente-auth|unstable|NATIVE-VERIFY|verify attr" ;;
    io.github.block.Goose)            echo "goose?|unstable|NICHE-VERIFY|verify packaging/upstream" ;;
    io.github.peazip.PeaZip)          echo "peazip|stable/unstable|NATIVE-VERIFY|may exist; verify" ;;
    io.gitlab.theevilskeleton.Upscaler) echo "upscaler?|stable/unstable|NATIVE-VERIFY|verify attr (may be native or not)" ;;
    io.itch.itch)                     echo "itch|unstable|NATIVE-VERIFY|verify on your channel (itch added in termina - verify); fallback flatpak/web" ;;
    md.obsidian.Obsidian)             echo "obsidian|unstable|NATIVE-LIKELY|unfree/electron caveats" ;;
    net.lutris.Lutris)                echo "lutris|unstable|SKIPPED(choice)|native exists but skipped in termina (Heroic only)" ;;
    org.azahar_emu.Azahar)            echo "azahar|unstable|NATIVE-VERIFY|native on newer channels; verify" ;;
    org.desktop_plus.desktop-plus)    echo "(?)|unstable|NICHE-VERIFY|search nixpkgs by name" ;;
    org.fooyin.fooyin)                echo "fooyin|stable/unstable|NATIVE-LIKELY|enabled in termina (verify attr)" ;;
    org.freac.freac)                  echo "freac|stable/unstable|NATIVE-VERIFY|may exist; verify" ;;
    org.jellyfin.JellyfinDesktop)     echo "jellyfin-media-player|stable|NATIVE-LIKELY|native available" ;;
    org.kde.krita)                    echo "krita|stable|NATIVE-LIKELY|native available" ;;
    org.localsend.localsend_app)      echo "localsend|stable/unstable|NATIVE-LIKELY|enabled in termina" ;;
    org.nicotine_plus.Nicotine)       echo "nicotine-plus|stable|NATIVE-LIKELY|native available" ;;
    org.openlogi.OpenLogi)            echo "openlogi?|unstable|NICHE-VERIFY|openlogi added in termina - verify attr exists" ;;
    org.prismlauncher.PrismLauncher)  echo "prismlauncher|unstable|NATIVE-LIKELY|often newer on unstable (enabled)" ;;
    org.signal.Signal)                echo "signal-desktop|unstable|NATIVE-LIKELY|often newer on unstable (enabled)" ;;
    org.telegram.desktop)             echo "telegram-desktop|stable/unstable|NATIVE-LIKELY|enabled" ;;
    org.vinegarhq.Sober)              echo "sober?|unstable|FLATPAK/MANUAL|generally not in main nixpkgs; check status" ;;
    us.zoom.Zoom)                     echo "zoom-us|unstable|NATIVE-VERIFY|unfree; native exists" ;;
    xyz.xclicker.xclicker)            echo "xclicker|stable/unstable|NATIVE-VERIFY|native likely; verify attr" ;;
    org.keepassxc.KeePassXC)          echo "keepassxc|stable|NATIVE-LIKELY|enabled in termina (migrate DB/keys manually)" ;;
    *)                                echo "(unknown)|unstable|NICHE-VERIFY|search: nix search nixpkgs <name>" ;;
  esac
}

print_section() {
  local scope="$1"; shift
  echo
  echo "== $scope Flatpaks =="
  printf "%-38s %-28s %-10s %s\n" "APP ID" "NIXPKG ATTR(S)" "STATUS" "NOTE (channel)"
  printf "%-38s %-28s %-10s %s\n" "------" "--------------" "------" "-------------"
  local id name info attrs hint status note
  while IFS=$'\t' read -r id name; do
    [ -n "${id:-}" ] || continue
    info="$(map_entry "$id")"
    IFS='|' read -r attrs hint status note <<<"$info"
    printf "%-38s %-28s %-10s %s [%s]\n" "$id" "$attrs" "$status" "$note" "$hint"
  done
}

echo "Flatpak -> nixpkgs check (read-only) - $(date -Iseconds 2>/dev/null || date)"
echo "Host: $(hostname 2>/dev/null || echo unknown) | system: $(flatpak --version 2>/dev/null || echo ?)"
echo "Channel context for termina: nixos-26.11 base + nixos-unstable overlay (pkgs.unstable.<pkg>)"

flatpak list --system --app --columns=application,name 2>/dev/null | print_section "SYSTEM"
flatpak list --user   --app --columns=application,name 2>/dev/null | print_section "USER"

echo
echo "== Summary =="
sys_native=$(flatpak list --system --app --columns=application 2>/dev/null | while read -r id; do map_entry "$id"; done | grep -c '^.*,.*NATIVE' || true)
usr_native=$(flatpak list --user   --app --columns=application 2>/dev/null | while read -r id; do map_entry "$id"; done | grep -c '^.*,.*NATIVE' || true)
manual=$( (flatpak list --system --app --columns=application 2>/dev/null; flatpak list --user --app --columns=application 2>/dev/null) | while read -r id; do map_entry "$id"; done | grep -c 'FLATPAK/MANUAL' || true)
echo "Native nixpkgs candidates (likely/verify): ~$((sys_native+usr_native))  |  Flatpak/manual-only: ~$manual  |  plus niche/choice items"
echo "=> 'Mistake' candidates (native available, so Flatpak wasn't necessary for nixpkgs-native setup): any row marked NATIVE-LIKELY or NATIVE-VERIFY."
echo "=> Still legitimate as Flatpak/manual: FLATPAK/MANUAL rows (e.g. Reaper proprietary, Sober) and anything you intentionally prefer as Flatpak."

if [ "$DO_NIX" = "1" ]; then
  echo
  echo "== nix search (optional; best-effort) =="
  if has nix; then
    echo "nix detected - sampling a few lookups against nixos-unstable (may be slow/networked)..."
    for q in heroic vesktop vscodium signal-desktop prismlauncher itch proton-vpn-gtk-app azahar cameractrls xclicker upscaler openlogi redact music-presence; do
      printf "\n-- nix search nixpkgs %s (legacyPackages.x86_64-linux via nixpkgs/unstable hint) --\n" "$q"
      nix search nixpkgs "$q" 2>&1 | head -n 12 || true
    done
  else
    echo "nix not installed on this (openSUSE) host; skipping. Run with nix available, or use:"
    echo "  nix search nixpkgs <name>"
    echo "  nix search github:NixOS/nixpkgs/nixos-unstable <name>"
    echo "  https://search.nixos.org/packages?channel=26.11&query=<name>"
  fi
fi

echo
echo "Done (no changes made). Review against termina: /home/visa/Documents/GitHub/termina/docs/package-mapping.md"