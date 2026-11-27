{ lib, ... }:
{
  # Nightcap (Flatpak) config - writable copies (Nightcap needs to write its config)
  home.activation.nightcapConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dir="$HOME/.var/app/io.github.CoderDayton.nightcap/config/mocktail"
    $DRY_RUN_CMD mkdir -p "$dir"
    $DRY_RUN_CMD cat > "$dir/fflags.json" << 'JSON'
    {
      "DFFlagReduceCPUWhenBG": true,
      "FIntFRMMaxGrassDistance": 0,
      "FIntFRMMinGrassDistance": 0,
      "FIntRobloxGuiBlurIntensity": 0
    }
    JSON
    $DRY_RUN_CMD cat > "$dir/config.yaml" << 'YAML'
    graphics:
      frame_rate_limit: display
      vsync: off
    YAML
  '';
}
