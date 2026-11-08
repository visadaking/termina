# termina

personal NixOS flake (multi-host, reusable). **private repo - no secrets committed.**

- host: `termina` (ASUS TUF GAMING B650-PLUS, AMD desktop, UEFI)
- boot: systemd-boot (UEFI)
- fs: Btrfs subvols (like current openSUSE layout), **no LUKS**; `/games` ext4 mounted (`nofail`) - **Steam/library data is never touched**
- desktop: KDE Plasma (Wayland-capable), plasma-manager for **keybinds + theme basics** (Tokyo Night/cursor related) - start small
- config style: flakes + Home Manager (as NixOS module), **nixpkgs NixOS 26.11 "Zokor"** (base) + **nixpkgs-unstable** available as `pkgs.unstable.<pkg>`
- apps: nixpkgs (native). Flatpak enabled, but no Flatpak app installs by default
- Maidware tools: BT/Runner/Maidshare/Suite via flakes (auto-update on rebuild with `--refresh`)
- secrets: **kept out of repo** (sops-nix/agenix can be added later; do not commit tokens/keys/passwords)

## layout
```
flake.nix
hosts/termina/        # this host (default + hardware)
modules/              # shared modules (common, kde, gaming, virtualisation)
home/visa/            # home-manager (apps, plasma basics, syncthing, vim+LazyVim)
scripts/              # local helpers (browser migration) - review before running
secrets/              # gitignored placeholder (never commit)
```

## use
```sh
# first time (from a NixOS live env / after partitioning to match hardware.nix): verify UUIDs/subvols
sudo nixos-install --flake /path/to/termina#termina

# rebuild (auto-update inputs on rebuild)
nix flake update && sudo nixos-rebuild switch --flake .#termina --refresh
# or: sudo nixos-rebuild switch --flake .#termina --refresh
```

## important
- **verify `hosts/termina/hardware.nix`** (UUIDs, disk IDs, kernel modules) on the real machine before install.
- timezone: **Asia/Jerusalem**. printing: **disabled**.
- `/games` is mounted `nofail` and its contents are **not managed**. do not format/touch that disk.
- migration (local-only, review before running): `scripts/migrate-browser-profiles.sh` copies browser profiles **excluding passwords/keys/cookies/sessions**; also copy configs like `~/.config/fastfetch`, `~/.config/ghostty` (and other app configs you want) - never commit secrets.
- openSUSE hacks/repos/workarounds are intentionally not carried over.
