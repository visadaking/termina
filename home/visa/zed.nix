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
      # Neovim-like editing
      vim_mode = true;
      relative_line_numbers = "enabled";
      cursor_blink = false;
      vertical_scroll_margin = 8;
      scroll_beyond_last_line = "off";
      soft_wrap = "none";
      show_whitespaces = "selection";
      preferred_line_length = 100;
      tab_size = 2;
      hard_tabs = false;

      # Look / layout (VSCodium + Neovim feel)
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
      current_line_highlight = "all";
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      inlay_hints = {
        enabled = true;
      };
      gutter = {
        line_numbers = true;
        fold_indicator = true;
      };
      tab_bar = {
        show = true;
        show_nav_history_buttons = false;
      };
      toolbar = {
        breadcrumbs = true;
        quick_actions = true;
      };
      project_panel = {
        dock = "left";
        default_width = 280;
        indent_size = 14;
        file_icons = true;
        folder_icons = true;
      };
      outline_panel = {
        dock = "right";
      };
      collaboration_panel = {
        button = false;
      };
      notification_panel = {
        button = false;
      };

      # Save / format
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      format_on_save = "on";
      ensure_final_newline_on_save = true;
      remove_trailing_whitespace_on_save = true;

      # Terminal
      terminal = {
        dock = "bottom";
        font_family = "JetBrainsMono Nerd Font";
        font_size = 14;
        blinking = "off";
        copy_on_select = true;
        shell = {
          program = "zsh";
        };
      };

      # Git / behavior
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
      file_finder = {
        modal_max_width = "large";
      };

      # LSP
      lsp = {
        nil = {
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
        };
      };
    };

    userKeymaps = [
      # File explorer / project panel (like <C-b> / <leader>e)
      {
        context = "Workspace";
        bindings = {
          "ctrl-b" = "workspace::ToggleLeftDock";
          "ctrl-shift-e" = "project_panel::ToggleFocus";
          "ctrl-p" = "file_finder::Toggle";
          "ctrl-shift-f" = "pane::DeploySearch";
          "ctrl-`" = "terminal_panel::ToggleFocus";
        };
      }
      # Buffer/tab navigation (like S-h / S-l)
      {
        context = "Pane";
        bindings = {
          "shift-h" = "pane::ActivatePreviousItem";
          "shift-l" = "pane::ActivateNextItem";
        };
      }
    ];
  };
}
