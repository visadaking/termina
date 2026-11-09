# hardware config for host "termina" (ASUS TUF GAMING B650-PLUS, AMD desktop)
# based on the current openSUSE layout (read-only inventory). VERIFY before install:
#   lsblk -f && nixos-generate-config --show-hardware-config
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # btrfs root with subvols (alike to current system), no LUKS
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@/home" "compress=zstd" "noatime" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@/var" "compress=zstd" "noatime" ];
  };

  fileSystems."/srv" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@/srv" "compress=zstd" "noatime" ];
  };

  fileSystems."/root" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@/root" "compress=zstd" "noatime" ];
  };

  fileSystems."/opt" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@/opt" "compress=zstd" "noatime" ];
  };

  fileSystems."/usr/local" = {
    device = "/dev/disk/by-uuid/59e473f0-70d5-4147-b0da-3862955bc2b3";
    fsType = "btrfs";
    options = [ "subvol=@/usr/local" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/D516-541B";
    fsType = "vfat";
    options = [ "fmask=0177" "dmask=0077" ];
  };

  # games disk - MOUNT ONLY, NEVER TOUCH CONTENTS (Steam/library preserved)
  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/e599e845-a396-4bbe-a7ab-a505d8fc0ea0";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  swapDevices = [ ]; # zram configured in modules/common.nix

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
