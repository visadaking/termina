{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop-kde.nix
    ../../modules/gaming.nix
    ../../modules/virtualisation.nix
  ];

  networking.hostName = "termina";
  # multi-host/reusable: add hosts/<name>/ and wire in flake.nix

  system.stateVersion = "24.11"; # set to the NixOS release you install; adjust if needed
}
