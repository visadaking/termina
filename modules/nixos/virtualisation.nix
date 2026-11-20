{ lib, pkgs, ... }:
{
  # VM/KVM stack disabled to reduce KVM attack surface (re-enable when needed)
  virtualisation.libvirtd.enable = false;

  # docker
  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];
  systemd.sockets.docker.wantedBy = lib.mkForce [ ];

  # gui for vm
  programs.virt-manager.enable = false;

  # usb passthrough for vms
  virtualisation.spiceUSBRedirection.enable = false;

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
