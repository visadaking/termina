# termina

personal nixos config using home manager and flakes

## layout
```
.
├── assets/
│   └── wallpapers/
├── home/
│   └── visa/
│       ├── btop/
│       │   └── tokyo-night.theme
│       ├── default.nix
│       ├── desktop.nix
│       ├── kwinoutputconfig-g25f2.json
│       ├── nixvim.nix
│       └── packages.nix
├── hosts/
│   └── termina/
│       ├── default.nix
│       └── hardware.nix
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
│   ├── openal-win.nix
│   ├── simp1e-tokyo-night-storm.nix
│   └── whyd.nix
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
t-switch        # rebuild and switch now
t-boot          # rebuild and set it for next boot (doesnt switch right away)
t-update        # update all flake inputs (flake.lock)
t-update-input  # update one input: t-update-input nixpkgs-unstable
t-syu           # t-update + t-boot
t-check         # nix flake check
t-dry           # dry build, see if it actually builds
t-test          # t-check + t-dry (safe pre-switch check)
t-clean         # clean old generations (>30d) and free space
t-status        # git status for ~/termina
t-commit "msg"  # stage + commit all changes in ~/termina
t-backup        # push to origin + rond + codeberg
t-pushall       # alias for t-backup
```

`NH_FLAKE` is set to `~/termina`, so `nh` commands work without extra flake args.

usually its just `t-switch` after changing stuff. for safer updates: `t-update` (or `t-update-input <input>`) -> `t-test` -> `t-boot`/`t-syu`, reboot when ready, then commit/push the lock if good.
