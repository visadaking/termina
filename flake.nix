{
  description = "termina";

  inputs = {
    # nixos unstable
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

    # maidware project
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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sable-next = {
      url = "https://git.sable.moe/SableClient/sable-next/archive/768be67a86dc141830603164d543a3f077b3f5c9.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      sunshine-screen,
      nix-flatpak,
      maid-bt,
      maidshare,
      maid-suite,
      maid-runner,
      nixvim,
      nix-index-database,
      sable-next,
      nix-cachyos-kernel,
      ...
    }:
    let
      system = "x86_64-linux";
      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs self; };
          modules = [
            ({ lib, ... }: {
              system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev or "unknown");
            })
            ./hosts/${hostName}
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
            {
              # expose uad-ng GUI + uad CLI (flake inputs) as pkgs
              nixpkgs.overlays = [
                nix-cachyos-kernel.overlays.default
                (final: prev: {
                  uad-ng = inputs.uad-ng.packages.${system}.uad-ng;
                  uad-cli = inputs.uad-ng.packages.${system}.uad-cli;
                  sable = inputs.sable-next.packages.${system}.sable-desktop;
                  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
                    akonadiconsole = prev.emptyDirectory;
                    akonadi-import-wizard = prev.emptyDirectory;
                    ark = prev.emptyDirectory;
                    elisa = prev.emptyDirectory;
                    kmail = prev.emptyDirectory;
                    kontact = prev.emptyDirectory;
                    merkuro = prev.emptyDirectory;
                    okular = prev.emptyDirectory;
                    qrca = prev.emptyDirectory;
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
              home-manager.backupCommand = "${
                nixpkgs.legacyPackages.${system}.bash
              }/bin/bash -c 'mv -- \"$1\" \"$1.bak-$(date +%s)\"' --";
              home-manager.users.visa = import ./home/visa;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        termina = mkHost "termina";
        # add more hosts here: other = mkHost "other";
      };

      packages.${system} = {
        whyd = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/whyd.nix { };
        openal-win = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/openal-win.nix { };
        simp1e-tokyo-night-storm =
          nixpkgs.legacyPackages.${system}.callPackage ./pkgs/simp1e-tokyo-night-storm.nix
            { };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
