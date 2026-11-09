{ ... }:
{
  networking.firewall = {
    enable = true;
    # app/streaming/sync ports (from current system). adjust if you change app settings.
    allowedTCPPorts = [
      1716              # KDE Connect
      22000             # Syncthing sync
      53317             # LocalSend
      22446             # qBittorrent listen (Session\Port)
      8580              # qBittorrent WebUI (LAN; disable if not needed)
      47984 47989 47990 48010  # Sunshine (web UI / HTTPS / RTSP / etc.)
    ];
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # KDE Connect range
    allowedUDPPorts = [
      1716              # KDE Connect
      21027             # Syncthing discovery
      22000             # Syncthing QUIC/sync
      53317             # LocalSend
      22446             # qBittorrent listen
      47998 47999 48000 48002 48010  # Sunshine
    ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # KDE Connect range
  };

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
    settings.Resolve = {
      DNSSEC = "true";
      DNSOverTLS = "true";
      FallbackDNS = [ "9.9.9.9" "149.112.112.112" ];
    };
  };
  networking.nameservers = [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
}
