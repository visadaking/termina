{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.visa.extraGroups = [ "libvirtd" "kvm" ];

  # keep default networks (libvirt manages them); no changes to /games
}
