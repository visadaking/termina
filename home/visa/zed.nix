{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
  ];

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;

    extensions = [
      "nix"
      "tokyo-night"
      "toml"
    ];

    userSettings = {
      theme = {
        mode = "dark";
        dark = "Tokyo Night Storm";
        light = "Tokyo Night Light";
      };
      ui_font_size = 16;
      buffer_font_size = 14;
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_fallbacks = [ "JetBrains Mono" ];
      buffer_font_features = {
        calt = true;
      };
      cursor_blink = true;
      relative_line_numbers = false;
      scroll_beyond_last_line = "one_page";
      vertical_scroll_margin = 3;
      tab_size = 2;
      soft_wrap = "editor_width";
      show_whitespaces = "selection";
      inlay_hints = {
        enabled = true;
      };
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      format_on_save = "on";
      ensure_final_newline_on_save = true;
      remove_trailing_whitespace_on_save = true;
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 14;
        blinking = "on";
        shell = {
          program = "zsh";
        };
      };
      git = {
        inline_blame = {
          enabled = false;
        };
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      auto_update = false;
      lsp = {
        nil = {
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
        };
      };
    };
  };
}
