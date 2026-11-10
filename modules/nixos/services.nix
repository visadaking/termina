{ pkgs, ... }:
{
  # zram (in common) + memory pressure handling
  services.earlyoom.enable = false;
  systemd.oomd.enable = true;

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

    extraRules = [
      # Sunshine game streaming host - latency sensitive (not in CachyOS rules).
      # "Game" type => nice -5, ioclass best-effort, sched normal (responsive, not RT-aggressive).
      { name = "sunshine"; type = "Game"; }
    ];
  };
}
