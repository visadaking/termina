{ config, lib, pkgs, ... }:

{
  # Persist qBittorrent configuration (theme/UI/session preferences) and search
  # engine plugins declaratively while keeping sensitive material out of the repo
  # (WebUI password hash, cookies).
  #
  # IMPORTANT: do not overwrite an existing live config on activation — qBittorrent
  # stores sensitive/runtime state in it (WebUI password hash, cookies, etc.). The
  # sanitized repo snapshot is installed only if no config exists yet. Search
  # engine plugins are refreshed from the repo snapshot.
  home.activation.qbittorrentConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    qb_dir="$HOME/.config/qBittorrent"
    engines_dir="$qb_dir/nova3/engines"
    $DRY_RUN_CMD mkdir -p "$engines_dir"
    if [ ! -e "$qb_dir/qBittorrent.conf" ]; then
      $DRY_RUN_CMD install -m 600 ${./qBittorrent.conf} "$qb_dir/qBittorrent.conf"
    fi

    # Search engine plugins
    $DRY_RUN_CMD chmod -R u+w "$engines_dir" 2>/dev/null || true
    $DRY_RUN_CMD cp -r ${./qBittorrent/nova3/engines}/. "$engines_dir"/
    $DRY_RUN_CMD chmod -R u+w "$engines_dir"
  '';
}
