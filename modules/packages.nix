{ pkgs, ... }:
{
  # core utilities + dev/productivity/media baseline (organized here)
  environment.systemPackages = with pkgs; [
    # core
    gcc gnumake binutils pkg-config psmisc xdg-utils procps wget curl git
    python3 ffmpeg-full zip unzip ripgrep fd nil playerctl jq nodejs libnotify

    # system/tools
    vim neovim pciutils usbutils btop fastfetch
    ntfs3g exfatprogs # NTFS/exFAT support

    # productivity/dev
    vscodium keepassxc gh lazygit opencode  # verify attr on 26.11/unstable (pkgs.unstable.opencode if needed)

    # media
    vlc mpv obs-studio nuclear
  ];

  # filesystems
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
}
