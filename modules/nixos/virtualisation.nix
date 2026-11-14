{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # TPM support (e.g. Windows 11 VMs)
      swtpm.enable = true;
      # Shared folders (virtiofs)
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # GUI for easier VM management (keeps vm-curator as a terminal option)
  programs.virt-manager.enable = true;

  # USB passthrough support for SPICE/libvirt VMs
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    vm-curator
    virt-viewer
    spice-gtk
    docker-compose
  ];

  users.users.visa.extraGroups = [
    "libvirtd"
    "kvm"
    "docker"
  ];

  # keep default networks (libvirt manages them); no changes to /games
}
