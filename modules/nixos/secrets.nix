{ config, ... }:
{
  # sops-nix secrets. Encrypted secrets live in ../../secrets/secrets.yaml
  # Edit with: sops secrets/secrets.yaml
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "/home/visa/.config/sops/age/keys.txt";

  # Example:
  # sops.secrets."example" = { };
}
