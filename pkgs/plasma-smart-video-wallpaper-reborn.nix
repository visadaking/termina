{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  kdePackages,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "plasma-smart-video-wallpaper-reborn";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-smart-video-wallpaper-reborn";
    rev = "v${version}";
    hash = "sha256-ACMu7/5IrF4+uLyE7AbIlicUWTuKpZAVz9B2VwXnxl0=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    kdePackages.libplasma
    kdePackages.ki18n
    kdePackages.kcmutils
    kdePackages.knighttime
  ];

  # Wallpaper package (QML) + plugin for day/night cycle integration.
  cmakeFlags = [
    "-DBUILD_PLUGIN=ON"
    "-DINSTALL_WALLPAPER=ON"
  ];

  # Qt6 cmake modules are found via Qt6_DIR/KDE paths provided by hooks.
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Plasma 6 wallpaper plugin to play videos on your desktop/lock screen";
    homepage = "https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
