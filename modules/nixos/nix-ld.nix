{ pkgs, ... }:
{
  # steam
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      bzip2
      openssl
      curl
      glib
      dbus
      expat
      fontconfig
      freetype
      alsa-lib
      alsa-plugins
      libGL
      libGLU
      mesa
      libxkbcommon
      xdg-utils
      nspr
      nss
      libarchive
      libcap
      librsvg
      libuuid
      libxcrypt
      ocl-icd
      icu
      util-linux
      libusb1
      udev
      # X11/xcb (common for AppImages/games/tools)
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxinerama
      libxrandr
      libxrender
      libxt
      libxtst
      libxxf86vm
      libxcb
      libice
      libsm
      libxscrnsaver
      libxcb-util
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      xkeyboard_config
      # ROCm
    ];
  };
}
