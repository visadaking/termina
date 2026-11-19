{ ... }:
{
  nix = {
    channel.enable = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;
      trusted-users = [
        "root"
        "visa"
      ];
      # binary caches
      extra-substituters = [
        "https://nix-gaming.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 5";
    };
    flake = "/home/visa/Projects/termina";
  };

  # nix-index-database + comma are used instead
  programs.command-not-found.enable = false;

  # updating your system? what? are you crazy?
  # im actually lazy lol
  system.autoUpgrade.enable = false;
}
