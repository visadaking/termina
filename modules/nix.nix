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

  # automatic system updates (flake). ADJUST path to your clone; --commit-lock-file needs a writable git repo/creds.
  # consider setting enable = false if you prefer manual updates.
  system.autoUpgrade = {
    enable = true;
    flake = "/home/visa/Documents/GitHub/termina#termina";
    flags = [ "--print-build-logs" "--commit-lock-file" "--refresh" ];
    allowReboot = false;
  };
}
