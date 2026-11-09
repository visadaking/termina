{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/nix-ld.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/desktop-kde.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  networking.hostName = "termina";
  # multi-host/reusable: add hosts/<name>/ and wire in flake.nix

  system.stateVersion = "26.05"; # NixOS 26.11 (Zokor)
}
