{ config, pkgs, lib, inputs, ... }:
{
  home.username = "visa";
  home.homeDirectory = "/home/visa";
  home.stateVersion = "26.11"; # match NixOS 26.11 (Zokor)

  programs.home-manager.enable = true;

  # shells + termina aliases (repo lives at ~/termina)
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    initContent = ''
      # KDE Connect helpers (kdeconnect-cli)
      kc-devices() { kdeconnect-cli --list-devices "$@"; }
      kc-ping() {
        local dev="''${1:?usage: kc-ping <device-name-or-id> [message]}"
        local msg="''${2:-ping from $(hostname)}"
        kdeconnect-cli -n "$dev" --ping-msg "$msg"
      }
    '';
    shellAliases = {
      t-edit = "nvim $HOME/termina";
      t-check = "nix flake check $HOME/termina";
      t-dry = "sudo nixos-rebuild dry-build --flake $HOME/termina#termina";
      t-switch = "sudo nixos-rebuild switch --flake $HOME/termina#termina --refresh";
      t-clean = "sudo nix-collect-garbage --delete-older-than 30d";
      t-update = "nix flake update --flake $HOME/termina";
      t-status = "git -C $HOME/termina status";
      t-log = "git -C $HOME/termina log --oneline --decorate -10";
      t-push = "git -C $HOME/termina push";
      t-pull = "git -C $HOME/termina pull --ff-only";
      # usage: t-commit "message"  (stages tracked changes in termina repo)
      t-commit = "f(){ git -C $HOME/termina add -A && git -C $HOME/termina commit -m \"\${1:?usage: t-commit \\\"message\\\"}\"; }; f";
      # strict DNS kept; temporary captive-portal workaround (runtime-only, no rebuild/degrade). usage: t-dns-relax wlan0
      t-dns-relax = "f(){ i=\${1:?usage: t-dns-relax <iface> (nmcli device status)}; sudo resolvectl dns \"$i\" '' && sudo resolvectl dnsovertls \"$i\" no && sudo resolvectl dnssec \"$i\" no && echo relaxed: $i; }; f";
      t-dns-revert = "f(){ i=\${1:?usage: t-dns-revert <iface>}; sudo resolvectl revert \"$i\" && echo reverted: $i; }; f";
      fixaudio = "systemctl --user restart wireplumber pipewire pipewire-pulse";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = config.programs.zsh.shellAliases;
  };

  # dev: vim + LazyVim (neovim + LazyVim starter handled by user config; we provide tools)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.git = {
    enable = true;
    # set identity locally (not committed here): git config --global user.name/user.email
    # or add a private module; keep tokens/credentials out of repo.
  };
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Sunshine user service (start/stop/restart via KDE Connect commands; no auto-start)
  systemd.user.services.sunshine = {
    Unit = {
      Description = "Sunshine game streaming host";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # sunshine-screen (ddcutil dim/restore; config at ~/.config/sunshine-screen.conf)
  programs.sunshine-screen.enable = true;

  # Maidware Project tools
  programs.maid-bt.enable = true;
  programs.maidshare.enable = true;
  programs.maid-suite.enable = true;
  programs.maid-runner.enable = true;

  # KDE Connect run commands (device-specific: 5356cbe09e0a454cbcf086511c34833e)
  # Adds reboot/poweroff (systemctl, polkit/session-dependent), Sunshine controls, sunshine-screen dim/restore.
  xdg.configFile."kdeconnect/5356cbe09e0a454cbcf086511c34833e/kdeconnect_runcommand/config".text = ''
    [General]
    commands=@ByteArray({"8a05428f_5569_471f_8e19_0f3f18f7743c":{"command":"loginctl lock-session","name":"Lock Screen"},"c0c0d80a_8139_4c3d_8834_6efb34cfa197":{"command":"loginctl unlock-session","name":"Unlock Screen"},"d6c72055_a741_4584_8207_1a8933b95986":{"command":"systemctl reboot","name":"Reboot"},"032d737c_5b31_470a_a024_49d00a50162b":{"command":"systemctl poweroff","name":"Power Off"},"a8d40325_b018_49ca_a0c3_a7c7cedf0dbd":{"command":"systemctl --user start sunshine","name":"Sunshine Start"},"643440b3_4fc8_4fd6_84d9_804a6b30503d":{"command":"systemctl --user restart sunshine","name":"Sunshine Restart"},"6ac9a6ba_878a_4e38_8acd_0cfa67c76cf0":{"command":"systemctl --user stop sunshine","name":"Sunshine Stop"},"b1f0d2a4_3c6e_4f8a_9b1d_2e4f6a8c0d1e":{"command":"sunshine-screen off","name":"Sunshine Screen Dim"},"e2a1b3c4_5d6f_4789_8a0b_1c2d3e4f5a6b":{"command":"sunshine-screen on","name":"Sunshine Screen Restore"}})
  '';

  # OBS Studio (wrapped with plugins)
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      obs-multi-rtmp
      obs-vkcapture
      obs-vaapi
      obs-pipewire-audio-capture
      obs-source-record
      obs-vertical-canvas
      obs-teleport
      obs-shaderfilter
      obs-composite-blur
    ];
  };

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
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # syncthing (user service, secrets/device IDs configured outside repo)
  services.syncthing = {
    enable = true;
    # configure folders/devices via the Syncthing UI or a private local override; do not commit IDs/keys.
  };


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
        theme = "Bibata-Modern-Classic";
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

  # apps (nixpkgs/native). Flatpak is enabled system-wide but no Flatpak apps declared here.
  # verify attr names on nixpkgs 26.11 / unstable: nix search nixpkgs <name> (use pkgs.unstable.<pkg> if needed)
  home.packages = with pkgs; [
    # themes
    tokyonight-gtk-theme
    bibata-cursors
    kdePackages.breeze-icons
    papirus-icon-theme

    # browsers
    firefox
    vivaldi
    # chromium # you have chromium RPM; add if wanted (or pkgs.unstable.chromium)

    # comms (from your flatpaks/RPMs - add what you use; some are unfree)
    vesktop
    element-desktop
    signal-desktop
    telegram-desktop
    mumble
    zapzap                # WhatsApp client (verify attr: zapzap / pkgs.unstable.zapzap)
    zoom-us               # unfree
    simplex-chat-desktop  # verify attr name on 26.11/unstable (simplex-chat-desktop or simplex-chat)
    halloy                # IRC client

    # media
    vlc
    mpv
    nuclear
    spotify        # unfree
    fooyin
    krita
    audacity_3
    handbrake
    reaper                # DAW (unfree)
    eartag                # audio file tag editor
    kdePackages.kdenlive
    jellyfin-media-player  # org.jellyfin.JellyfinDesktop
    nicotine-plus

    # files/sync/productivity
    keepassxc
    localsend
    obsidian              # unfree/electron caveats
    onlyoffice-desktopeditors
    ente-auth             # verify attr (ente-auth / pkgs.unstable.ente-auth)
    peazip                # verify attr
    freac                 # audio converter (org.freac.freac)

    # dev/tools
    vim
    lazygit
    podman
    distrobox
    gh
    vscodium
    filezilla
    home-manager
    android-tools         # adb, fastboot, etc.
    android-cli
    nh                    # Nix helper
    discordchatexporter-desktop
    # github-desktop      # replaced by GH Desktop Plus (Flatpak: org.desktop_plus.desktop-plus)
    # anydesk               # unfree/proprietary; verify attr (anydesk) if you need it - can break on some channels

    # terminal/tools + configs to migrate
    ghostty
    fastfetch
    hyfetch
    cowsay
    wakeonlan             # send magic packets to wake other machines (wol)
    # gearlever           # temporarily disabled: fails to build due to dwarfs-0.15.8 tests in current nixpkgs (upstream issue)

    # gaming/helpers (Steam enabled system-wide); /games data untouched
    prismlauncher
    itch             # verify attr on search.nixos.org (26.11/unstable)
    moonlight-qt     # Moonlight client (pairs with Sunshine host; ports opened in modules/security.nix)
    bottles          # verify attr/unfree
    mangohud
    # Lutris skipped (Heroic only). Sober/Roblox - no reliable main nixpkgs package; use flatpak/appimage if needed.

    # VPN (Proton VPN) - verify attr on search.nixos.org (26.11/unstable); common attrs: protonvpn-gui, proton-vpn-gtk-app, proton-vpn-cli
    proton-vpn

    # native replacements/helpers for former AppImages/niche (verify attrs on 26.11/unstable)
    musicpresence    # Discord/music rich presence (was music_presence.appimage)
    redact           # image/pdf redaction
    cameractrls      # verify attr
    xclicker         # verify attr
    # upscaler? peazip/freac/niche - verify attrs; Goose/Azahar/Sober/Reaper handled case-by-case (see docs)
    # AppImages (you still have: lichii in ~/Downloads; keep as file + appimage-run)
    appimage-run

    # fonts/themes helpers (add your Tokyo Night/cursor/font packages here as needed)
    # tokyonight-gtk-theme
    # (cursor/font packages vary; search: nix search nixpkgs tokyo night)
  ];

  # wallpaper (Ergo Proxy) - managed file
  home.file."Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png".source =
    ../../assets/wallpapers/ergo-proxy-kw9yj7-1920x1080.png;

  # keep secrets out of repo; browser passwords/keys/cookies/sessions excluded by migration script
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
