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

  # Tailscale (VPN mesh; enable now, configure/auth with `tailscale up` when needed)
  services.tailscale.enable = true;

  # Automatic process priority management (nice/ionice/sched/oom) for desktop responsiveness.
  # Uses ananicy-cpp + CachyOS rules (curated baseline covering browsers, compilers, nix, games, etc.).
  # Safeguards against mis-prioritization:
  # - CachyOS rules as baseline instead of ad-hoc rules.
  # - Targeted extraRules below for this host's latency-sensitive services not covered upstream
  #   (e.g. Sunshine streaming). Override/extend via extraRules if any app is mis-classified.
  # - nix/nix-daemon are already classified BG by CachyOS so rebuilds don't starve the desktop.
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;

    settings = {
      # Disable cgroup-based process placement: on systemd's unified cgroup v2 hierarchy
      # ananicy-cpp's moves fail with EINVAL at startup (and conflict with systemd-managed
      # slices). Nice/ionice/sched/oom adjustments still apply - the main responsiveness win.
      apply_cgroup = false;
      cgroup_load = false;
      # The realtime workaround also moves RT processes to the root cgroup (""), which
      # fails the same way on cgroup v2; mkForce needed because the module sets this to
      # true for ananicy-cpp by default.
      cgroup_realtime_workaround = lib.mkForce false;
    };

    extraRules = [
      # Sunshine game streaming host - latency sensitive (not in CachyOS rules).
      # "Game" type => nice -5, ioclass best-effort, sched normal (responsive, not RT-aggressive).
      { name = "sunshine"; type = "Game"; }
    ];
  };
}
