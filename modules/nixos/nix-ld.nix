{ pkgs, ... }:
{
  # Helps run unpatched dynamic binaries/AppImages on NixOS.
  # Steam uses its own FHS env; this is for random/foreign binaries.
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
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXt
      xorg.libXtst
      xorg.libXxf86vm
      xorg.libxcb
      xorg.libICE
      xorg.libSM
      xorg.libXScrnSaver
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xkeyboard_config
      # ROCm OpenCL ICD is optional on AMD (can be heavy/driver-specific); add if needed:
      # rocmPackages.clr.icd
    ];
  };
}
