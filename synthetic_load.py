#!/usr/bin/env python3
"""
Synthetic CPU/RAM load generator v1.0.0 (2025-11-27)
Используется для постоянной фоновой нагрузки при тестировании систем мониторинга.
"""

# === НАСТРОЙКИ — меняй только здесь ===
TARGET_CPU_PERCENT = 12   # сколько процентов от всех ядер
TARGET_RAM_PERCENT = 8    # сколько процентов от всей оперативки
# ======================================

import os
import time
from multiprocessing import Pool, Process


def total_ram_mb() -> int:
    """Возвращает объём RAM в МБ из /proc/meminfo."""
    with open("/proc/meminfo") as f:
        for line in f:
            if line.startswith("MemTotal:"):
                return int(line.split()[1]) // 1024
    return 64000


def burn_cpu() -> None:
    """100 % нагрузка на одно ядро."""
    while True:
        os.sched_yield()


def eat_ram(mb: int) -> None:
    """Занимает примерно mb мегабайт и держит до конца процесса."""
    chunks = [b"x" * 1024 * 1024 for _ in range(mb)]
    while True:
        time.sleep(3600)


def main() -> None:
    cpus = os.cpu_count() or 1
    ram_mb = total_ram_mb()

    workers = max(1, round(cpus * TARGET_CPU_PERCENT / 100))
    ram_to_eat = int(ram_mb * TARGET_RAM_PERCENT / 100)

    print(f"Сервер: {cpus} ядер, {ram_mb // 1024} ГБ RAM")
    print(f"Запускаю синтетическую нагрузку:")
    print(f"  • {workers} CPU-процессов → ~{TARGET_CPU_PERCENT}%")
    print(f"  • {ram_to_eat // 1024} ГБ RAM → ~{TARGET_RAM_PERCENT}%")

    # CPU
    pool = Pool(workers)
    for _ in range(workers):
        pool.apply_async(burn_cpu)

    # RAM
    Process(target=eat_ram, args=(ram_to_eat,)).start()

    # держим основной процесс живым
    try:
        while True:
            time.sleep(3600)
    except KeyboardInterrupt:
        print("\nОстановка по Ctrl+C")
        pool.terminate()


if __name__ == "__main__":
    main()
