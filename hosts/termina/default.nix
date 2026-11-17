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
  # future laptop configuration here

  # termina hardware stuff
  boot.blacklistedKernelModules = [ "sp5100_tco" ];

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

  # udev rules for bluetooth and logitech g515 tkl
  services.udev.extraRules = lib.mkAfter ''
    # disable autosuspend for bluetooth
    SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{bDeviceProtocol}=="01", TEST=="power/control", ATTR{power/control}="on"

    # logitech g515 tkl
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c358", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c358", TAG+="uaccess", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c358", TEST=="power/control", ATTR{power/control}="on"
  '';

  system.stateVersion = "26.11";
}
