{ pkgs, ... }:
let
  whyd = pkgs.callPackage ../../pkgs/whyd.nix { };
in
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

    # comms 
    vesktop
    element-desktop
    signal-desktop
    telegram-desktop
    zapzap                # WhatsApp client 
    zoom-us               
    simplex-chat-desktop  
    quassel # IRC Cilent 

    # media
    vlc
    mpv
    spotify        # unfree
    fooyin
    krita
    audacity_3
    handbrake
    reaper                # Reaper DAW
    eartag                # audio file tag editor
    beets                 # music library manager/tagger
    mediainfo             # media file metadata
    kdePackages.kdenlive
    jellyfin-media-player  # jellyfin desktop not server
    nicotine-plus

    # files/sync/productivity
    keepassxc
    # localsend enabled system-wide via programs.localsend in modules/nixos/common.nix (opens firewall)
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
    scrcpy                # Android screen mirroring/control over adb
    uad-ng               # Universal Android Debloater Next Generation (GUI; adb wrapped)
    nh                    # Nix helper
    speedtest-cli
    whyd                  # diagnose previous-boot freeze/crash/shutdown from journal (vmaltarello/whyd)
    discordchatexporter-desktop
    fd
    ripgrep
    yt-dlp
    tokei
    typos
    # direnv already enabled declaratively via programs.direnv (+ nix-direnv) in home/visa/default.nix

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
    itch-dl
    moonlight-qt     # Moonlight client (pairs with Sunshine host; ports opened in modules/security.nix)
    bottles          # verify attr/unfree
    goverlay
    dualsensectl     # control PS5 DualSense (battery, leds, triggers, etc.)
    osu-lazer
    dolphin-emu      # GameCube / Wii emulator
    rpcs3            # PlayStation 3 emulator
    mupen64plus      # Nintendo 64 emulator


    # VPN
    proton-vpn

    # native replacements/helpers for former AppImages/niche (verify attrs on 26.11/unstable)
    musicpresence    # Discord/music rich presence 
    redact           # image/pdf redaction
    cameractrls      # verify attr
    xclicker         # verify attr
    # upscaler? peazip/freac/niche - verify attrs; Goose/Azahar/Sober/Reaper handled case-by-case (see docs)
    # AppImages (appimage-run doesn't work but don't remove it)
    appimage-run

    # fonts/themes helpers (add your Tokyo Night/cursor/font packages here as needed)
    # tokyonight-gtk-theme
    # (cursor/font packages vary; search: nix search nixpkgs tokyo night)
  ];
}
