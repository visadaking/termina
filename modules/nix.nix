{ ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      # gaming binary cache (nix-gaming)
      extra-substituters = [ "https://nix-gaming.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # automatic system updates disabled; prefer manual control with t-update/t-dry/t-switch.
  # (auto-upgrade + --commit-lock-file in an active git repo can create surprise commits/conflicts)
  system.autoUpgrade.enable = false;
}
