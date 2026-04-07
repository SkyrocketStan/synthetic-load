# synthetic-load v1.0.1 (2026-04-07)

Простая утилита для генерации постоянной синтетической нагрузки CPU и RAM.  
Нужна, чтобы проверить, как Zabbix/Grafana и другие системы мониторинга реагируют на стабильную нагрузку.

## Быстрая установка (рекомендовано)
```bash
cd ~
git clone https://github.com/SkyrocketStan/synthetic-load.git
cd synthetic-load
./install.sh
```
`install.sh` сам сделает `chmod +x` и создаст сервис.

## Ручная установка (если не хочешь пользоваться install.sh)

```bash
cd ~
git clone https://github.com/SkyrocketStan/synthetic-load.git
cd synthetic-load

# !ВАЖНО! Делаем скрипт исполняемым
chmod +x synthetic_load.py

# создаём user-сервис
mkdir -p ~/.config/systemd/user

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

systemctl --user daemon-reload
systemctl --user enable --now synthetic-load.service

# !ВАЖНО! Включаем автономный режим, чтобы процесс не останавливался после закрытия консоли
bashloginctl enable-linger $USER
```

## Настройка нагрузки
Правим две строчки в начале файла `synthetic_load.py`:
```python
TARGET_CPU_PERCENT = 12   # сколько % от всех ядер
TARGET_RAM_PERCENT = 8    # сколько % от всей RAM
```
После правки:
```bash
systemctl --user restart synthetic-load.service
```

## Проверка
```bash
systemctl --user status synthetic-load.service
top | grep python
free -h
```

## Удаление
```bash
systemctl --user stop synthetic-load.service
systemctl --user disable synthetic-load.service
# !ВАЖНО! Отключайте linger только если он не используется для других ваших процессов!!
loginctl disable-linger $USER
rm ~/.config/systemd/user/synthetic-load.service
systemctl --user daemon-reload

# либо просто одной командой из каталога:
~/synthetic-load/uninstall.sh
```
