{ ... }:
{
  networking.firewall = {
    enable = true;
    # Home-network-first: management/streaming/LAN app ports restricted to LAN interface (eno1).
    # Torrent peer port kept global for incoming peers. Syncthing sync (22000) kept global to preserve
    # remote syncing connectivity; review separately if you only sync on LAN/VPN.
    # Verify interface/LAN: ip -br addr; ip route show default
    allowedTCPPorts = [
      22000             # Syncthing sync (global: preserves remote sync; restrict if LAN-only)
      22446             # qBittorrent listen/peer port (global: incoming torrent peers)
    ];
    allowedUDPPorts = [
      22000             # Syncthing QUIC/sync (global)
      22446             # qBittorrent listen/peer port (global)
    ];

    interfaces.eno1 = {
      allowedTCPPorts = [
        1716              # KDE Connect
        53317             # LocalSend
        8580              # qBittorrent WebUI (home LAN only)
        47984 47989 47990 48010  # Sunshine (web UI/HTTPS/RTSP etc., home LAN only)
      ];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # KDE Connect range
      allowedUDPPorts = [
        1716              # KDE Connect
        21027             # Syncthing discovery (LAN)
        53317             # LocalSend
        47998 47999 48000 48002 48010  # Sunshine (home LAN only)
      ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # KDE Connect range
    };
  };

  services.fail2ban.enable = true;

  # Defense-in-depth: blacklist kernel modules with a history of local exploit surface
  # (e.g. Dirty Frag CVEs in esp4/esp6/rxrpc) when you don't use them.
  # - esp4/esp6: kernel IPsec ESP - only needed for IPsec VPNs (strongSwan/Libreswan etc.);
  #   most home setups use WireGuard/OpenVPN and don't load these.
  # - rxrpc: AFS/Kerberos remote procedure call - very niche.
  # If you ever need IPsec ESP or AFS, remove the relevant module from this list.
  boot.blacklistedKernelModules = [ "esp4" "esp6" "rxrpc" ];

  # passwordless rebuild for the KDE Connect "Switch" phone command.
  # NOTE: no "#termina" here - sudoers treats '#' as a comment and truncates the
  # rule (hostname attr resolution is used instead). Match the phone command exactly.
  security.sudo.extraRules = [
    {
      users = [ "visa" ];
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild switch --flake /home/visa/termina";
        options = [ "NOPASSWD" ];
      }];
    }
  ];

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
