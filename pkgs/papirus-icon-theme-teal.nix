{ papirus-icon-theme, papirus-folders }:
papirus-icon-theme.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ papirus-folders ];
  postInstall = (old.postInstall or "") + ''
    export HOME="$TMPDIR"
    export XDG_DATA_DIRS="$out/share"
    papirus-folders -C teal --theme Papirus-Dark -o
    papirus-folders -C teal --theme Papirus -o
  '';
})
