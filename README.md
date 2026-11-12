# termina

personal nixos config using home manager and flakes

## layout
```
.
├── assets/
│   ├── nvim-logo.png
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
t-switch   # rebuild and switch now
t-boot     # rebuild and set it for next boot (doesnt switch right away)
t-update   # update flake inputs (flake.lock)
t-syu      # t-update + t-boot
t-dry      # dry build, see if it actually builds
t-clean    # clean old generations (>30d) and free space
t-backup   # push to origin + rond + codeberg
t-pushall  # alias for t-backup
```

### nvim
```text
<Space>       leader
<C-s>         save
<C-p>         find files
<C-f>         search in files (live grep)
<C-b>         toggle file explorer
<S-h>/<S-l>   previous/next buffer
<C-h/j/k/l>   move between windows
<Esc>         clear search highlight

<leader>e     toggle file explorer
<leader>ff    find files
<leader>fg    live grep
<leader>fb    buffers
<leader>fh    help
<leader>bd    close buffer
<leader>xx    diagnostics (Trouble)
<leader>t     toggle terminal
```

usually its just `t-switch` after changing stuff, or `t-update` then `t-switch` if i want to update everything. if i want to be safe i do `t-boot` / `t-syu` and reboot into it.
