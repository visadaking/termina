#!/usr/bin/env bash
# LOCAL-ONLY migration staging for a NixOS reinstall (termina). NEVER COMMIT OUTPUT.
# Stages: Syncthing identity+config (SENSITIVE), qBittorrent, Sunshine, LocalSend (flatpak),
# and safe app configs (fastfetch/hyfetch/ghostty/kitty/nvim/vim/git/opencode) + selected dotfiles.
#
# Usage:
#   ./scripts/migrate-app-configs.sh [--dry-run] [DEST]
#   ./scripts/migrate-app-configs.sh --syncthing-only [--dry-run] [DEST]
# Default DEST: ~/termina-migration-staging
#
# IMPORTANT (secrets/sensitive):
# - Syncthing: cert.pem/key.pem/config.xml (+ https-*) = device identity/keys. KEEP PRIVATE.
# - Sunshine: credentials/certs/portal_token/state can be sensitive; needed to preserve pairing.
# - qBittorrent: config may contain WebUI password hash and preferences. KEEP PRIVATE.
# - Browser passwords/keys/cookies/sessions are NOT copied by the browser script; run it separately.
# Review DEST before transfer; transfer over a secure channel; delete when done.

set -euo pipefail

DRY=0
SYNCTHING_ONLY=0
DEST="${HOME}/termina-migration-staging"
for a in "${@:-}"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --syncthing-only) SYNCTHING_ONLY=1 ;;
    -h|--help) sed -n '1,30p' "$0"; exit 0 ;;
    *) DEST="$a" ;;
  esac
done

say() { printf '==> %s\n' "$*"; }
warn() { printf '!!  %s\n' "$*"; }
run() { if [ "$DRY" = "1" ]; then echo "DRY: $*"; else "$@"; fi; }
copy_dir() {
  local name="$1" src="$2"
  if [ ! -e "$src" ]; then say "skip $name (not found: $src)"; return 0; fi
  say "copy $name: $src"
  run mkdir -p "$DEST/$name"
  if [ "$DRY" = "1" ]; then echo "DRY: rsync -a $src/ $DEST/$name/"; else rsync -a "$src/" "$DEST/$name/"; fi
}

warn "LOCAL-ONLY staging -> $DEST (NEVER COMMIT). Contains sensitive data (Syncthing keys, app creds)."
run mkdir -p "$DEST"
[ "$DRY" = "0" ] && chmod 700 "$DEST" 2>/dev/null || true

# --- Syncthing (critical: preserves device identity so phone stays paired) ---
say "Syncthing (SENSITIVE: key.pem/cert.pem/config.xml)"
SYNC_CFG=""
for d in "${XDG_STATE_HOME:-$HOME/.local/state}/syncthing" "$HOME/.config/syncthing"; do
  [ -f "$d/config.xml" ] && SYNC_CFG="$d" && break
done
if [ -n "$SYNC_CFG" ]; then
  copy_dir "syncthing" "$SYNC_CFG"
  [ "$DRY" = "0" ] && chmod -R go-rwx "$DEST/syncthing" 2>/dev/null || true
else
  warn "syncthing config not found"
fi

if [ "$SYNCTHING_ONLY" = "1" ]; then
  say "done (--syncthing-only). REVIEW $DEST; NEVER COMMIT."
  exit 0
fi

# --- qBittorrent ---
say "qBittorrent (config may contain WebUI password hash) - SENSITIVE"
copy_dir "config/qBittorrent" "$HOME/.config/qBittorrent"
copy_dir "data/qBittorrent" "$HOME/.local/share/qBittorrent"
[ -f "$HOME/.config/autostart/org.qbittorrent.qBittorrent.desktop" ] && run mkdir -p "$DEST/config/autostart" && run cp -a "$HOME/.config/autostart/org.qbittorrent.qBittorrent.desktop" "$DEST/config/autostart/" || true

# --- Sunshine (host) ---
say "Sunshine (credentials/certs/portal_token/state may be sensitive) - SENSITIVE"
copy_dir "config/sunshine" "$HOME/.config/sunshine"
[ "$DRY" = "0" ] && [ -d "$DEST/config/sunshine" ] && chmod -R go-rwx "$DEST/config/sunshine" 2>/dev/null || true

# --- LocalSend (flatpak data) ---
say "LocalSend (flatpak)"
copy_dir "var-app/org.localsend.localsend_app" "$HOME/.var/app/org.localsend.localsend_app"

# --- Vesktop / Vencord (SENSITIVE: may contain tokens/session-related plugin data) ---
say "Vesktop/Vencord (SENSITIVE - may contain tokens) - NEVER COMMIT"
copy_dir "var-app/dev.vencord.Vesktop" "$HOME/.var/app/dev.vencord.Vesktop/config/vesktop"
copy_dir "config/vesktop" "$HOME/.config/vesktop"
for f in "$HOME"/Downloads/vencord-settings-backup-*.json "$HOME"/Downloads/vesktop-settings-backup-*.json; do
  [ -e "$f" ] || continue
  run mkdir -p "$DEST/vesktop-backups"
  run cp -a "$f" "$DEST/vesktop-backups/"
done
[ "$DRY" = "0" ] && [ -d "$DEST/var-app/dev.vencord.Vesktop" ] && chmod -R go-rwx "$DEST/var-app/dev.vencord.Vesktop" 2>/dev/null || true
[ "$DRY" = "0" ] && [ -d "$DEST/vesktop-backups" ] && chmod -R go-rwx "$DEST/vesktop-backups" 2>/dev/null || true

# --- OBS / MPV / VLC (native configs) ---
say "media app configs (OBS/MPV/VLC)"
copy_dir "config/obs-studio" "$HOME/.config/obs-studio"
copy_dir "config/mpv" "$HOME/.config/mpv"
copy_dir "config/vlc" "$HOME/.config/vlc"

# --- Gaming launcher configs (metadata only; /games data never touched) ---
say "launcher configs (Heroic/Prism/Bottles - metadata; /games untouched)"
copy_dir "config/heroic" "$HOME/.config/heroic"
copy_dir "data/PrismLauncher" "$HOME/.local/share/PrismLauncher"
copy_dir "var-app/com.heroicgameslauncher.hgl/config" "$HOME/.var/app/com.heroicgameslauncher.hgl/config"
copy_dir "var-app/com.heroicgameslauncher.hgl/data" "$HOME/.var/app/com.heroicgameslauncher.hgl/data"
copy_dir "var-app/org.prismlauncher.PrismLauncher/config" "$HOME/.var/app/org.prismlauncher.PrismLauncher/config"
copy_dir "var-app/org.prismlauncher.PrismLauncher/data" "$HOME/.var/app/org.prismlauncher.PrismLauncher/data"
copy_dir "var-app/com.usebottles.bottles" "$HOME/.var/app/com.usebottles.bottles"

# --- Flatpak -> native app data (SENSITIVE: may contain sessions/auth/logins) - review before restoring ---
warn "Staging flatpak app data for apps moved to native (may contain sessions/logins/tokens). SENSITIVE - NEVER COMMIT."
for app in com.obsproject.Studio md.obsidian.Obsidian com.spotify.Client org.telegram.desktop org.signal.Signal org.localsend.localsend_app; do
  [ -d "$HOME/.var/app/$app/config" ] && copy_dir "var-app/$app/config" "$HOME/.var/app/$app/config"
  [ -d "$HOME/.var/app/$app/data" ] && copy_dir "var-app/$app/data" "$HOME/.var/app/$app/data"
done

# --- GPG / SSH (VERY SENSITIVE) ---
warn "GPG/SSH are VERY SENSITIVE (private keys). Staging for migration - NEVER COMMIT."
[ -d "$HOME/.gnupg" ] && copy_dir "gnupg" "$HOME/.gnupg" && [ "$DRY" = "0" ] && chmod -R go-rwx "$DEST/gnupg" 2>/dev/null || true
[ -d "$HOME/.ssh" ] && copy_dir "ssh" "$HOME/.ssh" && [ "$DRY" = "0" ] && chmod -R go-rwx "$DEST/ssh" 2>/dev/null || true

# --- Safe app configs (review contents) ---
say "safe app configs (review; do not include tokens)"
for d in fastfetch hyfetch ghostty kitty nvim vim git opencode; do
  [ -e "$HOME/.config/$d" ] && run mkdir -p "$DEST/config" && run rsync -a "$HOME/.config/$d" "$DEST/config/" 2>/dev/null || true
done
[ -f "$HOME/.config/hyfetch.json" ] && run mkdir -p "$DEST/config" && run cp -a "$HOME/.config/hyfetch.json" "$DEST/config/" || true

# --- dotfiles ---
for f in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.vimrc" "$HOME/.gitconfig"; do
  [ -e "$f" ] && run mkdir -p "$DEST/home" && run cp -a "$f" "$DEST/home/" || true
done

# --- wallpaper ---
say "wallpaper"
if [ -f "$HOME/trash/wallpapers/ergo-proxy-kw9yj7-1920x1080.png" ]; then
  run mkdir -p "$DEST/wallpapers"
  run cp -a "$HOME/trash/wallpapers/ergo-proxy-kw9yj7-1920x1080.png" "$DEST/wallpapers/"
fi

say "done. REVIEW $DEST carefully. SENSITIVE contents present (syncthing keys, sunshine/qbit creds)."
warn "NEVER COMMIT $DEST. Transfer securely. Restore Syncthing identity on new NixOS to keep phone paired."
say "Browser profiles (passwords/keys/cookies/sessions excluded): run scripts/migrate-browser-profiles.sh separately."