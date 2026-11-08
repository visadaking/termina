{ pkgs, ... }:
{
  # Helps run unpatched dynamic binaries/AppImages (e.g. lichii in ~/Downloads) on NixOS.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
      curl
      glib
      util-linux
      libusb1
      icu
    ];
  };
}
