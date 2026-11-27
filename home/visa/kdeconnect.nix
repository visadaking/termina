{ config, lib, pkgs, ... }:
let
  # Adds reboot/poweroff (systemctl, polkit/session-dependent), Sunshine controls, sunshine-screen dim/restore.
  # NOTE: kdeconnectd reads this file with QSettings (INI format), so the JSON must be
  # written as an INI-quoted string with escaped inner quotes - a raw unquoted JSON
  # value gets comma-split by QSettings and the phone receives an empty command list.
  kdeconnectCommands = {
    "8a05428f_5569_471f_8e19_0f3f18f7743c" = {
      name = "Lock Screen";
      command = "loginctl lock-session";
    };
    "c0c0d80a_8139_4c3d_8834_6efb34cfa197" = {
      name = "Unlock Screen";
      command = "loginctl unlock-session";
    };
    "d6c72055_a741_4584_8207_1a8933b95986" = {
      name = "Restart";
      command = "systemctl reboot";
    };
    "032d737c_5b31_470a_a024_49d00a50162b" = {
      name = "Power Off";
      command = "systemctl poweroff";
    };
    "a8d40325_b018_49ca_a0c3_a7c7cedf0dbd" = {
      name = "Sunshine Start";
      command = "systemctl --user start sunshine";
    };
    "643440b3_4fc8_4fd6_84d9_804a6b30503d" = {
      name = "Sunshine Restart";
      command = "systemctl --user restart sunshine";
    };
    "6ac9a6ba_878a_4e38_8acd_0cfa67c76cf0" = {
      name = "Sunshine Stop";
      command = "systemctl --user stop sunshine";
    };
    "b1f0d2a4_3c6e_4f8a_9b1d_2e4f6a8c0d1e" = {
      name = "Screen Off";
      command = "sunshine-screen off";
    };
    "e2a1b3c4_5d6f_4789_8a0b_1c2d3e4f5a6b" = {
      name = "Screen On";
      command = "sunshine-screen on";
    };
    "3f5e2a1b_7c4d_4e8f_9a0b_1c2d3e4f5a61" = {
      name = "Sleep";
      command = "systemctl suspend";
    };
    "5c7d9e1f_2a3b_4c5d_8e9f_0a1b2c3d4e52" = {
      name = "Bluetooth On";
      command = "bluetooth-toggle.sh on";
    };
    "7e9f1a2b_4c5d_4e6f_8a0b_2c3d4e5f6a73" = {
      name = "Bluetooth Off";
      command = "bluetooth-toggle.sh off";
    };
    "9a1b2c3d_5e4f_4a6b_8c7d_3e4f5a6b7c84" = {
      name = "Bluetooth Release";
      command = "bluetooth-toggle.sh release";
    };
    "b2c3d4e5_6f7a_4b8c_9d0e_4f5a6b7c8d95" = {
      name = "Bluetooth Toggle";
      command = "bluetooth-toggle.sh toggle";
    };
    "c4d5e6f7_8a9b_4c0d_1e2f_3a4b5c6d7ea6" = {
      name = "Update";
      command = "ghostty -e bash -c 'nix flake update --flake /home/visa/Projects/termina; echo; echo \"update done - press Enter to close\"; read x'";
    };
    "d6e7f8a9_b0c1_4d2e_3f4a_5b6c7d8e9fb7" = {
      name = "Switch";
      command = "ghostty -e bash -c 'sudo -n /run/current-system/sw/bin/nixos-rebuild switch --flake /home/visa/Projects/termina; echo; echo \"switch done - press Enter to close\"; read x'";
    };
  };
  # Escape for the INI-quoted value. kdeconnectd reads this file with QSettings
  # (IniFormat), which UNESCAPES the raw value when reading - so the JSON's own
  # escapes must survive that pass: '\' -> '\\' and '"' -> '\"'.
  # Quote-only escaping is not enough once a command contains quotes (e.g. the
  # ghostty popups): toJSON's \" would become \" in the file, QSettings reads a
  # bare quote, the value gets truncated mid-string and the phone receives
  # invalid JSON => empty command list.
  kdeconnectCommandsIni = lib.replaceStrings [ "\\" "\"" ] [ "\\\\" "\\\"" ] (
    builtins.toJSON kdeconnectCommands
  );
in
{
  home.activation.kdeconnectRuncommand = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    kde_dir="$HOME/.config/kdeconnect/5356cbe09e0a454cbcf086511c34833e/kdeconnect_runcommand"
    $DRY_RUN_CMD mkdir -p "$kde_dir"
    $DRY_RUN_CMD install -m 600 ${pkgs.writeText "kdeconnect-runcommand-config" ''
      [General]
      commands="${kdeconnectCommandsIni}"
    ''} "$kde_dir/config"
  '';
}
