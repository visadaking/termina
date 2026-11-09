{
  description = "termina - personal NixOS flake (multi-host, flakes + home-manager, KDE)";

  inputs = {
    # NixOS 26.11 "Zokor" (base) + unstable for select packages (pkgs.unstable.<name>)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sunshine-screen = {
      url = "github:visadaking/sunshine-screen";
    };

    # Maidware Project tools (packaging fixed/pushed upstream)
    maid-bt = {
      url = "github:Maidware-Project/Maid-BT";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maidshare = {
      url = "github:Maidware-Project/Maidshare";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maid-suite = {
      url = "github:Maidware-Project/Maid-Suite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maid-runner = {
      url = "github:Maidware-Project/Maid-Runner";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, sunshine-screen, maid-bt, maidshare, maid-suite, maid-runner, ... }:
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
            home-manager.sharedModules = [
              plasma-manager.homeModules.plasma-manager
              sunshine-screen.homeModules.default
              maid-bt.homeModules.default
              maidshare.homeModules.default
              maid-suite.homeModules.default
              maid-runner.homeModules.default
            ];
            # avoid HM activation failures when a previous backup file already exists
            home-manager.backupCommand = "${nixpkgs.legacyPackages.${system}.bash}/bin/bash -c 'mv -- \"$1\" \"$1.bak-$(date +%s)\"' --";
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
