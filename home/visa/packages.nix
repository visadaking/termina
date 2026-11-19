{ pkgs, ... }:
let
  whyd = pkgs.callPackage ../../pkgs/whyd.nix { };
in
{
  home.packages = with pkgs; [
    # themes
    tokyonight-gtk-theme
    kdePackages.breeze-icons
    (callPackage ../../pkgs/papirus-icon-theme-teal.nix { })
    # (cursor theme: Simp1e Tokyo Night Storm via desktop.nix, pkgs/simp1e-tokyo-night-storm.nix)

    # browsers
    # firefox managed declaratively via programs.librewolf (home/visa/librewolf.nix)

    # comms
    fluxer-canary-bin
    sable
    vesktop
    signal-desktop
    telegram-desktop
    zapzap # WhatsApp client
    zoom-us
    simplex-chat-desktop
    quassel # IRC client

    # media
    vlc
    mpv
    spotify
    feishin
    fooyin
    krita
    audacity_3
    handbrake
    reaper # Reaper DAW
    eartag # audio file tag editor
    beets # music library manager/tagger
    mediainfo # media file metadata
    libva-utils # provides vainfo (VA-API capability/driver info)
    kdePackages.kdenlive
    jellyfin-media-player # jellyfin desktop not server
    nicotine-plus

    # files/sync/productivity
    keepassxc
    # localsend enabled system-wide via programs.localsend in modules/nixos/common.nix (opens firewall)
    obsidian # unfree/electron caveats
    onlyoffice-desktopeditors
    ente-auth
    peazip
    freac # audio converter (org.freac.freac)
    mission-center
    qbittorrent
    netbird-ui

    # dev/tools
    lazygit
    gh
    vscodium
    opencode
    filezilla
    home-manager
    kdePackages.kcolorchooser # color picker
    android-tools # adb, fastboot, etc.
    android-cli
    scrcpy # Android screen mirroring/control over adb
    uad-ng # Universal Android Debloater Next Generation (GUI; adb wrapped)
    nh # Nix helper
    speedtest-cli
    # amdgpu stuff
    amdgpu_top
    whyd # diagnose previous-boot freeze/crash/shutdown from journal (vmaltarello/whyd)
    yt-dlp
    tokei
    typos
    # direnv already enabled declaratively via programs.direnv (+ nix-direnv) in home/visa/default.nix

    # terminal/tools + configs to migrate
    ghostty
    hyfetch
    starship
    cowsay
    wakeonlan # send magic packets to wake other machines (wol)
    # gearlever           # temporarily disabled: fails to build due to dwarfs-0.15.8 tests in current nixpkgs (upstream issue)

    # gaming/helpers (Steam enabled system-wide); /games data untouched
    prismlauncher
    itch
    itch-dl
    moonlight-qt # Moonlight client (pairs with Sunshine host; ports opened in modules/security.nix)
    bottles
    goverlay
    dualsensectl # control PS5 DualSense (battery, leds, triggers, etc.)
    osu-lazer
    dolphin-emu # GameCube / Wii emulator
    rpcs3 # PlayStation 3 emulator
    mupen64plus # Nintendo 64 emulator
    

    # VPN
    proton-vpn

    # native replacements/helpers for former AppImages/niche
    musicpresence # Discord/music rich presence
    # AppImages (appimage-run doesn't work but don't remove it)
    appimage-run

    # fonts/themes helpers (add your Tokyo Night/cursor/font packages here as needed)
    # tokyonight-gtk-theme
    # (cursor/font packages vary; search: nix search nixpkgs tokyo night)
  ];
}
