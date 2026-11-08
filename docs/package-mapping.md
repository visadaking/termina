# package mapping (current openSUSE -> termina/NixOS 26.11, nixpkgs native)

source: read-only inventory (`rpm -qa`, `flatpak list --system --user`). openSUSE repos/hacks not carried over. prefer nixpkgs; Flatpak enabled but no Flatpak apps by default.

## system packages (rpm/zypper) - key items detected
kde plasma 6, sddm/kwin, kate, kdeconnect, pipewire/wireplumber, bluez, NetworkManager, ghostty, kitty, neovim, vim, zsh, git, podman, distrobox, virt-manager/qemu/libvirt, steam + devices, ProtonPlus, mangohud, obs-studio, vlc, fastfetch, opencode config present, etc. (full list: ~3978 RPMs on current host - not all needed; declarative config includes the essentials.)

## flatpak (system) -> nixpkgs/action
| Flatpak | nixpkgs / action |
|---|---|
| dev.vencord.Vesktop | `vesktop` (included) |
| im.riot.Riot (Element) | `element-desktop` (included) |
| chat.simplex.simplex | `simplex-chat` / `simplex-chat-desktop` (verify attr name; commented in HM) |
| com.heroicgameslauncher.hgl | `heroic` (included; Heroic only) |
| net.lutris.Lutris | **not included** (you chose Heroic only) |
| com.obsproject.Studio | `obs-studio` (included) |
| org.videolan.VLC / vlc | `vlc` (included) |
| com.spotify.Client | `spotify` (unfree) - add if wanted |
| com.vscodium.codium | `vscodium` (add if wanted) |
| org.prismlauncher.PrismLauncher | `prismlauncher` - add if wanted |
| org.signal.Signal | `signal-desktop` - add if wanted |
| org.telegram.desktop | `telegram-desktop` - add if wanted |
| io.ente.auth | `ente-auth` (check attr) |
| md.obsidian.Obsidian | `obsidian` (unfree/electron packaging caveats possible) |
| org.kde.krita | `krita` |
| org.localsend.localsend_app | `localsend` |
| info.mumble.Mumble | `mumble` |
| com.moonlight_stream.Moonlight | `moonlight-qt` |
| org.jellyfin.JellyfinDesktop | `jellyfin-media-player` |
| com.protonvpn.www | Proton VPN app - check nixpkgs availability; alternative: `protonvpn-gui`/CLI where packaged |
| us.zoom.Zoom | `zoom-us` (unfree) |
| org.nicotine_plus.Nicotine | `nicotine-plus` |
| (others) | search: `nix search nixpkgs <name>` and add to `home/visa/default.nix` or a module |

## flatpak (user)
| Flatpak | action |
|---|---|
| org.keepassxc.KeePassXC | `keepassxc` (add if wanted); migrate DB/keys **manually, never commit** |

## notes
- **no Lutris** (per your choice). **/games** and existing Steam/library data untouched.
- unfree packages (Steam, some apps) allowed via `nixpkgs.config.allowUnfree = true`.
- verify package attribute names against nixpkgs 26.11 (`nix search nixpkgs ...`) - some names differ across releases.
