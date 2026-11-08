{ pkgs, ... }:
{
  # gaming (optional/labeled). /games is mounted in hardware.nix and NEVER touched.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    protonplus
    heroic
    mangohud
    gamescope
  ];
}
