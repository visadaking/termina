# termina

personal nix config  (flakes + home manager + plasma manager)

## layout 

```text
.
├── assets/
│   ├── feishin/
│   ├── sable-themes/
│   ├── telegram/
│   └── wallpapers/
├── home/
│   └── visa/
│       ├── vesktop/
│       ├── default.nix
│       ├── desktop.nix
│       ├── ghostty.nix
│       ├── librewolf.nix
│       ├── kwinoutputconfig-g25f2.json
│       ├── nixvim.nix
│       ├── sable.nix
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
│   ├── papirus-icon-theme-teal.nix
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
t-edit          # open ~/Projects/termina in nvim

switch/updates
t-switch        # rebuild and switch now
t-boot          # rebuild and set it for next boot (doesn't switch right away)
t-update        # update flake inputs except pinned one (sable-next)
t-update-input  # update one input: t-update-input nixpkgs-unstable
t-spu           # update pinned input: sable-next
t-syu           # t-update + t-test + t-boot (safe update, set for next boot)
t-check         # nix flake check

dry tests
t-dry           # dry build, see if it actually builds
t-test          # t-check + t-dry (safe pre-switch/boot check)

git
t-status        # git status for ~/Projects/termina
t-log           # recent commits for ~/Projects/termina
t-pull          # git pull --ff-only in ~/Projects/termina
t-commit "msg"  # stage + commit all changes in ~/Projects/termina
t-push          # git push in ~/Projects/termina
t-backup        # push main to origin + rond + codeberg
t-pushall       # alias for t-backup

dns
t-dns-relax i   # temporary DNS relax for captive portals (runtime-only)
t-dns-revert i  # revert DNS relax for an interface
```


