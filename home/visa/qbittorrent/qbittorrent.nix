{ config, lib, pkgs, ... }:

{
  # qbittorrent config + search plugins
  home.activation.qbittorrentConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    qb_dir="$HOME/.config/qBittorrent"
    data_dir="$HOME/.local/share/qBittorrent"
    engines_dir="$data_dir/nova3/engines"
    conf="$qb_dir/qBittorrent.conf"
    secrets="${config.home.homeDirectory}/Projects/termina/secrets/qBittorrent.secrets.conf"
    $DRY_RUN_CMD mkdir -p "$engines_dir"

    if [ ! -e "$conf" ]; then
      $DRY_RUN_CMD install -m 600 ${./qBittorrent.conf} "$conf"
    fi

    if [ -f "$secrets" ]; then
      ${pkgs.python3}/bin/python3 - "$conf" "$secrets" <<'PY'
import re, sys
from pathlib import Path

conf_path = Path(sys.argv[1])
secrets_path = Path(sys.argv[2])
conf = conf_path.read_text()
secrets = secrets_path.read_text().splitlines()

section = None
pending = []  # (section, key, full_line)
for raw in secrets:
    line = raw.rstrip('\n')
    if not line or line.lstrip().startswith('#') or line.lstrip().startswith(';'):
        continue
    m = re.match(r'^\[(.*)\]\s*$', line)
    if m:
        section = m.group(1)
        continue
    if '=' in line and section:
        key = line.split('=', 1)[0].strip()
        pending.append((section, key, line))

for sec, key, full_line in pending:
    sec_re = re.compile(r'(?ms)^\[' + re.escape(sec) + r'\]\n(.*?)(?=^\[|\Z)')
    m = sec_re.search(conf)
    key_re = re.compile(r'(?m)^' + re.escape(key) + r'=.*$')
    if m:
        block = m.group(0)
        if key_re.search(block):
            block = key_re.sub(full_line, block, count=1)
        else:
            block = block.rstrip('\n') + '\n' + full_line + '\n'
        conf = conf[:m.start()] + block + conf[m.end():]
    else:
        conf = conf.rstrip() + f'\n\n[{sec}]\n{full_line}\n'

conf_path.write_text(conf)
PY
    fi

    # search plugins
    $DRY_RUN_CMD chmod -R u+w "$engines_dir" 2>/dev/null || true
    $DRY_RUN_CMD cp -r ${./nova3/engines}/. "$engines_dir"/
    $DRY_RUN_CMD chmod -R u+w "$engines_dir"
  '';
}
