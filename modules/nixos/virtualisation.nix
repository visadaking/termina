{ config, lib, pkgs, ... }:
let
  cfg = config.termina.vm;
in
{
  options.termina.vm.enable = lib.mkEnableOption "VM/KVM stack (libvirt, virt-manager, KVM access)";

  config = lib.mkMerge [
    {
      # docker
      virtualisation.docker.enable = true;
      systemd.services.docker.wantedBy = lib.mkForce [ ];
      systemd.sockets.docker.wantedBy = lib.mkForce [ ];

      environment.systemPackages = with pkgs; [
        docker-compose
      ];
    }

    (lib.mkIf cfg.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          # TPM support for vms (winslop 10,11)
          swtpm.enable = true;
          # shared folders
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      programs.virt-manager.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

      environment.systemPackages = with pkgs; [
        vm-curator
        virt-viewer
        spice-gtk
      ];

      users.users.visa.extraGroups = [
        "libvirtd"
        "kvm"
      ];
    })

    (lib.mkIf (!cfg.enable) {
      virtualisation.libvirtd.enable = false;
      programs.virt-manager.enable = false;
      virtualisation.spiceUSBRedirection.enable = false;
    })
  ];
}
