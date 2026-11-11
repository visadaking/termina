{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;

  # Add vm-curator, a terminal-based VM manager, instead of virt-manager
  environment.systemPackages = with pkgs; [
    vm-curator
  ];

  users.users.visa.extraGroups = [ "libvirtd" "kvm" ];

  # keep default networks (libvirt manages them); no changes to /games
}
