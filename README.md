# termina

personal nixos config using home manager and flakes

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
t-switch        # rebuild and switch now
t-boot          # rebuild and set it for next boot (doesnt switch right away)
t-update        # update all flake inputs (flake.lock)
t-update-input  # update one input: t-update-input nixpkgs-unstable
t-syu           # t-update + t-test + t-boot (safe update, set for next boot)
t-check         # nix flake check
t-dry           # dry build, see if it actually builds
t-test          # t-check + t-dry (safe pre-switch/boot check)
t-clean         # clean old generations (>30d) and free space
t-status        # git status for ~/termina
t-commit "msg"  # stage + commit all changes in ~/termina
t-backup        # push to origin + rond + codeberg
t-pushall       # alias for t-backup
```

`NH_FLAKE` is set to `~/termina`, so `nh` commands work without extra flake args.

usually its just `t-switch` after changing stuff. for safer updates: `t-update` (or `t-update-input <input>`) -> `t-test` -> `t-boot` (or `t-syu` to do update+test+boot in one go), reboot when ready, then commit/push the lock if good.

## repositories
- origin (GitHub): `https://github.com/visadaking/termina.git`
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

## environment / quirks (non-secret, termina host)
- **host/platform:** `termina`, `x86_64-linux`, AMD CPU (`kvm-amd`, AMD microcode), UEFI + systemd-boot (`/boot` vfat, editor disabled, 5 configs kept), latest kernel.
- **storage/layout:** ext4 root + vfat `/boot` + ext4 `/games` (`nofail`, 5s device timeout), zram swap; verify UUIDs in `hosts/termina/hardware.nix` before reinstall.
- **desktop/session:** KDE Plasma 6 on Wayland (SDDM), XWayland enabled, PipeWire (Pulse/ALSA, 32-bit ALSA, HiFi clock rates), NetworkManager, Flatpak (declarative via nix-flatpak).
- **locale/input:** timezone `Asia/Jerusalem`, locale `en_US.UTF-8`, keyboard `us,il` with `grp:alt_shift_toggle`.
- **hardware/services quirks:** bluetooth enabled (BlueZ tuning, `btusb`), i2c/DDC enabled, fwupd enabled, LocalSend enabled, AppImage binfmt enabled.
- **stability tweaks:** `sp5100_tco` watchdog blacklisted; reduced system/user `DefaultTimeoutStopSec` to avoid long shutdown hangs.
- **device-specific notes:** Wake-on-LAN configured for `eno1` (BIOS/UEFI must also allow WoL and appropriate power state); udev rules for BT USB autosuspend and Logitech G515 TKL access/power.
- **updates/policy:** flakes enabled, binary caches configured, GC weekly (>30d), `system.autoUpgrade` disabled (manual `t-update`/`t-test`/`t-boot|t-switch` flow preferred).
