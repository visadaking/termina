{ ... }:
{
  programs.nixcord = {
    enable = true;
    discord.enable = false;

    vesktop = {
      enable = true;
      autoscroll.enable = true;
      settings = builtins.fromJSON (builtins.readFile ./vesktop/settings.json);
    };

    # Preserve existing Vencord settings/plugins exactly
    extraConfig = builtins.fromJSON (builtins.readFile ./vesktop/settings/settings.json);
  };

  # Keep custom desktop entry (middle-click autoscroll + icon)
  xdg.desktopEntries.vesktop = {
    name = "Vesktop";
    genericName = "Internet Messenger";
    comment = "Alternative Discord client with Vencord built-in";
    exec = "vesktop --enable-blink-features=MiddleClickAutoscroll %U";
    icon = "vesktop";
    terminal = false;
    type = "Application";
    categories = [ "Network" "InstantMessaging" "Chat" ];
    mimeType = [ "x-scheme-handler/discord" ];
    settings = {
      Keywords = "discord;vencord;electron;chat";
      StartupWMClass = "Vesktop";
      Version = "1.5";
    };
  };
}
