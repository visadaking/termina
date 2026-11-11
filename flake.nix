{
  description = "termina - personal NixOS flake (multi-host, flakes + home-manager, KDE)";

  inputs = {
    # nixos-unstable (rolling)
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

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
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

    # Universal Android Debloater Next Generation (GUI + CLI)
    uad-ng = {
      url = "github:Universal-Debloater-Alliance/universal-android-debloater-next-generation";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kopuz = {
      url = "github:temidaradev/kopuz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, sunshine-screen, nix-flatpak, maid-bt, maidshare, maid-suite, maid-runner, nixvim, kopuz, ... }:
    let
      system = "x86_64-linux";
      mkHost = hostName: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostName}
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            # expose uad-ng GUI + uad CLI and kopuz (flake inputs) as pkgs
            nixpkgs.overlays = [
              (final: prev: {
                uad-ng = inputs.uad-ng.packages.${system}.uad-ng;
                uad-cli = inputs.uad-ng.packages.${system}.uad-cli;
                kopuz = inputs.kopuz.packages.${system}.default;
                # workaround: localsend 1.18.0 missing libz.so.1 at runtime on this nixpkgs rev
                localsend = prev.localsend.overrideAttrs (old: {
                  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
                  postFixup = (old.postFixup or "") + ''
                    wrapProgram $out/bin/localsend_app --prefix LD_LIBRARY_PATH : ${prev.lib.makeLibraryPath [ prev.zlib ]}
                  '';
                });
              })
            ];
          }
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
              nixvim.homeModules.nixvim
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

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
