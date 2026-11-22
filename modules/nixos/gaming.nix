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
    gamescopeSession.enable = false;
    # declarative compatibility
    # ProtonPlus remains installed for on-demand installs/updates (e.g. Proton-CachyOS).
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true;

  # allow gamemode's cpugovctl to change CPU governor without this stupid popup
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          subject.isInGroup("wheel")) {
        var prog = action.lookup("program");
        if (prog.indexOf("cpugovctl") > -1 || prog.indexOf("gamemode") > -1) {
          return polkit.Result.YES;
        }
      }
    });
  '';

  # mesa shader cache size (not VRAM-reserved)
  environment.sessionVariables = {
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  # increase vm.max_map_count for Proton/Wine/game compatibility
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
  };

  # no, i do not want my dualsense controller as a mousepad.
  services.udev.extraRules = ''
    # usb
    ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    # bluetooth
    ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # udev rules for Steam-supported controllers/VR devices (improved device access in Steam)
  hardware.steam-hardware.enable = true;

  # libratbag daemon for gaming mouse configuration (Piper GUI optional/not installed)
  services.ratbagd.enable = true;

  # kernel support
  boot.kernelModules = [ "ntsync" ];

  environment.systemPackages = with pkgs; [
    protonplus
    heroic
    mangohud
    gamescope
    # wine staging 64bit
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
