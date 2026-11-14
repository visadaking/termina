# termina

personal nixos config using home manager and flakes and kde plasma

## layout
```
.
├── assets/
│   └── wallpapers/
├── home/
│   └── visa/
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
├── flake.nix
└── install.sh
```

## commands
im lazy

```sh
t-edit          # open ~/termina in nvim
t-switch        # rebuild and switch now
t-boot          # rebuild and set it for next boot (doesnt switch right away)
t-update        # update all flake inputs (flake.lock)
t-update-input  # update one input: t-update-input nixpkgs-unstable
t-syu           # t-update + t-test + t-boot (safe update, set for next boot)
t-check         # nix flake check
t-dry           # dry build, see if it actually builds
t-test          # t-check + t-dry (safe pre-switch/boot check)
t-status        # git status for ~/termina
t-log           # recent commits for ~/termina
t-pull          # git pull --ff-only in ~/termina
t-commit "msg"  # stage + commit all changes in ~/termina
t-push          # git push in ~/termina
t-backup        # push main to origin + rond + codeberg
t-pushall       # alias for t-backup
t-dns-relax i   # temporary DNS relax for captive portals (runtime-only)
t-dns-revert i  # revert DNS relax for an interface
```

`NH_FLAKE` is set to `~/termina`, so `nh` commands work without extra flake args.

usually its just `t-switch` after changing stuff. for safer updates: `t-update` (or `t-update-input <input>`) -> `t-test` -> `t-boot` (or `t-syu` to do update+test+boot in one go), reboot when ready, then commit/push the lock if good.

## repositories
- origin (GitHub): `https://github.com/visadaking/termina.git`
- rond: `https://git.rond.cc/visa/termina.git`
- codeberg: `https://codeberg.org/visa1337/termina.git`

keep all remotes in sync with `t-backup` (or `t-pushall`).

## reinstall / bootstrap (from scratch)

> `install.sh` is a helper, not an autopartitioner. disk partitioning/formatting is intentionally manual (hardware-specific and destructive).

### 0. prerequisites
- NixOS live ISO (recommended), network access, and this repo cloned/available.
- know which host you are installing:
  - `termina` = current desktop (AMD/x86_64, UEFI + systemd-boot, KDE Plasma 6, existing disk layout in `hosts/termina/hardware.nix`)
  - future machines (e.g. Intel/AMD laptop) should get their own `hosts/<name>/` + `hardware.nix` and be wired in `flake.nix`

### 1. get the config
```sh
# example (pick any remote)
git clone https://github.com/visadaking/termina.git
# or: git clone https://codeberg.org/visa1337/termina.git
cd termina
```

### 2. partition, format, and mount (manual)
- create/format partitions for the target machine and mount them under `/mnt` (including `/mnt/boot` for EFI when applicable).
- **do not blindly reuse `hosts/termina/hardware.nix` UUIDs/layout on different hardware/disks.**

### 3. verify or generate hardware config for the target host
- existing host: review `hosts/<host>/hardware.nix` (UUIDs, disk IDs, kernel modules, CPU microcode, filesystems).
- new machine/host: generate and review, then place into the correct host:
```sh
sudo nixos-generate-config --root /mnt
# review /mnt/etc/nixos/hardware-configuration.nix and adapt hosts/<host>/hardware.nix
```

### 4. install
```sh
# helper (recommended): checks host/flake and runs nixos-install with confirmation
sudo ./install.sh --flake . --host termina

# dry run/check only
./install.sh --flake . --host termina --no-install

# direct command
sudo nixos-install --flake .#termina
```

### 5. first boot / post-install
- log in as the configured user, verify network/display/audio/input.
- clone or copy this repo to `~/termina` if needed, check remotes/status, and use the normal workflow:
```sh
t-test
t-switch   # or t-boot
```


