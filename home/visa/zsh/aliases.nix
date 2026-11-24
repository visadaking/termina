# Portable shell aliases shared by zsh and bash.
{ homeDir, ... }:
{
  t-edit = "nvim ${homeDir}/Projects/termina";
  t-check = "nix flake check ${homeDir}/Projects/termina";
  t-dry = "sudo nixos-rebuild dry-build --flake ${homeDir}/Projects/termina#termina";
  t-switch = "sudo nixos-rebuild switch --flake ${homeDir}/Projects/termina#termina";
  t-boot = "sudo nixos-rebuild boot --flake ${homeDir}/Projects/termina#termina";
  t-roll = "sudo nixos-rebuild switch --rollback";
  t-syu = "nix flake update --flake ${homeDir}/Projects/termina && nix flake check ${homeDir}/Projects/termina && sudo nixos-rebuild dry-build --flake ${homeDir}/Projects/termina#termina && sudo nixos-rebuild boot --flake ${homeDir}/Projects/termina#termina";
  t-update = "nix flake update --flake ${homeDir}/Projects/termina";
  t-update-input = "f(){ nix flake lock --update-input \"\${1:?usage: t-update-input <input>}\" ${homeDir}/Projects/termina; }; f";
  t-test = "nix flake check ${homeDir}/Projects/termina && sudo nixos-rebuild dry-build --flake ${homeDir}/Projects/termina#termina";
  t-status = "termina status";
  t-log = "git -C ${homeDir}/Projects/termina log --oneline --decorate -10";
  t-push = "git -C ${homeDir}/Projects/termina push";
  t-backup = "git -C ${homeDir}/Projects/termina push origin main && git -C ${homeDir}/Projects/termina push rond main && git -C ${homeDir}/Projects/termina push codeberg main";
  t-pushall = "t-backup";
  t-pull = "git -C ${homeDir}/Projects/termina pull --ff-only";
  # usage: t-commit "message"  (stages tracked changes in termina repo)
  t-commit = "f(){ git -C ${homeDir}/Projects/termina add -A && git -C ${homeDir}/Projects/termina commit -m \"\${1:?usage: t-commit \\\"message\\\"}\"; }; f";
  # strict DNS kept; temporary captive-portal workaround (runtime-only, no rebuild/degrade). usage: t-dns-relax wlan0
  t-dns-relax = "f(){ i=\${1:?usage: t-dns-relax <iface> (nmcli device status)}; sudo resolvectl dns \"$i\" '' && sudo resolvectl dnsovertls \"$i\" no && sudo resolvectl dnssec \"$i\" no && echo relaxed: $i; }; f";
  t-dns-revert = "f(){ i=\${1:?usage: t-dns-revert <iface>}; sudo resolvectl revert \"$i\" && echo reverted: $i; }; f";
  t-cc = "sudo resolvectl flush-caches";
  fixaudio = "systemctl --user restart wireplumber pipewire pipewire-pulse";
  cls = "clear";
  ff = "fastfetch";
  hy = "hyfetch";

  # wallpapers (runtime switch, Plasma 6)
  wallpaper-ergo = "plasma-apply-wallpaperimage \"${homeDir}/Pictures/Wallpapers/ergo-proxy-kw9yj7-1920x1080.png\"";
  wallpaper-715139 = "plasma-apply-wallpaperimage \"${homeDir}/Pictures/Wallpapers/715139.jpg\"";
  wallpaper-lain-suburban = "plasma-apply-wallpaperimage \"${homeDir}/Pictures/Wallpapers/lain-suburban-cool-blue-wallhaven-xelyx3.jpg\"";
  wallpaper-overcast-powerlines = "plasma-apply-wallpaperimage \"${homeDir}/Pictures/Wallpapers/overcast-suburban-powerlines-wallhaven-d889yo.jpg\"";
  wallpaper-ergo-ne782l = "plasma-apply-wallpaperimage \"${homeDir}/Pictures/Wallpapers/ergo-proxy-ne782l-2500x1406.jpg\"";
}
