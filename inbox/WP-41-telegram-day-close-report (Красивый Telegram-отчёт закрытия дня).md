---
type: work-product
id: WP-41
status: in_progress
created: 2026-03-30
domain: exocortex-engineering
budget: 1.5h
---

# WP-41: Красивый Telegram-отчёт закрытия дня

## Контекст

Сейчас при закрытии дня бот присылает нечитаемый raw-лог с крякозябрами и экранированными `\n`. Нужен форматированный русский отчёт.

## Цель

Красивое человекочитаемое сообщение в Telegram при закрытии дня.

## Формат отчёта

```
🔒 Закрытие дня ДД.ММ

✅ Что сделано:
- [список из SESSION-CONTEXT]

🟢/🟡/🔴 Состояние системы:
- Агенты: [статус]
- Scheduler: [статус]

🔜 На завтра (топ-3):
- [из INBOX]
```

## Что нужно сделать

1. Обновить `daily-report.sh` — форматировать вывод для Telegram
2. Убрать технические детали (exit codes, пути)
3. Добавить эмодзи и разделы
4. Протестировать отправку

## Файлы

- `FMT-exocortex-template/roles/synchronizer/scripts/daily-report.sh`
- `DS-strategy/current/SESSION-CONTEXT.md` (источник данных)
- `DS-strategy/inbox/INBOX-TASKS.md` (топ-3 на завтра)

## Статус

- [x] РП создан
- [ ] Прочитан текущий daily-report.sh
- [ ] Добавлено форматирование
- [ ] Протестирована отправка
- [ ] Закрыто через close-task.sh
