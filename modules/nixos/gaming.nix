{ pkgs, ... }:

let
  # native OpenAL Soft (Windows DLLs) for wine prefixes; see pkgs/openal-win.nix
  openal-win = pkgs.callPackage ../../pkgs/openal-win.nix { };
in
{
  # gaming (optional/labeled). /games is mounted in hardware.nix and NEVER touched.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    # declarative compatibility tools (Steam still manages its own Valve Proton builds).
    # ProtonPlus remains installed for on-demand installs/updates (e.g. Proton-CachyOS).
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true;

  # mesa shader cache size (not VRAM-reserved)
  environment.sessionVariables = {
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  # small gaming tweak:
  # vm.max_map_count: some Proton/Wine/Unreal/Unity/modded games need more memory mappings
  # than the default (65530) and can crash or misbehave when they hit the limit. Raising it
  # improves compatibility for affected games (not a general fps boost). It's a limit, not
  # preallocated RAM. 1048576 is a conservative choice (often cited on Fedora); some setups
  # use a higher ceiling (e.g. SteamOS uses a much larger value).
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
  };

  # Ignore DualSense/DualShock 4 touchpad as a libinput pointer device (usb + bluetooth)
  # so it doesn't act as a mouse / cause phantom cursor movement on the desktop.
  # Controller/gamepad input for games (via hid-playstation/SDL/Steam Input) is unaffected.
  services.udev.extraRules = ''
    # usb
    ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    # bluetooth
    ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # libratbag daemon for gaming mouse configuration (Piper GUI optional/not installed)
  services.ratbagd.enable = true;

  # kernel support
  boot.kernelModules = [ "ntsync" ];

  # xbox controller support (xone). PlayStation controllers (DualSense/DualShock)
  # work via the kernel hid-playstation driver/SDL/Steam Input over USB/Bluetooth.
  hardware.xone.enable = true;

  environment.systemPackages = with pkgs; [
    protonplus
    heroic
    mangohud
    gamescope
    # Wine staging (64-bit + 32-bit/WoW64) from unstable. 32-bit graphics enabled in common.nix.
    # OpenGL: built in (winePackagesFor base passes openglSupport; opengl32.dll ships in the
    #   prefix for both arches; system mesa drivers via hardware.graphics 64+32bit).
    # OpenAL: wine has no builtin openal32.dll (removed upstream) - run `wine-openal`
    #   per prefix to install native OpenAL Soft (pkgs/openal-win.nix).
    unstable.wineWow64Packages.staging
    winetricks
    openal-win
    # common gaming/audio libs
    openal
    SDL2
    alsa-lib
    libpulseaudio
  ];
}
