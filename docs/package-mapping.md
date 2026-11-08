# Package mapping (openSUSE current → `termina` / NixOS 26.11 "Zokor", nixpkgs-native)

Source: read-only inventory of the **current** host (`rpm -qa`, `flatpak list --system --user`, AppImages). OpenSUSE repos/hacks are **not** carried over. Prefer **nixpkgs**; Flatpak is enabled system-wide but **no Flatpak apps** are declared by default.

**Channels:** base **nixpkgs 26.11** + **`pkgs.unstable.<pkg>`** overlay (see `modules/common.nix`). Use stable by default; use `pkgs.unstable.*` for newer/fixed versions or when a package is missing/broken on 26.11. Always verify attr names:
```bash
nix search nixpkgs <name>
nix search github:NixOS/nixpkgs/nixos-unstable <name>
```

## Already covered in `termina` (native/declarative)
- **System/desktop:** KDE Plasma 6 + SDDM/Wayland, PipeWire, Bluetooth, NetworkManager, zram, systemd-oomd, firewall+fail2ban, resolved Quad9 **strict DNSSEC+DoT** (runtime captive-portal workaround via `t-dns-relax <iface>` / `t-dns-revert <iface>`; no declarative degrade), AMD graphics (Mesa, 32-bit), printing off, Asia/Jerusalem.
- **Nix:** flakes, `auto-optimise-store`, GC weekly 30d, nix-gaming cachix, `system.autoUpgrade` (adjust path/creds or disable).
- **Filesystems:** Btrfs `@` layout + ESP (as verified), `/games` ext4 `nofail` **never touched**, NTFS/exFAT.
- **Gaming:** Steam+Gamemode, ProtonPlus, Heroic, MangoHud, Gamescope, **Wine staging (WoW64 64+32) + winetricks**, `ntsync`, `xone` (Xbox); PS controllers via kernel `hid-playstation`/SDL/Steam Input.
- **Core/dev:** gcc/make/binutils/pkg-config/psmisc/xdg-utils/procps/wget/curl/git/python3/ffmpeg-full/zip/unzip/ripgrep/fd/nil/playerctl/jq/nodejs/libnotify, vim/neovim, btop/fastfetch/**hyfetch**, vscodium, keepassxc, gh, lazygit, filezilla, podman, distrobox, direnv.
- **Media/comms (enabled):** Vivaldi, Firefox, Vesktop, Element, Signal, Telegram, OBS, VLC, MPV, Nuclear, Spotify (unfree), fooyin, LocalSend, PrismLauncher.
- **Maidware:** BT/Runner/Maidshare/Suite via flakes + HM modules; auto-update with rebuild `--refresh`.
- **Config migration:** `scripts/migrate-browser-profiles.sh` stages browser profiles **excluding passwords/keys/cookies/sessions** and copies safe configs incl. **fastfetch + hyfetch** (`~/.config/fastfetch`, `~/.config/hyfetch*`), ghostty/kitty/nvim/vim/git/opencode, dotfiles. **Local-only, review, never commit.**

## RPM/zypper highlights (current host) → nixpkgs
| Current RPM (examples) | nixpkgs / action | Channel hint |
|---|---|---|
| firefox, chromium | `firefox`, `chromium` (add if wanted) | stable/unstable |
| ghostty, kitty, konsole | `ghostty`, `kitty` (konsole comes with Plasma/kdePackages) | stable |
| neovim, vim, vscodium (flatpak) | `neovim`, `vim`, `vscodium` (included) | stable/`unstable.vscodium` for latest |
| git, gh, lazygit, ripgrep, fd, jq, nodejs, python, gcc/clang/cmake/ninja/cargo | included/baseline; add `rustup`/`cargo`/`go` as needed | stable |
| podman, distrobox, virt-manager/qemu/libvirt | included (virtualisation module) | stable |
| steam, ProtonPlus, mangohud, gamescope | included | stable |
| wine-staging + wine-staging-32bit, winetricks | `wineWowPackages.staging`, `winetricks` (included) | stable/`unstable.wineWowPackages.staging` |
| obs-studio, vlc, mpv, audacity | `obs-studio`,`vlc`,`mpv` included; add `audacity` | stable |
| fastfetch, hyfetch | included | stable |
| keepassxc (flatpak user) | `keepassxc` included; migrate DB/keys **manually** | stable |
| Sunshine | `sunshine` (game streaming host) - add if used | stable/unstable |
| openvpn | `openvpn` (add if needed) | stable |
| ark/dolphin/gwenview/kcalc | KDE apps; many included with Plasma - add `kdePackages.*` if missing | stable |
| filezilla | `filezilla` included | stable |

> Full RPM set was ~3978 on the current host; only essentials are declarative. Add others as needed.

## Flatpak (system, current) → nixpkgs/action
| Flatpak | nixpkgs / action | Channel hint |
|---|---|---|
| dev.vencord.Vesktop | `vesktop` ✅ | unstable often newer |
| im.riot.Riot (Element) | `element-desktop` ✅ | stable/unstable |
| chat.simplex.simplex | `simplex-chat-desktop` / `simplex-chat` (**verify attr**) | unstable likely |
| com.heroicgameslauncher.hgl | `heroic` ✅ (Heroic only) | unstable often newer |
| net.lutris.Lutris | **skipped** (no Lutris) | — |
| com.obsproject.Studio | `obs-studio` ✅ | stable/unstable |
| org.signal.Signal | `signal-desktop` ✅ | unstable often newer |
| org.telegram.desktop | `telegram-desktop` ✅ | stable/unstable |
| com.vscodium.codium | `vscodium` ✅ | `unstable.vscodium` for latest |
| org.keepassxc.KeePassXC (user) | `keepassxc` ✅ | stable |
| org.localsend.localsend_app | `localsend` ✅ | stable/unstable |
| org.prismlauncher.PrismLauncher | `prismlauncher` ✅ | unstable often newer |
| com.moonlight_stream.Moonlight | `moonlight-qt` (commented) | stable/unstable |
| org.jellyfin.JellyfinDesktop | `jellyfin-media-player` (commented) | stable |
| org.kde.krita | `krita` (commented) | stable |
| com.spotify.Client | `spotify` (**unfree**) | unstable |
| md.obsidian.Obsidian | `obsidian` (**unfree**, electron caveats) | unstable |
| io.ente.auth | `ente-auth` (**verify attr**) | unstable likely |
| us.zoom.Zoom | `zoom-us` (**unfree**) | unstable |
| com.protonvpn.www | `protonvpn-gui` / `protonvpn-cli` (**verify**) | unstable likely |
| info.mumble.Mumble | `mumble` | stable |
| org.nicotine_plus.Nicotine | `nicotine-plus` | stable |
| com.rtosta.zapzap | `zapzap` (**verify attr**) | unstable likely |
| com.usebottles.bottles | `bottles` (**unfree** sometimes; verify) | unstable |
| com.anydesk.Anydesk | `anydesk` (**unfree/proprietary**, availability varies) | unstable |
| fm.reaper.Reaper | **proprietary DAW**; no native nixpkgs equivalent - use AppImage/Flatpak/manual if needed | — |
| io.github.block.Goose | verify `goose`/upstream packaging; may be unstable/manual | unstable/manual |
| io.itch.itch | itch client not packaged like flatpak; use web/other method | — |
| org.vinegarhq.Sober | **Roblox (Sober)** - check availability/legal/packaging; often manual/flatpak | — |
| org.azahar_emu.Azahar | `azahar` (**verify attr**) | unstable likely |
| hu.irl.cameractrls, io.gitlab.theevilskeleton.Upscaler, org.openlogi.OpenLogi, org.desktop_plus.desktop-plus, xyz.xclicker.xclicker, org.fooyin.fooyin, org.freac.freac, io.github.peazip.PeaZip | niche; search `nixpkgs` case-by-case (`fooyin`, `freac`, `peazip` may exist) | varies |

## AppImages (current `~`)
| AppImage | action on NixOS |
|---|---|
| `~/Downloads/lichii-linux-x86_64-pgo.AppImage` | run via `appimage-run` (included) or move to a managed location; consider packaging only if you want it declarative |
| `~/AppImages/redact.appimage` | `appimage-run` / keep as file |
| `~/AppImages/music_presence.appimage` | `appimage-run` / keep as file (Discord Music Presence) |

`appimage-run` is included in `home/visa` packages. `libfuse2`/FUSE needs are handled by appimage-run in practice; if an AppImage fails, check `programs.appimage`/fuse settings.

## Not carried / decisions
- **No Lutris** (Heroic only). **No openSUSE hacks/repos/workarounds**.
- **`/games` and Steam/library data never touched.**
- **Secrets never committed.** Browser passwords/keys/cookies/sessions excluded from migration.
- Flatpak kept enabled (runtime) but apps managed natively via nixpkgs where possible.
- Unfree allowed (`nixpkgs.config.allowUnfree = true`). Verify licensing for proprietary apps (Zoom, AnyDesk, Reaper, etc.).

## How to add a missing package
1. `nix search nixpkgs <name>` (or unstable).
2. Add to `home/visa/default.nix` (`home.packages`) or `modules/packages.nix`.
3. Rebuild: `t-dry` then `t-switch` (uses `--refresh`; Maidware inputs auto-track). Or `pkgs.unstable.<name>` for the unstable variant.
