{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "whyd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "vmaltarello";
    repo = "whyd";
    rev = "v${version}";
    hash = "sha256-Fe8se85Q5n5ywkRhAZOeYEcE+HBixDuSEyrCZVSksMU=";
  };

  vendorHash = "sha256-BwpVal1/v7+rNr1VC/LYEzRPtODbgewfY3zQxdOFxSw=";

  subPackages = [ "cmd/whyd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Diagnose why your Linux system froze, crashed or shut down by analyzing the previous boot's journal";
    homepage = "https://github.com/vmaltarello/whyd";
    license = lib.licenses.gpl3Plus;
    mainProgram = "whyd";
    platforms = lib.platforms.linux;
  };
}
