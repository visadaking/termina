{ lib, pkgs, ... }:
{
  # zram (in common) + memory pressure handling
  services.earlyoom.enable = false;
  systemd.oomd.enable = true;

  # removable disk management (automount/mount/unmount, notifications; KDE/Solid integration)
  services.udisks2.enable = true;

  # SSH server (SFTP included) - disabled by default; enable when needed:
  #   services.openssh.enable = true; (and set auth/firewall rules as needed)
  services.openssh.enable = false;

  # tailscale (installed/configured but do not autostart; start manually when needed)
  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

  # netbird (installed/configured but do not autostart; start manually when needed)
  services.netbird.enable = true;
  systemd.services.netbird.wantedBy = lib.mkForce [ ];

  # speech-dispatcher not needed; disable user service/socket to avoid startup failures
  systemd.user.services.speech-dispatcher.enable = false;
  systemd.user.sockets.speech-dispatcher.enable = false;
}
