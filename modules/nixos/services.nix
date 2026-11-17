{ lib, pkgs, ... }:
{
  # zram
  services.earlyoom.enable = false;
  systemd.oomd.enable = true;

  # removable disk management
  services.udisks2.enable = true;

  # SSH server - disabled by default, re-enable when needed
  # services.openssh.enable = true when needed
  services.openssh.enable = false;

  # tailscale without autostart
  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

  # netbird with autostart disabled
  services.netbird.enable = true;
  systemd.services.netbird.wantedBy = lib.mkForce [ ];

  # speech-dispatcher is the 2nd worst feature to exist (it crashes discord)
  systemd.user.services.speech-dispatcher.enable = false;
  systemd.user.sockets.speech-dispatcher.enable = false;

  # avoid ksshaskpass GUI prompts/errors in terminal git/ssh flows
  programs.ssh.enableAskPassword = false;
}
