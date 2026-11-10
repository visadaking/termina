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
    "d6c72055_a741_4584_8207_1a8933b95986" = { name = "Restart"; command = "systemctl reboot"; };
    "032d737c_5b31_470a_a024_49d00a50162b" = { name = "Power Off"; command = "systemctl poweroff"; };
    "a8d40325_b018_49ca_a0c3_a7c7cedf0dbd" = { name = "Sunshine Start"; command = "systemctl --user start sunshine"; };
    "643440b3_4fc8_4fd6_84d9_804a6b30503d" = { name = "Sunshine Restart"; command = "systemctl --user restart sunshine"; };
    "6ac9a6ba_878a_4e38_8acd_0cfa67c76cf0" = { name = "Sunshine Stop"; command = "systemctl --user stop sunshine"; };
    "b1f0d2a4_3c6e_4f8a_9b1d_2e4f6a8c0d1e" = { name = "Screen Off"; command = "sunshine-screen off"; };
    "e2a1b3c4_5d6f_4789_8a0b_1c2d3e4f5a6b" = { name = "Screen On"; command = "sunshine-screen on"; };
    "3f5e2a1b_7c4d_4e8f_9a0b_1c2d3e4f5a61" = { name = "Sleep"; command = "systemctl suspend"; };
    "5c7d9e1f_2a3b_4c5d_8e9f_0a1b2c3d4e52" = { name = "Bluetooth On"; command = "bluetooth-toggle.sh on"; };
    "7e9f1a2b_4c5d_4e6f_8a0b_2c3d4e5f6a73" = { name = "Bluetooth Off"; command = "bluetooth-toggle.sh off"; };
    "9a1b2c3d_5e4f_4a6b_8c7d_3e4f5a6b7c84" = { name = "Bluetooth Release"; command = "bluetooth-toggle.sh release"; };
    "b2c3d4e5_6f7a_4b8c_9d0e_4f5a6b7c8d95" = { name = "Bluetooth Toggle"; command = "bluetooth-toggle.sh toggle"; };
    "c4d5e6f7_8a9b_4c0d_1e2f_3a4b5c6d7ea6" = { name = "Update"; command = "ghostty -e bash -c 'nix flake update --flake /home/visa/termina; echo; echo \"update done - press Enter to close\"; read x'"; };
    "d6e7f8a9_b0c1_4d2e_3f4a_5b6c7d8e9fb7" = { name = "Switch"; command = "ghostty -e bash -c 'sudo -n /run/current-system/sw/bin/nixos-rebuild switch --flake /home/visa/termina; echo; echo \"switch done - press Enter to close\"; read x'"; };
  };
  # Escape for the INI-quoted value. kdeconnectd reads this file with QSettings
  # (IniFormat), which UNESCAPES the raw value when reading - so the JSON's own
  # escapes must survive that pass: '\' -> '\\' and '"' -> '\"'.
  # Quote-only escaping is not enough once a command contains quotes (e.g. the
  # ghostty popups): toJSON's \" would become \" in the file, QSettings reads a
  # bare quote, the value gets truncated mid-string and the phone receives
  # invalid JSON => empty command list.
  kdeconnectCommandsIni = lib.replaceStrings [ "\\" "\"" ] [ "\\\\" "\\\"" ] (builtins.toJSON kdeconnectCommands);
in
{
  imports = [
    ./desktop.nix
    ./packages.nix
    ./nixvim.nix
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

      # powerlevel10k prompt (mirrors previous starship layout)
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.config/p10k.zsh ]] && source ~/.config/p10k.zsh
    '';
    shellAliases = {
      t-edit = "nvim $HOME/termina";
      t-check = "nix flake check $HOME/termina";
      t-dry = "sudo nixos-rebuild dry-build --flake $HOME/termina#termina";
      t-switch = "sudo nixos-rebuild switch --flake $HOME/termina#termina --refresh";
      t-boot = "sudo nixos-rebuild boot --flake $HOME/termina#termina";
      t-syu = "nix flake update --flake $HOME/termina && sudo nixos-rebuild boot --flake $HOME/termina#termina";
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

      # wallpapers (runtime switch, Plasma 6)
      wallpaper-ergo = "plasma-apply-wallpaperimage \"$HOME/Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png\"";
      wallpaper-715139 = "plasma-apply-wallpaperimage \"$HOME/Pictures/Wallpapers/715139.jpg\"";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = config.programs.zsh.shellAliases;
  };

  # dev: neovim configured declaratively via nixvim (see nixvim.nix)
  # (vim kept in system packages; nixvim provides nvim as default editor)
  programs.git = {
    enable = true;
    # set identity locally (not committed here): git config --global user.name/user.email
    # or add a private module; keep tokens/credentials out of repo.
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
  programs.direnv = { enable = true; nix-direnv.enable = true; };

  # prompt: powerlevel10k (configured to mirror the previous starship prompt)
  xdg.configFile."p10k.zsh".text = ''
    # Powerlevel10k config approximating the previous Starship prompt.
    # Generated for termina. Based on p10k lean/classic options.
    'builtin' 'local' '-a' 'p10k_config_opts'
    [[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
    [[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
    [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
    'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

    () {
      emulate -L zsh -o extended_glob

      unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

      typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        os_icon
        dir
        vcs
        node_version
        rust_version
        go_version
        php_version
        prompt_char
      )
      typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

      typeset -g POWERLEVEL9K_MODE=nerdfont-complete
      typeset -g POWERLEVEL9K_ICON_PADDING=none
      typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

      # Separators to mimic starship's  powerline segments
      typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\ue0b4'
      typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\ue0b6'
      typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
      typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
      typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\u2591\u2592\u2593'
      typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\ue0b4 '

      # os_icon (starship: bg:#a3aed2 fg:#090c0c)
      typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#090c0c'
      typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#a3aed2'
      typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''${P9K_CONTENT}

      # dir (starship: fg:#e3e5e5 bg:#769ff0, truncation 3, substitutions)
      typeset -g POWERLEVEL9K_DIR_BACKGROUND='#769ff0'
      typeset -g POWERLEVEL9K_DIR_FOREGROUND='#e3e5e5'
      typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
      typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
      typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#e3e5e5'
      typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#e3e5e5'
      typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false

      # vcs (git) (starship: fg:#769ff0 bg:#394260)
      typeset -g POWERLEVEL9K_VCS_BACKGROUND='#394260'
      typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$'\uf418 '
      typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

      function my_git_formatter() {
        emulate -L zsh
        if [[ -n $P9K_CONTENT ]]; then
          typeset -g my_git_format=$P9K_CONTENT
          return
        fi
        local branch="''${VCS_STATUS_LOCAL_BRANCH:-''${VCS_STATUS_COMMIT[1,8]}}"
        local res=" ''${POWERLEVEL9K_VCS_BRANCH_ICON}''${branch} "
        if (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED || VCS_STATUS_NUM_CONFLICTED || VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
          (( VCS_STATUS_NUM_STAGED )) && res+="+"
          (( VCS_STATUS_NUM_UNSTAGED )) && res+="!"
          (( VCS_STATUS_NUM_UNTRACKED )) && res+="?"
          (( VCS_STATUS_COMMITS_AHEAD )) && res+="⇡''${VCS_STATUS_COMMITS_AHEAD}"
          (( VCS_STATUS_COMMITS_BEHIND )) && res+="⇣''${VCS_STATUS_COMMITS_BEHIND}"
          res+=" "
        fi
        typeset -g my_git_format=$res
      }
      functions -M my_git_formatter 2>/dev/null
      typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION=''${$((my_git_formatter()))+''${my_git_format}}

      # language/tool versions (starship: fg:#769ff0 bg:#212736)
      typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='#212736'
      typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
      typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\ue718'

      typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND='#212736'
      typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
      typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\ue7a8'

      typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND='#212736'
      typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
      typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\ue627'

      typeset -g POWERLEVEL9K_PHP_VERSION_BACKGROUND='#212736'
      typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND='#769ff0'
      typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true
      typeset -g POWERLEVEL9K_PHP_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\ue608'

      # prompt char on new line (starship: \n$character)
      typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
      typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
      typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
      typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''''

      # transient prompt off to keep it simple
      typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

      (( ! $+functions[p10k] )) || p10k reload
    }

    (( ''${#p10k_config_opts} )) && setopt ''${p10k_config_opts[@]}
    'builtin' 'unset' 'p10k_config_opts'
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
  # Managed via activation (not xdg.configFile symlink) so the file is always a
  # regular, writable config even if a previous activation left a backup/regular
  # file in place. kdeconnectd reads this with QSettings (IniFormat).
  home.activation.kdeconnectRuncommand = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    kde_dir="$HOME/.config/kdeconnect/5356cbe09e0a454cbcf086511c34833e/kdeconnect_runcommand"
    $DRY_RUN_CMD mkdir -p "$kde_dir"
    $DRY_RUN_CMD install -m 600 ${pkgs.writeText "kdeconnect-runcommand-config" ''
      [General]
      commands="${kdeconnectCommandsIni}"
    ''} "$kde_dir/config"
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
  # wallpapers (managed files)
  home.file."Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png".source =
    ../../assets/wallpapers/ergo-proxy-kw9yj7-1920x1080.png;
  home.file."Pictures/Wallpapers/715139.jpg".source =
    ../../assets/wallpapers/715139.jpg;

  # default applications (declarative)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };

  # keep secrets out of repo; browser passwords/keys/cookies/sessions excluded by migration script
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };
}
