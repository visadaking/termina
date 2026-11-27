{ pkgs, lib, ... }:
let
  userSettings = {
    # Termina look
    "workbench.colorTheme" = "Tokyo Night Storm";
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.startupEditor" = "none";
    "workbench.tree.indent" = 14;
    "window.titleBarStyle" = "custom";
    "window.commandCenter" = true;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', monospace";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 14;
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.smoothScrolling" = true;
    "editor.minimap.enabled" = false;
    "editor.bracketPairColorization.enabled" = true;
    "editor.guides.bracketPairs" = true;
    "editor.renderLineHighlight" = "all";
    "editor.linkedEditing" = true;
    "editor.stickyScroll.enabled" = true;
    "editor.inlayHints.enabled" = "onUnlessPressed";

    # Tokyo Night / Termina touches
    "workbench.colorCustomizations" = {
      "titleBar.activeBackground" = "#1a1b26";
      "titleBar.activeForeground" = "#c0caf5";
      "titleBar.inactiveBackground" = "#16161e";
      "titleBar.inactiveForeground" = "#565f89";
      "statusBar.background" = "#1a1b26";
      "statusBar.foreground" = "#c0caf5";
      "statusBar.noFolderBackground" = "#1a1b26";
      "activityBar.background" = "#16161e";
      "sideBar.background" = "#16161e";
    };

    # Save / format
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
    "editor.formatOnSave" = true;
    "files.trimTrailingWhitespace" = true;
    "files.insertFinalNewline" = true;

    # Terminal
    "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.defaultProfile.linux" = "zsh";

    # Git
    "git.autofetch" = true;
    "git.confirmSync" = false;
    "git.enableSmartCommit" = true;
    "git.openRepositoryInParentFolders" = "always";
    "gitlens.hovers.currentLine.over" = "line";
    "gitlens.codeLens.enabled" = false;

    # Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";

    # Privacy / behavior
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "extensions.autoUpdate" = false;
    "security.workspace.trust.enabled" = true;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
  };

  keybindings = [
    {
      key = "ctrl+`";
      command = "workbench.action.terminal.toggleTerminal";
    }
    {
      key = "ctrl+shift+g g";
      command = "workbench.view.scm";
    }
    {
      key = "ctrl+shift+e";
      command = "workbench.view.explorer";
    }
    {
      key = "ctrl+alt+f";
      command = "editor.action.formatDocument";
      when = "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly";
    }
  ];
in
{
  home.packages = with pkgs; [
    nil
  ];

  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Look
        enkia.tokyo-night
        pkief.material-icon-theme

        # Nix / dev env
        jnoortheen.nix-ide
        mkhl.direnv

        # Git
        eamodio.gitlens
        mhutchie.git-graph

        # Editor quality
        usernamehw.errorlens
        gruntfuggly.todo-tree
        tamasfe.even-better-toml
        redhat.vscode-yaml

        # Web / formatting
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint

        # Languages
        ms-python.python
        rust-lang.rust-analyzer
        golang.go
      ];
    };
  };

  # Writable copies: HM-managed symlinks make VSCodium settings read-only (EROFS).
  home.activation.vscodiumConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dir="$HOME/.config/VSCodium/User"
    $DRY_RUN_CMD mkdir -p "$dir"
    $DRY_RUN_CMD cat > "$dir/settings.json" << 'JSON'
${builtins.toJSON userSettings}
    JSON
    $DRY_RUN_CMD cat > "$dir/keybindings.json" << 'JSON'
${builtins.toJSON keybindings}
    JSON
  '';
}
