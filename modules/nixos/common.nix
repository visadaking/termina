{
  lib,
  pkgs,
  inputs,
  ...
}:
{

  # nixpkgs unstable
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  # UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  systemd.settings.Manager.DefaultTimeoutStopSec = "20s";
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "20s";

  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us,il";
    variant = ",";
    options = "grp:alt_shift_toggle";
  };

  # networking
  networking.networkmanager.enable = true;

  # pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-hifi-audio" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
    # bluetooth A2DP
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
        ];
      };
    };
  };
  security.rtkit.enable = true;

  # bluetooth for TP-LINK UB600 / RTL8761BU
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "dual";
      FastConnectable = false;
      Privacy = "device";
    };
    Policy = {
      AutoEnable = true;
      ReconnectAttempts = 7;
      ReconnectIntervals = "1,2,4,8,16,32,64";
    };
  };
  # appimage support (that doesn't work)
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # i don't have a printer
  services.printing.enable = false;

  # AMD
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # nix flatpak ( i hate it)
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.desktop_plus.desktop-plus"
    "org.vinegarhq.Sober"
    "com.nuclearplayer.Nuclear"
  ];
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };

  users.users.visa = {
    isNormalUser = true;
    description = "visa";
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
      "audio"
      "i2c"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # unfree software
  nixpkgs.config.allowUnfree = true;

  # firmware updates (do not turn this off)
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # fwupd/LVFS firmware updates
  services.fwupd.enable = true;

  # localsend
  programs.localsend.enable = true;

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    dejavu_fonts
    liberation_ttf
    corefonts
    font-awesome
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    maple-mono.NF
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [
        "Noto Serif"
        "DejaVu Serif"
      ];
      sansSerif = [
        "Noto Sans"
        "DejaVu Sans"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "FiraCode Nerd Font"
        "DejaVu Sans Mono"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

}
