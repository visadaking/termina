{
  config,
  pkgs,
  lib,
  ...
}:
let
  # my own theme
  simp1e-tokyo-night-storm = pkgs.callPackage ../../pkgs/simp1e-tokyo-night-storm.nix { };
  papirus-icon-theme-teal = pkgs.callPackage ../../pkgs/papirus-icon-theme-teal.nix { };
in
{
  # my own theme
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B";
      package = pkgs.tokyonight-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "default" ];
        tweakVariants = [ "storm" ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus-icon-theme-teal;
    };
    cursorTheme = {
      name = "Simp1e-Tokyo-Night-Storm";
      package = simp1e-tokyo-night-storm;
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # because of steam amazing support for wayland (no, they're both using X11/xwayland and GTK (hell) i had to set them the same cursor as wayland/plasma ¯\_(ツ)_/¯
  home.pointerCursor = {
    enable = true;
    name = "Simp1e-Tokyo-Night-Storm";
    package = simp1e-tokyo-night-storm;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # workaround for KWin/libX11
  home.sessionVariables = {
    XCOMPOSEFILE = "${pkgs.libx11}/share/X11/locale/en_US.UTF-8/Compose";
  };

  # G25F2 without VRR
  xdg.configFile."kwinoutputconfig.json".source = ./kwinoutputconfig-g25f2.json;
  xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".source = ./plasma-org.kde.plasma.desktop-appletsrc;

  # plasma manager
  # keybinds
  # wallpapers
  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png";
      cursor = {
        theme = "Simp1e-Tokyo-Night-Storm";
        size = 24;
      };
      # tokyo night
      # tokyo night but my own version
    };
    shortcuts = {
      ksmserver."Lock Session" = "Meta+Esc";
      kwin = {
        "Overview" = "Meta+W";
        "Grid View" = "Meta+G";
        "Show Desktop" = "Meta+D";
        "Window Close" = "Meta+Q";
        "Kill Window" = "Meta+Ctrl+Esc";
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch One Desktop Down" = "Meta+Ctrl+Down";
        "Switch One Desktop Up" = "Meta+Ctrl+Up";
        "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
        "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
        "Walk Through Windows" = "Meta+Tab";
        "Walk Through Windows (Reverse)" = "Meta+Shift+Tab";
        "Walk Through Windows of Current Application" = "Meta+`";
        "Walk Through Windows of Current Application (Reverse)" = "Meta+~";
      };
      kmix = {
        "decrease_volume" = "Volume Down";
        "increase_volume" = "Volume Up";
        "mute" = "Volume Mute";
        "mic_mute" = [
          "Microphone Mute"
          "Meta+Volume Mute"
        ];
      };
      "KDE Keyboard Layout Switcher" = {
        "Switch to Next Keyboard Layout" = "Alt+Shift";
      };
    };
    # keyboard layouts for Plasma (US + Hebrew, Alt+Shift toggle) - important
    configFile = {
      kxkbrc.Layout = {
        Use.value = true;
        LayoutList.value = "us,il";
        VariantList.value = ",";
        Options.value = "grp:alt_shift_toggle";
        ResetOldOptions.value = true;
        SwitchMode.value = "Global";
      };
      # from old dotfiles
      kdeglobals.General.AccentColor = "92,185,174";
      # Spectacle: stupid fucking pop up
      spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
      spectaclerc.GuiConfig.quitAfterSaveCopyExport = true;

      dolphinrc.General.ShowStatusBar = "FullWidth";
      "dolphinrc"."IconsMode".PreviewSize = 80;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      dolphinrc.MainWindow.MenuBar = "Disabled";
      dolphinrc.PreviewSettings.Plugins = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mltpreview,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
      dolphinrc.Search.Location = "Everywhere";

      # kzones (kwin script)
      "kwinrc"."Plugins".kzonesEnabled = true;
      "kwinrc"."Script-kzones" = {
        autoSnapAllNew = false;
        rememberWindowGeometries = true;
        enableEdgeSnapping = false;
        enableZoneOverlay = true;
        enableZoneSelector = true;
        layoutsJson = builtins.toJSON [
          {
            name = "Halves";
            padding = 0;
            zones = [
              { x = 0; y = 0; width = 50; height = 100; }
              { x = 50; y = 0; width = 50; height = 100; }
            ];
          }
          {
            name = "1/3-2/3";
            padding = 0;
            zones = [
              { x = 0; y = 0; width = 33.33; height = 100; }
              { x = 33.33; y = 0; width = 66.67; height = 100; }
            ];
          }
          {
            name = "Equal Thirds";
            padding = 0;
            zones = [
              { x = 0; y = 0; width = 33.33; height = 100; }
              { x = 33.33; y = 0; width = 33.33; height = 100; }
              { x = 66.66; y = 0; width = 33.34; height = 100; }
            ];
          }
        ];
      };
    };
  };

}
