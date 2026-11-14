{ pkgs, ... }:
{
  # core utilities + dev/productivity/media baseline (organized here)
  environment.systemPackages = with pkgs; [
    # core
    gcc gnumake binutils pkg-config psmisc xdg-utils procps wget curl git
    python3 ffmpeg-full zip unzip ripgrep fd nil playerctl jq nodejs libnotify

    # system/tools
    vim neovim nano pciutils usbutils btop fastfetch ethtool
    alsa-utils imagemagick lm_sensors openssl openssh
    ddrescue
    qdiskinfo qdirstat
    ntfs3g exfatprogs # NTFS/exFAT support

    # productivity/dev
    vscodium keepassxc gh lazygit opencode

    # media / streaming / sharing
    vlc mpv
    qbittorrent
    sunshine
  ];

  # filesystems
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
}
