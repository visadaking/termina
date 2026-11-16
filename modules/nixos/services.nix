{ lib, pkgs, ... }:
{
  # zram (in common) + memory pressure handling
  services.earlyoom.enable = false;
  systemd.oomd.enable = true;

  # removable disk management (automount/mount/unmount, notifications; KDE/Solid integration)
  services.udisks2.enable = true;

  # SSH server (SFTP included)
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

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
