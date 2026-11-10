# termina

personal nixos config using home manager and flakes

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
├── pkgs/
│   └── simp1e-tokyo-night-storm.nix
├── .gitignore
├── README.md
├── flake.lock
└── flake.nix
```

## use
```sh
# verify hosts/termina/hardware.nix (UUIDs, disk IDs, kernel modules) before install
sudo nixos-install --flake /path/to/termina#termina
```

## commands
im lazy

```sh
t-switch   # rebuild and switch now
t-boot     # rebuild and set it for next boot (doesnt switch right away)
t-update   # update flake inputs (flake.lock)
t-syu      # t-update + t-boot
t-dry      # dry build, see if it actually builds
t-clean    # clean old generations (>30d) and free space
```

usually its just `t-switch` after changing stuff, or `t-update` then `t-switch` if i want to update everything. if i want to be safe i do `t-boot` / `t-syu` and reboot into it.
