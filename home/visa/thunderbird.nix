{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;

      # Keep preferences declarative and in line with the system's dark/Tokyo Night look.
      # Thunderbird generally follows the GTK/system theme; these prefs nudge it toward
      # a consistent dark appearance without managing accounts or local mail data.
      settings = {
        "mail.uidensity" = 0;
        "mail.uifontsize" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        "browser.display.use_system_colors" = true;
        "layout.css.prefers-color-scheme.content-override" = 0; # follow system/theme
        "ui.systemUsesDarkTheme" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = false;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "mailnews.start_page.enabled" = false;
      };
    };
  };
}
