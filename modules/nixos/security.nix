{ config, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22000
      2234   # nicotine+ (soulseek)
      22446
    ];
    allowedUDPPorts = [
      22000
      22446
    ];

    interfaces.eno1 = {
      allowedTCPPorts = [
        1716              # kde connect
        8580
        47984 47989 47990 48010
      ];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPorts = [
        1716
        21027
        47998 47999 48000 48002 48010
      ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };
  };

  services.fail2ban.enable = true;

  # insane opesec (passwordless kde connect)
  security.sudo.extraRules = [
    {
      users = [ "visa" ];
      commands = [
        { command = "/run/current-system/sw/bin/nixos-rebuild switch --flake ${config.termina.repoDir}"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nixos-rebuild boot --flake ${config.termina.repoDir}"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nixos-rebuild test --flake ${config.termina.repoDir}"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nixos-rebuild dry-build --flake ${config.termina.repoDir}"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nixos-rebuild build --flake ${config.termina.repoDir}"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # DNS over TLS (Quad9)
  # incase shit goes sideways i guess
  # for internet
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      DNSOverTLS = "true";
      MulticastDNS = "false";
      FallbackDNS = [ "9.9.9.9" "149.112.112.112" ];
    };
  };
  networking.nameservers = [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
}
