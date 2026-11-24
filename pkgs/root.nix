# Root - packaged from official Linux AppImage.
# Installer: https://installer.rootapp.com/installer/Linux/X64/Root.AppImage
{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "root";
  version = "latest";

  src = fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "sha256-rdhCGvBpVsb8LmBktg1Brm4+8MWLFAeIC6ASntyHZD8=";
  };

  meta = {
    description = "Root communications app";
    homepage = "https://rootapp.com";
    mainProgram = "root";
    platforms = [ "x86_64-linux" ];
  };
}
