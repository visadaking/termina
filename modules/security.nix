{ ... }:
{
  networking.firewall.enable = true;

  services.fail2ban.enable = true;

  # DNSSEC + DNS-over-TLS (Quad9)
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade"; # use "true" if you want strict (can break some networks)
    dnsovertls = "opportunistic"; # use "true" for strict DoT
    fallbackDns = [ "9.9.9.9" "149.112.112.112" ];
  };
  networking.nameservers = [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
}
