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
  };
  programs.gamemode.enable = true;

  # mesa shader cache size (not VRAM-reserved)
  environment.sessionVariables = {
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

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
