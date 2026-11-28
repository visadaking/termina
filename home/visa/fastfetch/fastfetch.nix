{ config, osConfig ? { }, ... }:
{
  # fastfetch config (portable across machines/users)
  xdg.configFile."fastfetch/fastfetch-logo.jpg".source = ../../../assets/wallpapers/fastfetch-logo.jpg;
  xdg.configFile."fastfetch/config.jsonc".text =
    let
      host = osConfig.networking.hostName or "nixos";
      user = config.home.username;
      home = config.home.homeDirectory;
    in
    ''
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
            "type": "initsystem",
            "key": "├ 󰜉 Init",
            "keyColor": "blue",
            "format": "{name}"
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
            "format": "╭─ Time"
          },
          {
            "type": "command",
            "key": "└ 󰔚 Uptime",
            "keyColor": "blue",
            "text": "s=$(cut -d. -f1 /proc/uptime); d=$((s/86400)); h=$(((s%86400)/3600)); if [ \"$d\" -ge 1 ]; then if [ \"$d\" -eq 1 ]; then echo \"1 day\"; else echo \"$d days\"; fi; else if [ \"$h\" -eq 1 ]; then echo \"1 hour\"; else echo \"$h hours\"; fi; fi"
          }
        ]
      }
    '';
}
