{ config, lib, ... }:
{
  # Shared options for the termina host modules. Keeping the repo path configurable
  # lets the same config work from ~/Projects/termina, /etc/nixos, or anywhere else.
  options.termina.repoDir = lib.mkOption {
    type = lib.types.str;
    default = "/home/visa/Projects/termina";
    description = "Path to the checked-out termina flake repository.";
  };
}
