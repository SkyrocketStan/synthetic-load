#!/usr/bin/env bash
# Не используем set -e для удаления, чтобы скрипт не падал, если сервис уже удален
set -u 

echo "Остановка и удаление сервиса synthetic-load.service..."

# 1. Останавливаем и отключаем сервис
systemctl --user stop synthetic-load.service 2>/dev/null || true
systemctl --user disable synthetic-load.service 2>/dev/null || true

# 2. Удаляем файл юнита
rm -f ~/.config/systemd/user/synthetic-load.service

# 3. ПЕРЕЗАГРУЖАЕМ КОНФИГУРАЦИЮ (чтобы systemd забыл о сервисе)
systemctl --user daemon-reload

# 4. ОТКЛЮЧАЕМ LINGERING (чтобы не оставлять фоновые процессы пользователя)
loginctl disable-linger "$USER"

echo "-------------------------------------------------------"
echo "✅ Сервис synthetic-load.service полностью удалён."
echo "✅ Режим 'linger' отключён для пользователя $USER."
echo "Каталог проекта можно удалить командой: rm -rf ~/synthetic-load"
echo "-------------------------------------------------------"
