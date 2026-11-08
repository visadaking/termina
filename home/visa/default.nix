{ config, pkgs, lib, inputs, ... }:
{
  home.username = "visa";
  home.homeDirectory = "/home/visa";
  home.stateVersion = "24.11"; # match your NixOS release

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
  programs.plasma = {
    enable = true;
    workspace = {
      # Tokyo Night (adjust package names/scheme if your nixpkgs revision differs)
      # common: colorScheme "TokyoNight", cursor.theme "Bibata-Modern-Ice" or a Tokyo Night cursor if packaged;
      # verify available schemes/themes on your system and tweak here.
      clickItemTo = "select";
      # lookAndFeel = "org.kde.breezedark.desktop"; # set to your Tokyo Night look-and-feel if installed
      # cursor.theme = "breeze_cursors"; # replace with your Tokyo Night cursor theme name
      # colorScheme = "BreezeDark";      # replace with Tokyo Night color scheme name
      # theme = "default";                # plasma theme if used
    };
    # keybinds: add specific shortcuts here once you export/decide them (kept minimal to avoid conflicts)
    shortcuts = { };
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
