# Shell functions/init shared by zsh and bash where possible.
{ homeDir, ... }:
''
  # KDE Connect helpers (kdeconnect-cli)
  kc-devices() { kdeconnect-cli --list-devices "$@"; }
  kc-ping() {
    local dev="''${1:?usage: kc-ping <device-name-or-id> [message]}"
    local msg="''${2:-ping from $(hostname)}"
    kdeconnect-cli -n "$dev" --ping-msg "$msg"
  }

  termina() {
    case "''${1:-}" in
      status) shift; git -C "${homeDir}/Projects/termina" status "$@" ;;
      *) echo "usage: termina status" >&2; return 2 ;;
    esac
  }

  # Quick nix shell: , git curl   or   , git curl -- ls
  ,() {
    if [ $# -eq 0 ]; then
      echo "usage: , <pkg...> [-- <cmd...>]" >&2
      return 2
    fi
    local sep=0
    local -a pkgs=() args=()
    local p
    for p in "$@"; do
      if [ "$p" = "--" ]; then sep=1; continue; fi
      if [ "$sep" -eq 1 ]; then args+=("$p"); else pkgs+=("nixpkgs#$p"); fi
    done
    if [ "''${#args[@]}" -gt 0 ]; then
      nix shell "''${pkgs[@]}" -c "''${args[@]}"
    else
      nix shell "''${pkgs[@]}"
    fi
  }

''