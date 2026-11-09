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
  # system in English; keyboard supports English (US) + Hebrew
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us,il";
    variant = ",";
    options = "grp:alt_shift_toggle";
  };

  # networking
  networking.networkmanager.enable = true;

  # audio (PipeWire) - high-quality defaults (Fiio K11 USB DAC etc.)
  # adjust allowed-rates/quantum if a device misbehaves; check with: pw-metadata -n settings 0
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-hifi-audio" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
  };
  security.rtkit.enable = true;

  # bluetooth (incl. USB adapters e.g. TP-Link UB600 / RTL8761BU)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  boot.kernelModules = [ "btusb" "sr_mod" "cdrom" ]; # btusb for USB BT; sr_mod/cdrom for USB optical (e.g. ASUS ZenDrive U8M SDRW-08U8M-U)

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

  # firmware (enableAllFirmware helps devices like TP-Link UB600/RTL8761BU; unfree already allowed)
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # no openSUSE hacks/repos/workarounds carried over
}
