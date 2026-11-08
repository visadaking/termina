{ config, pkgs, lib, inputs, ... }:
{
  home.username = "visa";
  home.homeDirectory = "/home/visa";
  home.stateVersion = "26.11"; # match NixOS 26.11 (Zokor)

  programs.home-manager.enable = true;

  # shells
  programs.zsh.enable = true;
  programs.bash.enable = true;

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
  home.packages = with pkgs; [
    # browsers
    firefox
    vivaldi

    # comms
    vesktop
    element-desktop
    # simplex-chat-desktop may be named simplex-desktop/simplexchat depending on nixpkgs; adjust if needed:
    # simplex-chat-desktop

    # media
    obs-studio
    vlc
    mpv

    # dev/tools
    vim
    lazygit
    podman
    distrobox
    gh
    vscodium
    keepassxc

    # terminal/tools + configs to migrate
    ghostty
    fastfetch
    kitty

    # gaming helpers (Steam enabled system-wide); /games data untouched
    # (protonplus/heroic/mangohud/gamescope installed system-wide in modules/gaming.nix)

    # fonts/themes helpers (add your Tokyo Night/cursor/font packages here as needed)
    # tokyonight-gtk-theme
    # (cursor/font packages vary; search: nix search nixpkgs tokyo night)
  ];

  # keep secrets out of repo; browser passwords/keys/cookies/sessions excluded by migration script
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
