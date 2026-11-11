{ config, pkgs, lib, ... }:
let
  # Simp1e (capitaine successor) cursors, Tokyo Night Storm scheme - matches the GTK theme/accent
  simp1e-tokyo-night-storm = pkgs.callPackage ../../pkgs/simp1e-tokyo-night-storm.nix { };
in
{
  # GTK theme (Tokyo Night)
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
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Simp1e-Tokyo-Night-Storm";
      package = simp1e-tokyo-night-storm;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };


  # Monitor: G25F2 (DP-1) - VRR disabled (Never), as set in KDE Plasma
  xdg.configFile."kwinoutputconfig.json".source = ./kwinoutputconfig-g25f2.json;

  # KDE Plasma via plasma-manager: keybinds + theme basics only (start small).
  # declarative can conflict with GUI changes - keep scope minimal.
  # keybinds imported from current kglobalshortcutsrc (verify after first login).
  # wallpaper deployed via home.file below (Ergo Proxy; file added from /home/visa/trash/wallpapers/).
  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png";
      cursor = {
        theme = "Simp1e-Tokyo-Night-Storm";
        size = 24;
      };
      # Tokyo Night - GTK theme handled via programs.gtk above
      # lookAndFeel = "org.kde.breezedark.desktop"; # third-party; install/set if available
      # colorScheme = "TokyoNightStorm";             # set if a Plasma color scheme is installed
      # theme = "default";
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
        "mic_mute" = [ "Microphone Mute" "Meta+Volume Mute" ];
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
      # Tokyo Night / old dotfiles accent (teal #5cb9ae)
      kdeglobals.General.AccentColor = "92,185,174";
      # Spectacle: stupid fucking pop up
      spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
      spectaclerc.GuiConfig.quitAfterSaveCopyExport = true;
    };
  };

}
