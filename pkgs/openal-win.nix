# Native OpenAL Soft (Windows DLLs) for wine prefixes.
#
# Why: wine (incl. the wineWow64Packages.staging used here) no longer ships a
# builtin openal32.dll - upstream wine removed its OpenAL wrapper years ago,
# and winetricks has no openal verb. Games bundling their own openal32.dll
# work as-is, but games expecting system-installed OpenAL find nothing.
# This cross-compiles nixpkgs' openal-soft with mingw for both arches and
# provides `wine-openal` to install the right one into a prefix, like the
# official OpenAL redistributable (oalinst.exe) does on Windows.
#
# Usage:
#   wine-openal                 # installs into $WINEPREFIX (or ~/.wine)
#   wine-openal ~/Games/prefix  # explicit prefix
#
# Verified working: 64-bit and 32-bit (WoW64) exes under wine load the dll,
# resolve exports and open an audio device via wine -> PipeWire.
{
  lib,
  runCommand,
  pkgsCross,
}:

let
  # openal-soft's meta.platforms is unix-only; the Windows cross build works
  # fine, so lift the restriction for these private builds.
  fixMeta =
    p:
    p.overrideAttrs (old: {
      meta = (old.meta or { }) // {
        platforms = lib.platforms.all;
        badPlatforms = [ ];
      };
    });

  # No linux audio backends on a Windows target; wine provides those.
  common = {
    dbusSupport = false;
    pipewireSupport = false;
    pulseSupport = false;
  };

  openal32 = fixMeta (pkgsCross.mingw32.openal-soft.override common);
  openal64 = fixMeta (pkgsCross.mingwW64.openal-soft.override common);
in
runCommand "openal-win-${openal32.version}"
  {
    passthru = {
      inherit openal32 openal64;
    };
    meta = {
      description = "Native OpenAL Soft (Windows DLLs, 32+64-bit) for wine prefixes, with installer script";
      platforms = lib.platforms.x86_64;
    };
  }
  ''
    mkdir -p $out/lib/openal-win/win32 $out/lib/openal-win/win64 $out/bin
    cp ${openal32}/bin/*.dll $out/lib/openal-win/win32/
    cp ${openal64}/bin/*.dll $out/lib/openal-win/win64/

    # mingw runtime dlls (libgcc_s*, libstdc++-6, libmcfgthread) ship alongside
    # OpenAL32.dll; the cp above includes them.

    cat > $out/bin/wine-openal <<'SCRIPT'
    #!/bin/sh
    # Install native OpenAL Soft into a wine prefix (default $WINEPREFIX/~/.wine).
    set -eu
    prefix="''${1:-''${WINEPREFIX:-$HOME/.wine}}"
    libdir="$(cd "$(dirname "$(readlink -f "$0")")/../lib/openal-win" && pwd)"

    [ -d "$prefix/drive_c/windows" ] || {
        echo "wine-openal: '$prefix' is not a wine prefix (no drive_c/windows)" >&2
        exit 1
    }
    sys32="$prefix/drive_c/windows/system32"
    syswow="$prefix/drive_c/windows/syswow64"

    # PE machine type of the prefix's own kernel32.dll: 014c = i386, 8664 = x86_64
    mach() {
        off=$(od -An -tu4 -j60 -N4 --endian=little "$1" | tr -d ' ')
        od -An -tx2 -j $((off+4)) -N2 --endian=little "$1" | tr -d ' '
    }

    case "$(mach "$sys32/kernel32.dll")" in
        8664)   # 64-bit system32 (wine64 / new WoW64): 32-bit dlls go to syswow64
            cp -f "$libdir/win64/"*.dll "$sys32/"
            if [ -d "$syswow" ]; then
                cp -f "$libdir/win32/"*.dll "$syswow/"
            else
                echo "note: no syswow64/ - 32-bit games will not find OpenAL" >&2
            fi
            ;;
        014c)   # 32-bit-only prefix
            cp -f "$libdir/win32/"*.dll "$sys32/"
            ;;
        *)
            echo "wine-openal: cannot determine prefix architecture" >&2
            exit 1
            ;;
    esac
    ver=$(cat "$libdir/version" 2>/dev/null || true)
    echo "OpenAL Soft ''${ver:+''${ver} }installed into $prefix"
    SCRIPT
    echo "${openal32.version}" > $out/lib/openal-win/version
    chmod +x $out/bin/wine-openal
  ''
