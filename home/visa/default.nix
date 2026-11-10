{ config, pkgs, lib, inputs, osConfig ? {}, ... }:
let
  # KDE Connect run commands (device-specific: 5356cbe09e0a454cbcf086511c34833e)
  # Adds reboot/poweroff (systemctl, polkit/session-dependent), Sunshine controls, sunshine-screen dim/restore.
  # NOTE: kdeconnectd reads this file with QSettings (INI format), so the JSON must be
  # written as an INI-quoted string with escaped inner quotes - a raw unquoted JSON
  # value gets comma-split by QSettings and the phone receives an empty command list.
  kdeconnectCommands = {
    "8a05428f_5569_471f_8e19_0f3f18f7743c" = { name = "Lock Screen"; command = "loginctl lock-session"; };
    "c0c0d80a_8139_4c3d_8834_6efb34cfa197" = { name = "Unlock Screen"; command = "loginctl unlock-session"; };
    "d6c72055_a741_4584_8207_1a8933b95986" = { name = "Reboot"; command = "systemctl reboot"; };
    "032d737c_5b31_470a_a024_49d00a50162b" = { name = "Power Off"; command = "systemctl poweroff"; };
    "a8d40325_b018_49ca_a0c3_a7c7cedf0dbd" = { name = "Sunshine Start"; command = "systemctl --user start sunshine"; };
    "643440b3_4fc8_4fd6_84d9_804a6b30503d" = { name = "Sunshine Restart"; command = "systemctl --user restart sunshine"; };
    "6ac9a6ba_878a_4e38_8acd_0cfa67c76cf0" = { name = "Sunshine Stop"; command = "systemctl --user stop sunshine"; };
    "b1f0d2a4_3c6e_4f8a_9b1d_2e4f6a8c0d1e" = { name = "Sunshine Screen Dim"; command = "sunshine-screen off"; };
    "e2a1b3c4_5d6f_4789_8a0b_1c2d3e4f5a6b" = { name = "Sunshine Screen Restore"; command = "sunshine-screen on"; };
  };
  # escape inner quotes for the INI-quoted value
  kdeconnectCommandsIni = lib.replaceStrings [ "\"" ] [ "\\\"" ] (builtins.toJSON kdeconnectCommands);
in
{
  imports = [
    ./desktop.nix
    ./packages.nix
  ];

  home.username = "visa";
  home.homeDirectory = "/home/visa";
  home.stateVersion = "26.11"; # match NixOS 26.11 (Zokor)

  programs.home-manager.enable = true;

  # shells + termina aliases (repo lives at ~/termina)
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    initContent = ''
      # KDE Connect helpers (kdeconnect-cli)
      kc-devices() { kdeconnect-cli --list-devices "$@"; }
      kc-ping() {
        local dev="''${1:?usage: kc-ping <device-name-or-id> [message]}"
        local msg="''${2:-ping from $(hostname)}"
        kdeconnect-cli -n "$dev" --ping-msg "$msg"
      }
    '';
    shellAliases = {
      t-edit = "nvim $HOME/termina";
      t-check = "nix flake check $HOME/termina";
      t-dry = "sudo nixos-rebuild dry-build --flake $HOME/termina#termina";
      t-switch = "sudo nixos-rebuild switch --flake $HOME/termina#termina --refresh";
      t-clean = "sudo nix-collect-garbage --delete-older-than 30d";
      t-update = "nix flake update --flake $HOME/termina";
      t-status = "git -C $HOME/termina status";
      t-log = "git -C $HOME/termina log --oneline --decorate -10";
      t-push = "git -C $HOME/termina push";
      t-pull = "git -C $HOME/termina pull --ff-only";
      # usage: t-commit "message"  (stages tracked changes in termina repo)
      t-commit = "f(){ git -C $HOME/termina add -A && git -C $HOME/termina commit -m \"\${1:?usage: t-commit \\\"message\\\"}\"; }; f";
      # strict DNS kept; temporary captive-portal workaround (runtime-only, no rebuild/degrade). usage: t-dns-relax wlan0
      t-dns-relax = "f(){ i=\${1:?usage: t-dns-relax <iface> (nmcli device status)}; sudo resolvectl dns \"$i\" '' && sudo resolvectl dnsovertls \"$i\" no && sudo resolvectl dnssec \"$i\" no && echo relaxed: $i; }; f";
      t-dns-revert = "f(){ i=\${1:?usage: t-dns-revert <iface>}; sudo resolvectl revert \"$i\" && echo reverted: $i; }; f";
      fixaudio = "systemctl --user restart wireplumber pipewire pipewire-pulse";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = config.programs.zsh.shellAliases;
  };

  # dev: vim + LazyVim (neovim + LazyVim starter handled by user config; we provide tools)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.git = {
    enable = true;
    # set identity locally (not committed here): git config --global user.name/user.email
    # or add a private module; keep tokens/credentials out of repo.
  };
  programs.direnv = { enable = true; nix-direnv.enable = true; };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml".text = ''
    "$schema" = 'https://starship.rs/config-schema.json'

    format = """
    [░▒▓](#a3aed2)\
    $os\
    [](bg:#769ff0 fg:#a3aed2)\
    $directory\
    [](fg:#769ff0 bg:#394260)\
    $git_branch\
    $git_status\
    [](fg:#394260 bg:#212736)\
    $nodejs\
    $bun\
    $rust\
    $golang\
    $php\
    [ ](fg:#212736)\
    \n$character"""

    [directory]
    style = "fg:#e3e5e5 bg:#769ff0"
    format = "[ $path ]($style)"
    truncation_length = 3
    truncation_symbol = "…/"

    [directory.substitutions]
    "Documents" = "󰈙 "
    "Downloads" = " "
    "Music" = " "
    "Pictures" = " "

    [git_branch]
    symbol = ""
    style = "bg:#394260"
    format = '[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)'

    [git_status]
    style = "bg:#394260"
    format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)'

    [jj_bookmark]
    symbol = ""
    style = "bg:#394260"
    format = '[[ $symbol $bookmark(@$remote)$diverged( \\(+$overflow_count others\\)) ](fg:#769ff0 bg:#394260)]($style)'

    [jj_status]
    style = "bg:#394260"
    format = '[[($all )](fg:#769ff0 bg:#394260)]($style)'

    [nodejs]
    symbol = ""
    style = "bg:#212736"
    format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

    [bun]
    symbol = ""
    style = "bg:#212736"
    format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

    [rust]
    symbol = ""
    style = "bg:#212736"
    format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

    [golang]
    symbol = ""
    style = "bg:#212736"
    format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

    [php]
    symbol = ""
    style = "bg:#212736"
    format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

    [time]
    disabled = true

    [os]
    style = "bg:#a3aed2 fg:#090c0c"
    format = "[ $symbol ]($style)"
    disabled = false

    [os.symbols]
    Windows = "󰍲"
    Ubuntu = "󰕈"
    SUSE = ""
    Raspbian = "󰐿"
    Mint = "󰣭"
    Macos = "󰀵"
    Manjaro = ""
    Linux = "󰌽"
    Gentoo = "󰣨"
    Fedora = "󰣛"
    Alpine = ""
    Amazon = ""
    Android = ""
    AOSC = ""
    Arch = "󰣇"
    Artix = "󰣇"
    EndeavourOS = ""
    CentOS = ""
    Debian = "󰣚"
    Redhat = "󱄛"
    RedHatEnterprise = "󱄛"
    Pop = ""
  '';

  # fastfetch config (portable across machines/users)
  xdg.configFile."fastfetch/fastfetch-logo.jpg".source = ../../assets/wallpapers/fastfetch-logo.jpg;
  xdg.configFile."fastfetch/config.jsonc".text =
    let
      host = osConfig.networking.hostName or "nixos";
      user = config.home.username;
      home = config.home.homeDirectory;
    in ''
    {
      "logo": {
        "type": "kitty",
        "source": "${home}/.config/fastfetch/fastfetch-logo.jpg",
        "width": 63,
        "padding": {
          "top": 1,
          "left": 2
        }
      },
      "display": {
        "separator": " ─ ",
        "color": {
          "separator": "blue"
        }
      },
      "modules": [
        "break",
        {
          "type": "title",
          "format": "${user}@${host}",
          "color": {
            "user": "blue",
            "host": "cyan"
          }
        },
        "break",
        {
          "type": "custom",
          "format": "╭─ System"
        },
        {
          "type": "os",
          "key": "├  OS",
          "keyColor": "blue",
          "format": "{pretty-name}"
        },
        {
          "type": "kernel",
          "key": "├ 󰒋 Kernel",
          "keyColor": "blue"
        },
        {
          "type": "de",
          "key": "├ 󰧨 DE",
          "keyColor": "blue"
        },
        {
          "type": "shell",
          "key": "├ 󱆃 Shell",
          "keyColor": "blue"
        },
        {
          "type": "terminal",
          "key": "├ 󰆍 Terminal",
          "keyColor": "blue"
        },
        {
          "type": "media",
          "key": "└ 󰝚 Music",
          "keyColor": "blue"
        },
        "break",
        {
          "type": "custom",
          "format": "╭─ Hardware"
        },
        {
          "type": "cpu",
          "key": "├ 󰍛 CPU",
          "keyColor": "cyan",
          "format": "{name} @ {freq-max}{?temperature} - {temperature}{?}",
          "temp": true
        },
        {
          "type": "gpu",
          "key": "├ 󰢮 GPU",
          "keyColor": "cyan",
          "temp": true
        },
        {
          "type": "memory",
          "key": "├ 󰑭 RAM",
          "keyColor": "cyan"
        },
        {
          "type": "disk",
          "key": "└ 󰋊 Disk",
          "keyColor": "cyan"
        },
        "break",
        {
          "type": "custom",
          "format": "╭─ Uptime / Age"
        },
        {
          "type": "uptime",
          "key": "├ 󰔚 Uptime",
          "keyColor": "blue"
        },
        {
          "type": "command",
          "key": "└ 󰋚 OS Age",
          "keyColor": "blue",
          "text": "birth=$(stat -c %W /etc/machine-id); now=$(date +%s); age=$((now-birth)); days=$((age/86400)); hours=$(((age%86400)/3600)); if [ $days -gt 0 ]; then [ $days -eq 1 ] && echo \"1 day\" || echo \"$days days\"; else [ $hours -eq 1 ] && echo \"1 hour\" || echo \"$hours hours\"; fi"
        }
      ]
    }
  '';

  # Sunshine user service (start/stop/restart via KDE Connect commands; no auto-start)
  systemd.user.services.sunshine = {
    Unit = {
      Description = "Sunshine game streaming host";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # sunshine-screen (ddcutil dim/restore; config at ~/.config/sunshine-screen.conf)
  programs.sunshine-screen.enable = true;

  # Maidware Project tools
  programs.maid-bt.enable = true;
  programs.maidshare.enable = true;
  programs.maid-suite.enable = true;
  programs.maid-runner.enable = true;

  # KDE Connect run commands (device-specific: 5356cbe09e0a454cbcf086511c34833e)
  # Adds reboot/poweroff (systemctl, polkit/session-dependent), Sunshine controls, sunshine-screen dim/restore.
  xdg.configFile."kdeconnect/5356cbe09e0a454cbcf086511c34833e/kdeconnect_runcommand/config".text = ''
    [General]
    commands="${kdeconnectCommandsIni}"
  '';

  # OBS Studio (wrapped with plugins)
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      obs-multi-rtmp
      obs-vkcapture
      obs-vaapi
      obs-pipewire-audio-capture
      obs-source-record
      obs-vertical-canvas
      obs-teleport
      obs-shaderfilter
      obs-composite-blur
    ];
  };

  # syncthing (user service, secrets/device IDs configured outside repo)
  services.syncthing = {
    enable = true;
    # configure folders/devices via the Syncthing UI or a private local override; do not commit IDs/keys.
  };


  # apps (nixpkgs/native). Flatpak is enabled system-wide but no Flatpak apps declared here.
  # verify attr names on nixpkgs 26.11 / unstable: nix search nixpkgs <name> (use pkgs.unstable.<pkg> if needed)
  # wallpaper (Ergo Proxy) - managed file
  home.file."Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png".source =
    ../../assets/wallpapers/ergo-proxy-kw9yj7-1920x1080.png;

  # keep secrets out of repo; browser passwords/keys/cookies/sessions excluded by migration script
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
