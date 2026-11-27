{
  config,
  pkgs,
  lib,
  inputs,
  osConfig ? { },
  ...
}:
{
  imports = [
    ./desktop.nix
    ./packages.nix
    ./nixvim.nix
    ./zed.nix
    ./librewolf.nix
    ./ghostty.nix
    ./zsh
    ./sable.nix
    ./qbittorrent.nix
    ./nixcord.nix
    ./nightcap.nix
    ./starship.nix
    ./fastfetch.nix
    ./kdeconnect.nix
    ./wallpapers.nix
  ];

  home.username = "visa";
  home.homeDirectory = "/home/visa";
  home.stateVersion = "26.11"; # match NixOS 26.11 (Zokor)

  programs.home-manager.enable = true;

  # shells, aliases, and helpers live in ./zsh

  # dev: neovim configured declaratively via nixvim (see nixvim.nix)
  # (vim kept in system packages; nixvim provides nvim as default editor)
  programs.git = {
    enable = true;
    # set identity locally (not committed here): git config --global user.name/user.email
    # or add a private module; keep tokens/credentials out of repo.
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
      KillSignal = "SIGINT";
      TimeoutStopSec = 15;
      KillMode = "mixed";
    };
  };

  # sunshine-screen (ddcutil dim/restore; config at ~/.config/sunshine-screen.conf)
  programs.sunshine-screen.enable = true;

  # Maidware Project tools
  programs.maid-bt.enable = true;
  programs.maidshare.enable = true;
  programs.maid-suite.enable = true;
  programs.maid-runner.enable = true;

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

  # syncthing (user service, secrets/device IDs configured outside repo)
  services.syncthing = {
    enable = true;
    # configure folders/devices via the Syncthing UI or a private local override; do not commit IDs/keys.
  };

  # apps (nixpkgs/native). Flatpak is enabled system-wide but no Flatpak apps declared here.
  # default applications (declarative)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # web browser
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/about" = [ "librewolf.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" ];

      # music player
      "audio/mpeg" = [ "org.fooyin.fooyin.desktop" ];
      "audio/mp4" = [ "org.fooyin.fooyin.desktop" ];
      "audio/flac" = [ "org.fooyin.fooyin.desktop" ];
      "audio/ogg" = [ "org.fooyin.fooyin.desktop" ];
      "audio/x-vorbis+ogg" = [ "org.fooyin.fooyin.desktop" ];
      "audio/x-opus+ogg" = [ "org.fooyin.fooyin.desktop" ];
      "audio/wav" = [ "org.fooyin.fooyin.desktop" ];
      "audio/x-wav" = [ "org.fooyin.fooyin.desktop" ];
      "audio/aac" = [ "org.fooyin.fooyin.desktop" ];
      "audio/x-ms-wma" = [ "org.fooyin.fooyin.desktop" ];
      "audio/x-matroska" = [ "org.fooyin.fooyin.desktop" ];

      # video player
      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "video/x-msvideo" = [ "mpv.desktop" ];
      "video/quicktime" = [ "mpv.desktop" ];
      "video/x-ms-wmv" = [ "mpv.desktop" ];
      "video/mpeg" = [ "mpv.desktop" ];
      "video/ogg" = [ "mpv.desktop" ];
      "video/mp2t" = [ "mpv.desktop" ];

      # pdf viewer
      "application/pdf" = [ "onlyoffice-desktopeditors.desktop" ];

      # archive manager
      "application/zip" = [ "peazip.desktop" ];
      "application/x-tar" = [ "peazip.desktop" ];
      "application/x-compressed-tar" = [ "peazip.desktop" ];
      "application/x-bzip-compressed-tar" = [ "peazip.desktop" ];
      "application/x-xz-compressed-tar" = [ "peazip.desktop" ];
      "application/x-zstd-compressed-tar" = [ "peazip.desktop" ];
      "application/gzip" = [ "peazip.desktop" ];
      "application/x-bzip2" = [ "peazip.desktop" ];
      "application/x-xz" = [ "peazip.desktop" ];
      "application/zstd" = [ "peazip.desktop" ];
      "application/x-7z-compressed" = [ "peazip.desktop" ];
      "application/vnd.rar" = [ "peazip.desktop" ];
      "application/x-rar" = [ "peazip.desktop" ];
      "application/x-archive" = [ "peazip.desktop" ];
      "application/x-cpio" = [ "peazip.desktop" ];
      "application/x-iso9660-image" = [ "peazip.desktop" ];
    };
  };

  # keep secrets out of repo; browser passwords/keys/cookies/sessions excluded by migration script
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "librewolf";
    NH_FLAKE = "$HOME/Projects/termina";
    # disable speech-dispatcher integration in electron wrappers (avoids crashes, thank you discord.)
    NIXOS_SPEECH = "False";
  };

  # ensure gui/systemd-user-launched apps also get the variable
  systemd.user.sessionVariables = {
    NIXOS_SPEECH = "False";
  };

  # GoofCord managed declaratively (home/visa/goofcord.nix)

}

