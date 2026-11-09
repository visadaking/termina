# termina

Personal NixOS flake configuration.

## layout
```
.
├── assets/
│   └── wallpapers/
├── hosts/
│   └── termina/
│       ├── default.nix
│       └── hardware.nix
├── home/
│   └── visa/
│       ├── default.nix
│       ├── desktop.nix
│       └── packages.nix
├── modules/
│   └── nixos/
│       ├── common.nix
│       ├── desktop-kde.nix
│       ├── gaming.nix
│       ├── nix-ld.nix
│       ├── nix.nix
│       ├── packages.nix
│       ├── security.nix
│       ├── services.nix
│       └── virtualisation.nix
├── .gitignore
├── README.md
├── flake.lock
└── flake.nix
```

## use
```sh
# verify hosts/termina/hardware.nix (UUIDs, disk IDs, kernel modules) before install
sudo nixos-install --flake /path/to/termina#termina

# rebuild
sudo nixos-rebuild switch --flake .#termina --refresh
```

Migration/helper scripts live in [visadaking/nixos-scripts](https://github.com/visadaking/nixos-scripts).
