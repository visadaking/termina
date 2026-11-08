{ config, pkgs, lib, inputs, ... }:
{
  home.username = "visa";
  home.homeDirectory = "/home/visa";
  home.stateVersion = "26.11"; # match NixOS 26.11 (Zokor)

  programs.home-manager.enable = true;

  # shells + termina aliases (adjust path if you clone elsewhere)
  programs.zsh = {
    enable = true;
    shellAliases = {
      t-edit = "nvim $HOME/Documents/GitHub/termina";
      t-check = "nix flake check $HOME/Documents/GitHub/termina";
      t-dry = "sudo nixos-rebuild dry-build --flake $HOME/Documents/GitHub/termina#termina";
      t-switch = "sudo nixos-rebuild switch --flake $HOME/Documents/GitHub/termina#termina --refresh";
      t-clean = "sudo nix-collect-garbage --delete-older-than 30d";
      t-update = "nix flake update --flake $HOME/Documents/GitHub/termina";
      # strict DNS kept; temporary captive-portal workaround (runtime-only, no rebuild/degrade). usage: t-dns-relax wlan0
      t-dns-relax = "f(){ i=\${1:?usage: t-dns-relax <iface> (nmcli device status)}; sudo resolvectl dns \"$i\" '' && sudo resolvectl dnsovertls \"$i\" no && sudo resolvectl dnssec \"$i\" no && echo relaxed: $i; }; f";
      t-dns-revert = "f(){ i=\${1:?usage: t-dns-revert <iface>}; sudo resolvectl revert \"$i\" && echo reverted: $i; }; f";
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

  # syncthing (user service, secrets/device IDs configured outside repo)
  services.syncthing = {
    enable = true;
    # configure folders/devices via the Syncthing UI or a private local override; do not commit IDs/keys.
  };

  # Maidware tools (flakes, auto-update on rebuild with: nix flake update && nixos-rebuild/home-manager switch --refresh)
  imports = [
    inputs.maid-bt.homeManagerModules.default
    inputs.maid-runner.homeManagerModules.default
    inputs.maidshare.homeManagerModules.default
    inputs.maid-suite.homeManagerModules.default
  ];
  programs.maid-bt.enable = true;
  services.maid-bt.watcher.enable = true;
  services.maid-bt.maidWatcher.enable = true;
  # services.maid-bt.intentListener.enable = true; # only if you use phone intent (LAN) - configure token out of repo
  programs.maid-runner.enable = true;
  programs.maidshare.enable = true;
  programs.maid-suite.enable = true;

  # KDE Plasma via plasma-manager: keybinds + theme basics only (start small).
  # declarative can conflict with GUI changes - keep scope minimal.
  # keybinds imported from current kglobalshortcutsrc (verify after first login).
  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      # Tokyo Night - set to the exact installed names on your NixOS system:
      # lookAndFeel = "org.kde.breezedark.desktop";
      # cursor = { theme = "YOUR_TOKYO_NIGHT_CURSOR"; size = 24; };
      # colorScheme = "YOUR_TOKYO_NIGHT_SCHEME";
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
    configFile = { };
  };

  # apps (nixpkgs/native). Flatpak is enabled system-wide but no Flatpak apps declared here.
  # verify attr names on nixpkgs 26.11 / unstable: nix search nixpkgs <name> (use pkgs.unstable.<pkg> if needed)
  home.packages = with pkgs; [
    # browsers
    firefox
    vivaldi
    # chromium # you have chromium RPM; add if wanted (or pkgs.unstable.chromium)

    # comms (from your flatpaks/RPMs - add what you use; some are unfree)
    vesktop
    element-desktop
    signal-desktop
    telegram-desktop
    # mumble
    # zapzap                # WhatsApp client (check attr: zapzap)
    # zoom-us               # unfree
    # simplex-chat-desktop  # attr name varies (simplex-chat-desktop/simplexchat/simplex-chat); check nixpkgs
    # wasistlos / whatsapp-for-linux (alternatives)

    # media
    obs-studio
    vlc
    mpv
    nuclear
    spotify        # unfree
    fooyin
    # krita
    # audacity
    # jellyfin-media-player # org.jellyfin.JellyfinDesktop
    # nicotine-plus

    # files/sync/productivity
    keepassxc
    localsend
    # obsidian              # unfree/electron caveats
    # ente-auth             # verify attr (ente-auth)
    # peazip

    # dev/tools
    vim
    lazygit
    podman
    distrobox
    gh
    github-desktop
    vscodium
    filezilla
    # remmina
    # anydesk               # unfree/proprietary; availability varies

    # terminal/tools + configs to migrate
    ghostty
    fastfetch
    hyfetch
    kitty

    # gaming/helpers (Steam enabled system-wide); /games data untouched
    prismlauncher
    # moonlight-qt
    # bottles
    # (itch.io client is not natively packaged the same way; Sober/Roblox - check availability)

    # VPN (Proton VPN was a flatpak) - verify attr on 26.11/unstable
    # protonvpn-gui
    # protonvpn-cli

    # AppImages (you have: lichii, redact.appimage, music_presence.appimage in ~)
    appimage-run

    # fonts/themes helpers (add your Tokyo Night/cursor/font packages here as needed)
    # tokyonight-gtk-theme
    # (cursor/font packages vary; search: nix search nixpkgs tokyo night)
  ];

  # keep secrets out of repo; browser passwords/keys/cookies/sessions excluded by migration script
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
