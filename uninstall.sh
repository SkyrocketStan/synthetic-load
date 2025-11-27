#!/usr/bin/env bash
set -e

systemctl --user stop synthetic-load.service 2>/dev/null || true
systemctl --user disable synthetic-load.service 2>/dev/null || true
rm -f ~/.config/systemd/user/synthetic-load.service
systemctl --user daemon-reload

echo "Сервис synthetic-load.service удалён."
echo "Каталог ~/synthetic-load можно удалить вручную: rm -rf ~/synthetic-load"
