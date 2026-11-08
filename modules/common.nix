{ pkgs, inputs, ... }:
{
  # nix settings/gc/cachix/autoUpgrade -> modules/nix.nix

  # nixpkgs 26.11 base + unstable available as pkgs.unstable.<name>
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  # boot (UEFI, systemd-boot) - no dualboot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  # networking
  networking.networkmanager.enable = true;

  # audio (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # no printer
  services.printing.enable = false;

  # AMD graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # zram swap (like current)
  zramSwap.enable = true;

  # flatpak enabled (but prefer nixpkgs apps - no flatpak installs by default)
  services.flatpak.enable = true;

  # user
  users.users.visa = {
    isNormalUser = true;
    description = "visa";
    extraGroups = [ "wheel" "networkmanager" "input" "video" "audio" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # allow unfree where needed (Steam etc.) - labeled in intent
  nixpkgs.config.allowUnfree = true;

  # firmware
  hardware.enableRedistributableFirmware = true;

  # no openSUSE hacks/repos/workarounds carried over
}
