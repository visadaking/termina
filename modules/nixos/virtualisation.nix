{ lib, pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # TPM support for vms (winslop 10,11)
      swtpm.enable = true;
      # shared folders
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # docker
  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];
  systemd.sockets.docker.wantedBy = lib.mkForce [ ];

  # gui for vm
  programs.virt-manager.enable = true;

  # usb passthrough for vms
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
  ];

  # keep default networks for vms
}
