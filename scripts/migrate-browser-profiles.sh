#!/usr/bin/env bash
# local-only helper: migrate browser profiles into a staging dir for review/copy.
# EXCLUDES passwords/keys/cookies/sessions (and other sensitive stores). NEVER COMMIT OUTPUT.
# usage: ./scripts/migrate-browser-profiles.sh [--dry-run] [DEST]
set -euo pipefail

DRY=0
DEST="${HOME}/termina-migration-staging"
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    *) DEST="$a" ;;
  esac
done

say() { printf '==> %s\n' "$*"; }
run() { if [ "$DRY" = "1" ]; then echo "DRY: $*"; else "$@"; fi }

say "staging -> $DEST (review before using; never commit)"
run mkdir -p "$DEST"

copy_profile() {
  local name="$1" src="$2"; shift 2
  local -a excludes=("$@")
  if [ ! -e "$src" ]; then say "skip $name (not found: $src)"; return 0; fi
  say "copy $name: $src"
  local -a args=( -a --info=NAME )
  local e; for e in "${excludes[@]}"; do args+=( "--exclude=$e" ); done
  run mkdir -p "$DEST/$name"
  if [ "$DRY" = "1" ]; then
    echo "DRY: rsync ${args[*]} $src/ $DEST/$name/"
  else
    rsync "${args[@]}" "$src/" "$DEST/$name/"
  fi
}

# Firefox: exclude password/credential stores + cookies/sessions
FF_EXCLUDES=(
  'logins.json' 'key4.db' 'key3.db' 'signons.sqlite'
  'cookies.sqlite' 'cookies.sqlite-wal' 'cookies.sqlite-shm'
  'sessionstore*' 'sessionCheckpoints.json' 'sessionstore-backups/'
  'storage/default/*' # may include site state; remove this exclude if you want it (review carefully)
)
copy_profile firefox "$HOME/.mozilla/firefox" "${FF_EXCLUDES[@]}"

# Vivaldi/Chromium: exclude password stores + cookies/sessions (+ local state encryption can be sensitive)
VIV_EXCLUDES=(
  'Login Data*' 'Cookies*' 'Cookies'
  'Session*' 'Sessions/' 'Current Session' 'Current Tabs' 'Last Session' 'Last Tabs'
  'Network/Cookies*'
  'Extension Cookies*'
  'Web Data' # can contain autofill; keep excluded to be safe
)
copy_profile vivaldi "$HOME/.config/vivaldi" "${VIV_EXCLUDES[@]}"

# safe app configs to move over (review contents; do not include secrets/tokens)
say "copy safe configs (review before using)"
for d in fastfetch ghostty kitty nvim vim git opencode hyfetch; do
  if [ -e "$HOME/.config/$d" ]; then
    run mkdir -p "$DEST/config"
    run rsync -a --info=NAME "$HOME/.config/$d" "$DEST/config/" 2>/dev/null || true
  fi
done
# single config files (e.g. hyfetch.json lives directly in ~/.config)
for f in "$HOME/.config/hyfetch.json"; do
  [ -e "$f" ] && run mkdir -p "$DEST/config" && run cp -a "$f" "$DEST/config/" || true
done
# home dotfiles
for f in "$HOME/.zshrc" "$HOME/.vimrc" "$HOME/.gitconfig"; do
  [ -e "$f" ] && run mkdir -p "$DEST/home" && run cp -a "$f" "$DEST/home/" || true
done

say "done. REVIEW $DEST carefully (ensure no passwords/keys/tokens/cookies/sessions). never commit it."
say "note: adjust excludes if you intentionally want to keep more (e.g. remove Web Data/storage exclusion) - review carefully."
