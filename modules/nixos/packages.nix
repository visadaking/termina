{ pkgs, ... }:
{
  # core utilities + dev/productivity/media baseline (organized here)
  environment.systemPackages = with pkgs; [
    # core
    gcc gnumake binutils pkg-config psmisc xdg-utils procps wget curl git
    python3 ffmpeg-full zip unzip ripgrep fd nil playerctl jq nodejs libnotify

    # system/tools
    vim neovim nano pciutils usbutils btop fastfetch ethtool
    alsa-utils imagemagick lm_sensors
    ddrescue
    qdiskinfo qdirstat
    ntfs3g exfatprogs # NTFS/exFAT support

    # productivity/dev
    vscodium keepassxc gh lazygit opencode  # verify attr on 26.11/unstable (pkgs.unstable.opencode if needed)

    # media / streaming / sharing
    vlc mpv nuclear
    qbittorrent
    sunshine    # host (Moonlight client is moonlight-qt in home/visa; verify sunshine attr on 26.11/unstable)
    gpu-screen-recorder
    gpu-screen-recorder-ui
  ];

  # filesystems
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
}
