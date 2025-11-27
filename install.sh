#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/synthetic-load.service <<EOF
[Unit]
Description=Synthetic CPU/RAM load for monitoring testing

[Service]
Type=simple
ExecStart=$DIR/synthetic_load.py
Restart=always
RestartSec=30

[Install]
WantedBy=default.target
EOF

chmod +x "$DIR/synthetic_load.py"

systemctl --user daemon-reload
systemctl --user enable --now synthetic-load.service

echo "Сервис synthetic-load.service запущен и включён в автозапуск."
echo "Как проверить: systemctl --user status synthetic-load.service"
