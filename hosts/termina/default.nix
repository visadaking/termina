{ config, lib, pkgs, inputs, ... }:
{
  # Host-specific config for "termina" (hardware quirks, peripherals, host toggles).
  # Shared/reusable defaults live in modules/nixos/*.
  imports = [
    ./hardware.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/nix-ld.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/secrets.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/desktop-kde.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  networking.hostName = "termina";
  # future laptop configuration here

  # termina hardware stuff
  termina.vm.enable = false;
  boot.blacklistedKernelModules =
    [ "sp5100_tco" ]
    ++ lib.optionals (!config.termina.vm.enable) [ "kvm" "kvm_amd" ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "vm-on" ''
      set -euo pipefail
      file="/home/visa/Projects/termina/hosts/termina/default.nix"
      if grep -Eq '^[[:space:]]*termina\.vm\.enable = true;' "$file"; then
        echo "VM/KVM already enabled in config. Rebuilding to ensure state..."
      else
        sed -i -E 's/^([[:space:]]*)termina\.vm\.enable = false;/\1termina.vm.enable = true;/' "$file"
        echo "Enabled termina.vm.enable in $file"
      fi
      sudo nixos-rebuild switch --flake /home/visa/Projects/termina#termina
      echo "VM/KVM enabled. You may need to log out/in for group access and reboot if KVM modules were previously blacklisted/unloaded."
    '')
    (pkgs.writeShellScriptBin "vm-off" ''
      set -euo pipefail
      file="/home/visa/Projects/termina/hosts/termina/default.nix"
      if grep -Eq '^[[:space:]]*termina\.vm\.enable = false;' "$file"; then
        echo "VM/KVM already disabled in config. Rebuilding to ensure state..."
      else
        sed -i -E 's/^([[:space:]]*)termina\.vm\.enable = true;/\1termina.vm.enable = false;/' "$file"
        echo "Disabled termina.vm.enable in $file"
      fi
      sudo nixos-rebuild switch --flake /home/visa/Projects/termina#termina
      echo "VM/KVM disabled. Reboot recommended to ensure KVM modules are not loaded."
    '')
    (pkgs.writeShellScriptBin "vm-status" ''
      set -euo pipefail
      file="/home/visa/Projects/termina/hosts/termina/default.nix"
      if grep -Eq '^[[:space:]]*termina\.vm\.enable = true;' "$file"; then
        echo "config: enabled"
      elif grep -Eq '^[[:space:]]*termina\.vm\.enable = false;' "$file"; then
        echo "config: disabled"
      else
        echo "config: unknown"
      fi
      echo "kvm modules loaded:"
      lsmod | grep '^kvm' || echo "  (none)"
      echo "groups:"
      id -nG "$USER" | tr ' ' '\n' | grep -E '^(libvirtd|kvm)$' || echo "  (not in libvirtd/kvm)"
    '')
  ];

  # wake on lan
  # sleep for wol
  networking.interfaces.eno1.wakeOnLan.enable = true;

  # for cameera and cd drive
  boot.kernelModules = [
    "btusb"
    "sr_mod"
    "cdrom"
    "uvcvideo"
  ];

  # i2c/DDC access (for ddcutil / sunshine-screen)
  hardware.i2c.enable = true;

  # udev rules for bluetooth
  services.udev.extraRules = lib.mkAfter ''
    # disable autosuspend for bluetooth
    SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{bDeviceProtocol}=="01", TEST=="power/control", ATTR{power/control}="on"
  '';

  # smart health
  services.smartd.enable = true;

  # mDNS / local network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  system.stateVersion = "26.11";
}
