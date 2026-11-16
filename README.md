# termina

personal nix config  (flakes + home manager + plasma manager)

## layout 

```text
.
├── assets/
│   ├── feishin/
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
t-edit          # open ~/termina in nvim
t-switch        # rebuild and switch now
t-boot          # rebuild and set it for next boot (doesn't switch right away)
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


