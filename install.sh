#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Создаем директорию для пользовательских юнитов
mkdir -p ~/.config/systemd/user

# 2. Создаем файл сервиса
cat > ~/.config/systemd/user/synthetic-load.service <<EOF
[Unit]
Description=Synthetic CPU/RAM load for monitoring testing

[Service]
# Указываем тип simple, чтобы systemd сразу считал сервис запущенным
Type=simple
ExecStart=$DIR/synthetic_load.py
Restart=always
RestartSec=30

[Install]
# default.target позволяет сервису стартовать вместе с пользовательским systemd
WantedBy=default.target
EOF

# 3. Делаем исполняемым сам скрипт нагрузки
chmod +x "$DIR/synthetic_load.py"

# 4. ВКЛЮЧАЕМ LINGERING (самое важное)
# Это позволяет пользовательскому systemd работать, когда вы не залогинены
loginctl enable-linger "$USER"

# 5. Перезагружаем конфигурацию и запускаем
systemctl --user daemon-reload
systemctl --user enable --now synthetic-load.service

echo "-------------------------------------------------------"
echo "✅ Сервис synthetic-load.service запущен и включён."
echo "✅ Включен режим 'linger' (процесс не умрет при выходе из SSH)."
echo "Проверка статуса: systemctl --user status synthetic-load.service"
echo "-------------------------------------------------------"
