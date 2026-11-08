{
  description = "termina - personal NixOS flake (multi-host, flakes + home-manager, KDE)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Maidware tools (track main; auto-update on rebuild with --refresh)
    maid-bt.url = "github:Maidware-Project/Maid-BT";
    maid-runner.url = "github:Maidware-Project/Maid-Runner";
    maidshare.url = "github:Maidware-Project/Maidshare";
    maid-suite.url = "github:Maidware-Project/Maid-Suite";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, ... }:
    let
      system = "x86_64-linux";
      mkHost = hostName: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostName}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            home-manager.users.visa = import ./home/visa;
          }
        ];
      };
    in {
      nixosConfigurations = {
        termina = mkHost "termina";
        # add more hosts here: other = mkHost "other";
      };
    };
}
