{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;

  # add vm-curator, instead of virt-manager
  environment.systemPackages = with pkgs; [
    vm-curator
  ];

  users.users.visa.extraGroups = [ "libvirtd" "kvm" ];

  # keep default networks (libvirt manages them); no changes to /games
}
