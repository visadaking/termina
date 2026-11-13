{ lib
, appimageTools
, fetchurl
}:

let
  pname = "lichii";
  version = "build-160";
  src = fetchurl {
    url = "https://github.com/zortos293/Lichii/releases/download/${version}/lichii-linux-x86_64-pgo.AppImage";
    hash = "sha256-zBoJ5Gw+Bg6vEJE0BAoUSK4I/b1RtYZuE+qfQrDZEzI=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libGL
    vulkan-loader
    libdrm
    libusb1
    zlib
    libgpg-error
    libgcrypt
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcursor
    xorg.libxcb
    libxkbcommon
    wayland
    fontconfig
    freetype
    harfbuzz
    fribidi
    dbus
    alsa-lib
    pipewire
    pulseaudio
    SDL2
  ];

  extraInstallCommands = ''
    if [ -d ${appimageContents}/usr/share ]; then
      cp -r ${appimageContents}/usr/share $out/share
    fi
  '';

  meta = with lib; {
    description = "Experimental Nintendo Switch 2 emulator";
    homepage = "https://github.com/zortos293/Lichii";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lichii";
  };
}
