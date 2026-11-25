# Root - packaged from official Linux AppImage.
# Installer: https://installer.rootapp.com/installer/Linux/X64/Root.AppImage
{ appimageTools, fetchurl, procps }:

let
  pname = "root";
  version = "latest";
  src = fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "sha256-kAaeeEB5qQNkCYX0ERO6IIpBDzCuxtrVI31Ypi1MvNg=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.procps ];
  extraBwrapArgs = [ "--symlink ${procps}/bin/ps /bin/ps" ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/Root.desktop $out/share/applications/root.desktop
    install -Dm444 ${appimageContents}/Root.png $out/share/icons/hicolor/512x512/apps/root.png
    install -Dm444 ${appimageContents}/Root.png $out/share/pixmaps/root.png
    chmod +w $out/share/applications/root.desktop
    substituteInPlace $out/share/applications/root.desktop \
      --replace-fail 'Exec=Root' 'Exec=root' \
      --replace-fail 'Icon=Root' 'Icon=root'
  '';

  meta = {
    description = "Root communications app";
    homepage = "https://rootapp.com";
    mainProgram = "root";
    platforms = [ "x86_64-linux" ];
  };
}
