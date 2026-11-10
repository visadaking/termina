{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  python3,
  librsvg,
  xcursorgen,
}:

# Simp1e cursor theme (capitaine successor), Tokyo Night Storm color scheme.
# Built from the upstream simp1e source + pinned cursor-generator submodule.
# Upstream scheme: src/color_schemes/Simp1e-Tokyo-Night-Storm.txt
#   cursor bg #24283b (storm bg), outline #a9b1d6, accents from the tokyo night storm palette.
stdenvNoCC.mkDerivation {
  pname = "simp1e-tokyo-night-storm";
  version = "0-unstable-2024-10-11";

  src = fetchFromGitLab {
    owner = "cursors";
    repo = "simp1e";
    rev = "f8f8f3c09dd0aa31cc9bc5499c683aad025984be";
    hash = "sha256-clBfwor+3GKHl+Vt98diHDlkCnC/UQfIkObsUkUO7eg=";
  };

  # pinned by simp1e at the rev above (git submodule)
  cursorGenerator = fetchFromGitLab {
    owner = "cursors";
    repo = "cursor-generator";
    rev = "dd4a730c4a45c73c580220658bd1f21f141f8a55";
    hash = "sha256-6qF0IWwsNYrMPLG48UH8zX7YETQh+XIqYyUkcOh8PNg=";
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.pillow ]))
    librsvg
    xcursorgen
  ];

  env.LC_ALL = "C.UTF-8";

  buildPhase = ''
    runHook preBuild

    # populate the pinned cursor-generator submodule (build.sh then skips git submodule update)
    # (fetchFromGitLab strips the archive root, so $cursorGenerator is the tree itself)
    rm -rf cursor-generator
    cp -a "$cursorGenerator" cursor-generator

    # build only the Tokyo Night Storm scheme (right-handed cursors.svg template)
    bash build.sh --include=cursors.svg,Simp1e-Tokyo-Night-Storm.txt

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/icons"
    cp -a built_themes/Simp1e-Tokyo-Night-Storm "$out/share/icons/"
    runHook postInstall
  '';

  meta = {
    description = "Simp1e cursors, Tokyo Night Storm color scheme";
    homepage = "https://gitlab.com/cursors/simp1e";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
