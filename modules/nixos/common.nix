{ lib, pkgs, inputs, ... }:
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

  # boot (UEFI, systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # AMD SP5100 TCO watchdog: not used here and can spam "watchdog did not stop!" on shutdown.
  boot.blacklistedKernelModules = [ "sp5100_tco" ];

  # Avoid long shutdown hangs when a service/app misbehaves (e.g. plasmashell timeout).
  systemd.settings.Manager.DefaultTimeoutStopSec = "20s";
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "20s";

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

  # Wake-on-LAN for eno1 (MAC bc:fc:e7:b2:cf:4c). BIOS/UEFI must also allow WoL,
  # and the machine must be in a WoL-capable sleep/power state.
  networking.interfaces.eno1.wakeOnLan.enable = true;

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
    # Bluetooth codec support (earbuds/headsets) - SBC-XQ, mSBC (HFP wideband), HW volume
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" ];
      };
    };
  };
  security.rtkit.enable = true;

  # bluetooth (incl. USB adapters e.g. TP-Link UB600 / RTL8761BU)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
      AutoEnable = true;
      ControllerMode = "dual";
      FastConnectable = false;
      Privacy = "device";
      ResumeDelay = 2;
    };
    Policy = {
      AutoEnable = true;
      ReconnectAttempts = 7;
      ReconnectIntervals = "1,2,4,8,16,32,64";
    };
  };
  services.blueman.enable = true;
  boot.kernelModules = [ "btusb" "sr_mod" "cdrom" "uvcvideo" ]; # btusb for USB BT; sr_mod/cdrom for USB optical; uvcvideo for USB webcams

  # i2c/DDC access (for ddcutil / sunshine-screen)
  hardware.i2c.enable = true;

  # AppImage support (binfmt registration so .AppImage files run directly)
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # gpu-screen-recorder-ui global hotkeys helper needs elevated privileges on Wayland
  security.wrappers.gsr-global-hotkeys = {
    owner = "root";
    group = "root";
    setuid = true;
    source = "${pkgs.gpu-screen-recorder-ui}/bin/gsr-global-hotkeys";
  };

  # udev rules: Bluetooth USB adapter autosuspend + Logitech G515 TKL access/power
  services.udev.extraRules = lib.mkAfter ''
    # Disable autosuspend for Bluetooth USB adapters only (Wireless Controller, bDeviceClass 0xe0).
    SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{bDeviceProtocol}=="01", TEST=="power/control", ATTR{power/control}="on"

    # Logitech G515 TKL (046d:c358): user access + disable USB autosuspend
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c358", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c358", TAG+="uaccess", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c358", TEST=="power/control", ATTR{power/control}="on"
  '';

  # no printer
  services.printing.enable = false;

  # AMD graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # zram swap (like current)
  zramSwap.enable = true;

  # flatpak enabled (prefer nixpkgs apps); declaratively manage current system flatpaks via nix-flatpak
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "app.fluxer.Fluxer"
    "org.desktop_plus.desktop-plus"
    "org.vinegarhq.Sober"
    "com.nuclearplayer.Nuclear"
  ];
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };

  # user
  users.users.visa = {
    isNormalUser = true;
    description = "visa";
    extraGroups = [ "wheel" "networkmanager" "input" "video" "audio" "i2c" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # allow unfree where needed (Steam etc.) - labeled in intent
  nixpkgs.config.allowUnfree = true;

  # firmware (enableAllFirmware helps devices like TP-Link UB600/RTL8761BU; unfree already allowed)
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # fwupd/LVFS firmware updates
  services.fwupd.enable = true;

  # LocalSend (opens firewall port 53317)
  programs.localsend.enable = true;

}
