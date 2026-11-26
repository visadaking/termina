{ ... }:
{
  # Nightcap (Flatpak) config - declarative
  home.file.".var/app/io.github.CoderDayton.nightcap/config/mocktail/fflags.json".text =
    builtins.toJSON {
      FIntFRMMaxGrassDistance = 0;
      FIntFRMMinGrassDistance = 0;
      FIntRobloxGuiBlurIntensity = 0;
      DFFlagReduceCPUWhenBG = true;
    };

  home.file.".var/app/io.github.CoderDayton.nightcap/config/mocktail/config.yaml".text = ''
    graphics:
      frame_rate_limit: display
      vsync: off
  '';
}
