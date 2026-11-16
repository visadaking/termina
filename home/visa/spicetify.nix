{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;

    # Tokyo Night theme customized with Plasma teal accent ("tokyonightteal")
    theme = {
      name = "tokyonightteal";
      src = ../../assets/spicetify-themes/termina;
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      sidebarConfig = true;
      overwriteAssets = false;
    };
    colorScheme = "Teal";

    # help bring back some older UI feel where possible
    enabledExtensions = with spicePkgs.extensions; [
      oldSidebar
    ];
  };
}
