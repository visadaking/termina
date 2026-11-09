{ pkgs, ... }:
{
  # gaming (optional/labeled). /games is mounted in hardware.nix and NEVER touched.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };
  programs.gamemode.enable = true;

  # libratbag daemon for gaming mouse configuration (Piper GUI optional/not installed)
  services.ratbagd.enable = true;

  # kernel support
  boot.kernelModules = [ "ntsync" ];

  # xbox controller support (xone). PlayStation controllers (DualSense/DualShock)
  # work via the kernel hid-playstation driver/SDL/Steam Input over USB/Bluetooth.
  hardware.xone.enable = true;

  environment.systemPackages = with pkgs; [
    protonplus
    heroic
    mangohud
    gamescope
    # Wine staging (64-bit + 32-bit/WoW64) from unstable. 32-bit graphics enabled in common.nix.
    unstable.wineWow64Packages.staging
    winetricks
    # common gaming/audio libs
    openal
    SDL2
    alsa-lib
    libpulseaudio
  ];
}
