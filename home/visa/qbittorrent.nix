{ config, lib, pkgs, ... }:

{
  # Persist qBittorrent configuration (theme/UI/session preferences) and search
  # engine plugins declaratively while keeping sensitive material out of the repo
  # (WebUI password hash, cookies). Written as regular files (not nix-store
  # symlinks) so qBittorrent can update them at runtime.
  home.activation.qbittorrentConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    qb_dir="$HOME/.config/qBittorrent"
    engines_dir="$qb_dir/nova3/engines"
    $DRY_RUN_CMD mkdir -p "$engines_dir"
    $DRY_RUN_CMD install -m 600 ${./qBittorrent.conf} "$qb_dir/qBittorrent.conf"

    # Search engine plugins
    $DRY_RUN_CMD chmod -R u+w "$engines_dir" 2>/dev/null || true
    $DRY_RUN_CMD cp -r ${./qBittorrent/nova3/engines}/. "$engines_dir"/
    $DRY_RUN_CMD chmod -R u+w "$engines_dir"
  '';
}
