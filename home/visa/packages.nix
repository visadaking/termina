{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # themes
    tokyonight-gtk-theme
    kdePackages.breeze-icons
    papirus-icon-theme
    # (cursor theme: Simp1e Tokyo Night Storm via desktop.nix, pkgs/simp1e-tokyo-night-storm.nix)

    # browsers
    firefox
    vivaldi
    # chromium # you have chromium RPM; add if wanted (or pkgs.unstable.chromium)

    # comms (from your flatpaks/RPMs - add what you use; some are unfree)
    vesktop
    element-desktop
    signal-desktop
    telegram-desktop
    zapzap                # WhatsApp client (verify attr: zapzap / pkgs.unstable.zapzap)
    zoom-us               # unfree
    simplex-chat-desktop  # verify attr name on 26.11/unstable (simplex-chat-desktop or simplex-chat)

    # media
    vlc
    mpv
    spotify        # unfree
    fooyin
    krita
    audacity_3
    handbrake
    reaper                # DAW (unfree)
    eartag                # audio file tag editor
    kdePackages.kdenlive
    jellyfin-media-player  # org.jellyfin.JellyfinDesktop
    nicotine-plus

    # files/sync/productivity
    keepassxc
    localsend
    obsidian              # unfree/electron caveats
    onlyoffice-desktopeditors
    ente-auth             # verify attr (ente-auth / pkgs.unstable.ente-auth)
    peazip                # verify attr
    freac                 # audio converter (org.freac.freac)
    mission-center

    # dev/tools
    vim
    lazygit
    gh
    vscodium
    filezilla
    home-manager
    android-tools         # adb, fastboot, etc.
    android-cli
    nh                    # Nix helper
    discordchatexporter-desktop
    # github-desktop      # replaced by GH Desktop Plus (Flatpak: org.desktop_plus.desktop-plus)
    # anydesk               # unfree/proprietary; verify attr (anydesk) if you need it - can break on some channels

    # terminal/tools + configs to migrate
    ghostty
    fastfetch
    hyfetch
    starship
    cowsay
    wget
    wakeonlan             # send magic packets to wake other machines (wol)
    # gearlever           # temporarily disabled: fails to build due to dwarfs-0.15.8 tests in current nixpkgs (upstream issue)

    # gaming/helpers (Steam enabled system-wide); /games data untouched
    prismlauncher
    itch             # verify attr on search.nixos.org (26.11/unstable)
    moonlight-qt     # Moonlight client (pairs with Sunshine host; ports opened in modules/security.nix)
    bottles          # verify attr/unfree
    goverlay
    # Lutris skipped (Heroic only). Sober/Roblox - no reliable main nixpkgs package; use flatpak/appimage if needed.

    # VPN (Proton VPN) - verify attr on search.nixos.org (26.11/unstable); common attrs: protonvpn-gui, proton-vpn-gtk-app, proton-vpn-cli
    proton-vpn

    # native replacements/helpers for former AppImages/niche (verify attrs on 26.11/unstable)
    musicpresence    # Discord/music rich presence (was music_presence.appimage)
    redact           # image/pdf redaction
    cameractrls      # verify attr
    xclicker         # verify attr
    # upscaler? peazip/freac/niche - verify attrs; Goose/Azahar/Sober/Reaper handled case-by-case (see docs)
    # AppImages (you still have: lichii in ~/Downloads; keep as file + appimage-run)
    appimage-run

    # fonts/themes helpers (add your Tokyo Night/cursor/font packages here as needed)
    # tokyonight-gtk-theme
    # (cursor/font packages vary; search: nix search nixpkgs tokyo night)
  ];
}
