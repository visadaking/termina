{ ... }:
{
  networking.firewall.enable = true;

  services.fail2ban.enable = true;

  # DNSSEC + DNS-over-TLS (Quad9) - strict (kept strict; do not degrade declaratively)
  # Captive portal / broken-network workaround (TEMPORARY, runtime-only, reverts on reboot or when undone):
  #   sudo resolvectl dns <iface> ""          # or set portal/DHCP DNS for the interface
  #   sudo resolvectl dnsovertls <iface> no
  #   sudo resolvectl dnssec <iface> no
  # Find interface: nmcli device status   (e.g. wlan0/enp5s0). After portal: reconnect or `sudo resolvectl revert <iface>`.
  # Alternatively connect once with NetworkManager's portal flow, then revert interface settings.
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    fallbackDns = [ "9.9.9.9" "149.112.112.112" ];
  };
  networking.nameservers = [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
}
