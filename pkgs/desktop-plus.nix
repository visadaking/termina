{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libglvnd,
  libnotify,
  libsecret,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  libxshmfence,
}:

stdenv.mkDerivation rec {
  pname = "desktop-plus";
  version = "3.6.12.0";

  src = fetchurl {
    url = "https://github.com/desktop-plus/desktop-plus/releases/download/v${version}/DesktopPlus-v${version}-linux-x86_64.deb";
    hash = "sha256-kaxR6fM46kptiqQd2/VH10N+q8i7h1CVWpoQuPiiPYc=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libglvnd
    libnotify
    libsecret
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    libxshmfence
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -xf - --no-same-owner --no-same-permissions
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share
    cp -r usr/lib/desktop-plus $out/opt/desktop-plus
    cp -r usr/share/* $out/share/

    # Fix desktop entry
    if [ -f $out/share/applications/desktop-plus.desktop ]; then
      substituteInPlace $out/share/applications/desktop-plus.desktop \
        --replace-fail '/usr/bin/desktop-plus' "$out/bin/desktop-plus" \
        --replace-fail '/usr/lib/desktop-plus/desktop-plus' "$out/bin/desktop-plus" || true
    fi

    makeWrapper $out/opt/desktop-plus/desktop-plus $out/bin/desktop-plus \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Git client for power users";
    homepage = "https://github.com/desktop-plus/desktop-plus";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "desktop-plus";
  };
}
