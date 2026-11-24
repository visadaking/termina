{ config, lib, ... }:
let
  homeDir = config.home.homeDirectory;
  aliases = import ./aliases.nix { inherit homeDir; };
  functions = import ./functions.nix { inherit homeDir; };
  # TokyoNight Storm-ish shell colors
  tn = {
    fg = "#c0caf5";
    comment = "#565f89";
    cyan = "#7dcfff";
    blue = "#7aa2f7";
    green = "#9ece6a";
    magenta = "#bb9af7";
    red = "#f7768e";
    yellow = "#e0af68";
    orange = "#ff9e64";
  };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    initContent = ''
      # TokyoNight-themed syntax highlighting / autosuggestions
      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[default]="fg=${tn.fg}"
      ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${tn.red}"
      ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=${tn.magenta}"
      ZSH_HIGHLIGHT_STYLES[alias]="fg=${tn.cyan}"
      ZSH_HIGHLIGHT_STYLES[builtin]="fg=${tn.blue}"
      ZSH_HIGHLIGHT_STYLES[function]="fg=${tn.blue}"
      ZSH_HIGHLIGHT_STYLES[command]="fg=${tn.green}"
      ZSH_HIGHLIGHT_STYLES[precommand]="fg=${tn.green},italic"
      ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=${tn.magenta}"
      ZSH_HIGHLIGHT_STYLES[path]="fg=${tn.fg},underline"
      ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=${tn.comment}"
      ZSH_HIGHLIGHT_STYLES[globbing]="fg=${tn.cyan}"
      ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${tn.yellow}"
      ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${tn.yellow}"
      ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=${tn.yellow}"
      ZSH_HIGHLIGHT_STYLES[assign]="fg=${tn.orange}"
      ZSH_HIGHLIGHT_STYLES[comment]="fg=${tn.comment},italic"
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${tn.comment}"

      ${functions}
    '';
    shellAliases = aliases;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    initExtra = ''
      ${functions}
    '';
  };
}
