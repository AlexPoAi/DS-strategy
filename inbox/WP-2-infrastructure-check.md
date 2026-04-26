---
type: wp-context
wp_id: W09-2
status: pending
created: 2026-03-02
budget: 3h
---

# РП#2: Проверка и валидация инфраструктуры экзокортекса

## Цель

Убедиться что вся инфраструктура FMT развёрнута корректно, агенты работают, данные поступают.

## Артефакт

Отчёт о состоянии системы + исправленные конфиги (если нужно).

## Проверки

### 1. FMT-exocortex-template

- [ ] Проверить версию репо (`git log -1`)
- [ ] Проверить обновления (`git fetch && git status`)
- [ ] Проверить что все плейсхолдеры `{{WORKSPACE_DIR}}` заменены
- [ ] Проверить структуру roles/ (strategist, extractor, synchronizer)

### 2. Агенты launchd

Проверить статус всех агентов:
```bash
launchctl list | grep -E "(strategist|extractor|scheduler)"
```

Ожидаемые агенты:
- `com.exocortex.scheduler` — центральный диспетчер
- `com.strategist.morning` — утренний стратег
- `com.strategist.weekreview` — недельный обзор
- `com.extractor.inbox-check` — обработка captures
- `com.extractor.session-watcher` — импорт сессий

### 3. Поставка данных Google Drive → экстрактор

- [ ] Проверить `com.vkoffee.sync` (launchctl list)
- [ ] Проверить последний запуск (`~/Github/VK-offee/.github/scripts/auto-sync.sh`)
- [ ] Проверить логи синхронизации
- [ ] Тестовый файл в Google Drive → проверить появление в VK-offee

### 4. Поставка данных Obsidian → экстрактор

- [ ] Проверить `com.obsidian.sync` (launchctl list)
- [ ] Проверить Obsidian human-layer и актуальный маршрут заметок
- [ ] Тестовая заметка в Obsidian → проверить появление в `Творческий конвеер`
- [ ] Проверить цепочку: Obsidian → `Творческий конвеер` → `DS-strategy/inbox/captures.md`

### 5. Логика работы

- [ ] Scheduler читает маркеры из `~/.local/state/exocortex/`
- [ ] Extractor обрабатывает captures из `DS-strategy/inbox/captures.md`
- [ ] Session-watcher импортирует из `DS-strategy/inbox/pending-sessions/`
- [ ] Routing работает корректно (5 Pack: bar, kitchen, service, management, hr)

## Известные проблемы (из project-brain.md)

- Synchronizer: `daily-report.sh` и `code-scan.sh` не тестировались
- Telegram уведомления: требуют `.config/aist/env`
- WakaTime: опционально, пропускается если не настроен

## Чек-лист

- [ ] Проверить FMT репо
- [ ] Проверить статус всех агентов
- [ ] Проверить Google Drive sync
- [ ] Проверить Obsidian sync
- [ ] Проверить логику работы
- [ ] Создать отчёт
- [ ] Исправить найденные проблемы (если есть)
- [ ] Коммит + push
