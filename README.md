# termina

a personal nix config immutable/atomic configuration with semi dendritic layout, flake and home manager and plasma manager

## layout 

```text
.
├── assets/
│   ├── feishin/
│   ├── live-wallpapers/
│   ├── plasma/
│   ├── sable-themes/
│   ├── telegram/
│   └── wallpapers/
├── home/
│   └── visa/
│       ├── default.nix
│       ├── packages.nix
│       ├── fastfetch/
│       ├── ghostty/
│       ├── librewolf/
│       ├── nightcap/
│       ├── nixcord/
│       ├── nixvim/
│       ├── plasma/
│       ├── qbittorrent/
│       ├── sable/
│       ├── starship/
│       ├── zed/
│       └── zsh/
├── hosts/
│   └── termina/
│       ├── default.nix
│       └── hardware.nix
├── modules/
│   └── nixos/
│       ├── common.nix
│       ├── default.nix
│       ├── desktop-kde.nix
│       ├── gaming.nix
│       ├── nix-ld.nix
│       ├── nix.nix
│       ├── packages.nix
│       ├── secrets.nix
│       ├── security.nix
│       ├── services.nix
│       └── virtualisation.nix
├── pkgs/
├── .gitignore
├── README.md
├── flake.lock
├── flake.nix
└── install.sh
```

## commands

im lazy 

```sh
t-edit          # open ~/Projects/termina in nvim

switch/updates
t-switch        # rebuild and switch now
t-boot          # rebuild and set it for next boot (doesn't switch right away)
t-update        # update all flake inputs
t-update-input  # update one input: t-update-input nixpkgs
t-ch            # update all nix channels
t-syu           # t-update + t-test + t-boot (safe update, set for next boot)
t-check         # nix flake check

dry tests
t-dry           # dry build, see if it actually builds
t-test          # t-check + t-dry (safe pre-switch/boot check)

vm
vm-status       # show VM/KVM config state, loaded modules, and group membership
vm-on           # enable VM/KVM stack and rebuild+switch
vm-off          # disable VM/KVM stack and rebuild+switch

git
t-status        # termina status for ~/Projects/termina
t-log           # recent commits for ~/Projects/termina
t-pull          # git pull --ff-only in ~/Projects/termina
t-commit "msg"  # stage + commit all changes in ~/Projects/termina
t-push          # git push in ~/Projects/termina
t-backup        # push main to origin + rond + codeberg
t-pushall       # alias for t-backup

dns
t-dns-relax i   # temporary DNS relax for captive portals (runtime-only)
t-dns-revert i  # revert DNS relax for an interface
t-cc            # flush DNS caches

network
netup           # start netbird and tailscaled
```


