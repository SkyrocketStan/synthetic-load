# synthetic-load v1.1.0 (2026-04-07)
Простая утилита для генерации постоянной синтетической нагрузки CPU и RAM.  
Нужна, чтобы проверить, как Zabbix/Grafana и другие системы мониторинга реагируют на стабильную нагрузку.

## Быстрая установка (рекомендовано)
```bash
cd ~
git clone https://github.com/SkyrocketStan/synthetic-load.git
cd synthetic-load
chmod +x install.sh
./install.sh
```

install.sh автоматически настроит права доступа, создаст сервис и включит автономный режим работы.

## Ручная установка (без install.sh)
```bash
cd ~
git clone https://github.com/SkyrocketStan/synthetic-load.git
cd synthetic-load

# 1. Делаем скрипт исполняемым
chmod +x synthetic_load.py

# 2. Создаём директорию для пользовательских сервисов
mkdir -p ~/.config/systemd/user

# 3. Создаём файл сервиса
cat > ~/.config/systemd/user/synthetic-load.service <<EOF
[Unit]
Description=Synthetic CPU/RAM load for monitoring testing

[Service]
Type=simple
ExecStart=%h/synthetic-load/synthetic_load.py
Restart=always
RestartSec=30

[Install]
WantedBy=default.target
EOF

# 4. Активируем сервис
systemctl --user daemon-reload
systemctl --user enable --now synthetic-load.service

# 5. ВАЖНО: Включаем автономный режим (Lingering)# Без этого процесс завершится сразу после вашего выхода из консоли (SSH)
loginctl enable-linger $USER
```

## Настройка нагрузки
Измените значения в начале файла synthetic_load.py:
```python
TARGET_CPU_PERCENT = 12   # нагрузка в % от всех ядер
TARGET_RAM_PERCENT = 8    # нагрузка в % от всей доступной RAM
```

После сохранения изменений перезапустите сервис:
```bash
systemctl --user restart synthetic-load.service
```

## Проверка работы
Убедитесь, что сервис активен и создает нагрузку:
```bash
systemctl --user status synthetic-load.service
top | grep python
free -h
```

## Удаление
Для полной очистки системы (включая отключение фонового режима):

```bash
~/synthetic-load/uninstall.sh
```

Или вручную:

```bash
systemctl --user stop synthetic-load.service
systemctl --user disable synthetic-load.service
rm -f ~/.config/systemd/user/synthetic-load.service
systemctl --user daemon-reload
# Отключайте linger, только если он не нужен для других ваших сервисов!
loginctl disable-linger $USER
```
