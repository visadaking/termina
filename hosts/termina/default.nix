{ lib, inputs, ... }:
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

  # termina-specific hardware/peripherals (kept out of shared modules for reuse)
  boot.blacklistedKernelModules = [ "sp5100_tco" ];

  # Wake-on-LAN for eno1 (MAC bc:fc:e7:b2:cf:4c). BIOS/UEFI must also allow WoL,
  # and the machine must be in a WoL-capable sleep/power state.
  networking.interfaces.eno1.wakeOnLan.enable = true;

  # USB Bluetooth/optical/webcam devices on this host
  boot.kernelModules = [
    "btusb"
    "sr_mod"
    "cdrom"
    "uvcvideo"
  ];

  # i2c/DDC access (for ddcutil / sunshine-screen)
  hardware.i2c.enable = true;

  # udev rules: Bluetooth USB adapter autosuspend + Logitech G515 TKL access/power
  services.udev.extraRules = lib.mkAfter ''
    # Disable autosuspend for Bluetooth USB adapters only (Wireless Controller, bDeviceClass 0xe0).
    SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{bDeviceProtocol}=="01", TEST=="power/control", ATTR{power/control}="on"

    # Logitech G515 TKL (046d:c358): user access + disable USB autosuspend
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c358", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c358", TAG+="uaccess", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c358", TEST=="power/control", ATTR{power/control}="on"
  '';

  system.stateVersion = "26.05"; # NixOS 26.11 (Zokor)
}
