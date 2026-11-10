{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # avoid nixvim/nixpkgs follows warning when using HM with global pkgs
    nixpkgs.pkgs = pkgs;

    # your photo (copied into repo): assets/nvim-logo.png
    # can be used for a dashboard image/header with additional setup if desired.

    globals.mapleader = " ";

    clipboard.register = "unnamedplus";

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      signcolumn = "yes";
      termguicolors = true;
      cursorline = true;
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      splitbelow = true;
      splitright = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 400;
      undofile = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      breakindent = true;
      showmode = false;
      completeopt = [ "menu" "menuone" "noselect" ];
    };

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "storm";
    };

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      web-devicons.enable = true;

      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
      };

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          bashls.enable = true;
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      luasnip.enable = true;
      friendly-snippets.enable = true;

      gitsigns.enable = true;
      which-key.enable = true;
      nvim-autopairs.enable = true;
      indent-blankline.enable = true;
      comment.enable = true;
      toggleterm.enable = true;
      trouble.enable = true;

      alpha = {
        enable = true;
        theme = "dashboard";
      };
    };

    keymaps = [
      # VSCode-like basics
      { mode = [ "n" "i" "v" ]; key = "<C-s>"; action = "<cmd>w<cr><esc>"; options.desc = "Save file"; }
      { mode = "n"; key = "<C-p>"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find files"; }
      { mode = "n"; key = "<C-f>"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Search in files"; }
      { mode = "n"; key = "<C-b>"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Toggle file explorer"; }
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Explorer"; }
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Live grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<cr>"; options.desc = "Buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<cr>"; options.desc = "Help"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<cr>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<cr>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<cr>"; options.desc = "Close buffer"; }
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<cr>"; options.desc = "Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>t"; action = "<cmd>ToggleTerm<cr>"; options.desc = "Toggle terminal"; }
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<cr>"; options.desc = "Clear search highlight"; }
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Window left"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Window down"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Window up"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Window right"; }
    ];
  };
}
