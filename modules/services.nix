{ ... }:
{
  # zram (in common) + memory pressure handling
  services.earlyoom.enable = false;
  systemd.oomd.enable = true;
}
