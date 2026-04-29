---
name: Google Drive VK-offee — карта папок
description: Карта папок Google Drive для агентов работающих с VK-offee и DS-finance. Ссылки вставлять прямо в Pack-артефакты.
type: reference
valid_from: 2026-04-29
---

# Google Drive VK-offee — карта папок для агентов

> **Принцип:** при заполнении предметной области (Pack-артефакты) вставлять ссылку на Drive-папку прямо в карточку объекта — чтобы агент мог сразу перейти к источнику.

## Основные папки

| Папка | Ссылка | Что внутри |
|-------|--------|-----------|
| **Для бота (Жанна / Саби)** | https://drive.google.com/drive/folders/1sGGcG1DBHIMMhZFvPGd_gGOesncQwhiq | Каталог, Накладные, Продажи из Сабы |
| **Продажи** | https://drive.google.com/drive/folders/1g2Pq-cYVT2cSkd9DwBCV-EJBHYDvzHw9 | Отчёты по продажам (xlsx) — основная папка для Finance View |
| **Выручка** | https://drive.google.com/drive/folders/1_h1AGeNaiYmxVOdT3MhCUPWgZsoNac87 | Выручка_YYYY-MM-DD_YYYY-MM-DD.xlsx |
| **Накладные** | https://drive.google.com/drive/folders/1R7W_w63Q4KLKiu69IHS4Y_tp4e2yQzyh | Накладные от поставщиков |
| **Остатки** | https://drive.google.com/drive/folders/1ckRPlBYp8P-3k1n292h05p-33VHvFVD | Остатки товаров |
| **Каталог** | https://drive.google.com/drive/folders/10ZsI-NnUjlFhdG5TywxWyRtbHPsMw1gN | Номенклатура из Сабы |
| **Отчётность** | https://drive.google.com/drive/folders/1H87ILIGlN1hzJ4m7RzPZ-wIMzPZHK8sX | Скринкасты Жанны: продажи, каталог, выручка (.mov) |
| **Инвентаризация** | https://drive.google.com/drive/folders/1KlHYcGweVKH3aKhx9vwKLqTjBRv-qF1M | Инвентаризация |
| **Складской учёт** | https://drive.google.com/drive/folders/1Nlhznoe_1rbaHZWMEgZtyWRXsQRW_V_7 | Складской учёт |
| **Решение вопросов Саби/касса** | https://drive.google.com/drive/folders/1799xAotd8FZoltw-tadZF_dyBRkjflB9 | Обучающие скринкасты по работе в Сабе |
| **Парк** | https://drive.google.com/drive/folders/1-E-pWBQni6Bv2TFAgLOOl3lWMXU9l9lk | Документы проекта Парк (canonical) |
| **СПОЗУ** | https://drive.google.com/drive/folders/1XzkHwn8DCoSkMWNHI22DaUjVpdXgqABA | Скриншоты СПОЗУ 29 апр |

## Техническое

**Реестр документов (Google Sheets):**
https://docs.google.com/spreadsheets/d/14PxApr1x8iHuD-ioCzYjpRoaEJw_7iYWKjPAkpaOvsM/edit?gid=0#gid=0

**Credentials:** `VK-offee/.github/scripts/credentials.json`
**Token (read):** `VK-offee/.github/scripts/token.pickle`
**Token (write/upload):** `VK-offee/.github/scripts/token_upload.pickle`
**Скрипт чтения:** `VK-offee/saby-integration/google_drive_parser.py`
**Скрипт загрузки:** `VK-offee/.github/scripts/upload_to_google_drive.py`
