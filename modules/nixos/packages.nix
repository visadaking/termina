{ pkgs, ... }:
{
  # core utils
  environment.systemPackages = with pkgs; [
    # core
    gcc
    gnumake
    binutils
    pkg-config
    psmisc
    xdg-utils
    procps
    wget
    curl
    git
    python3
    ffmpeg-full
    ffmpegthumbnailer
    zip
    unzip
    ripgrep
    fd
    nil
    playerctl
    jq
    nodejs
    libnotify

    # system/tools
    vim
    neovim
    nano
    pciutils
    usbutils
    fastfetch
    ethtool
    alsa-utils
    pulseaudio # provides pactl/pacmd for PipeWire pulse compat
    imagemagick
    lm_sensors
    openssl
    openssh
    ddrescue
    qdiskinfo
    qdirstat
    smartmontools
    ntfs3g
    exfatprogs # NTFS/exFAT support
    netbird

    # media / streaming (service/app)
    sunshine
  ];

  # filesystems
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];
}
