{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kiri";
  version = "1.1-unstable-2026-11-26";

  src = fetchFromGitHub {
    owner = "SeniorMatt";
    repo = "kiri";
    rev = "0fe4a758c6e260f13f37d7b4df487506083e8f52";
    hash = "sha256-MDYleqtV3m4VhjTzY5t6sQQUcybiZOWoZCBaNJncgfM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-skgICRmfbk3SGUyZmEZyd/5EkN2MYMFc4M5n0mVKhMM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild
    pnpm exec tsc -p ./src/main --outFile ./package/contents/code/main.js
    mkdir -p ./package/contents/config
    pnpm exec tsc -p ./src/generators/config --outFile ./run-ts-tmp.js
    node ./run-ts-tmp.js > ./package/contents/config/main.xml
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/scripts/kiri
    cp -r package/* $out/share/kwin/scripts/kiri/
    runHook postInstall
  '';

  meta = {
    description = "scrolling tiling for kde plasma 6";
    homepage = "https://github.com/SeniorMatt/kiri";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
