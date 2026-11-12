{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kcmutils
    kdePackages.knighttime
    kdePackages.libplasma
    kdePackages.plasma-workspace
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
  ];

  cmakeFlags = [
    "-DBUILD_PLUGIN=ON"
    "-DINSTALL_WALLPAPER=ON"
  ];

  # Qt/KDE paths
  dontWrapQtApps = false;

  meta = with lib; {
    description = "Plasma 6 wallpaper plugin to play videos on your desktop/lock screen";
    homepage = "https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
