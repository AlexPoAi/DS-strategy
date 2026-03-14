# Project Brain — Экзокортекс

> Единый мозг проекта. Читается при Открытии сессии.
> Обновляется через close-task.sh.

---

## Что это

Персональный экзокортекс:
- Собирает мысли из Obsidian
- Обрабатывает через агентов
- Формализует знания в Pack (VK-offee)
- Планирует через стратега
- Синхронизирует в GitHub

---

## Архитектурные решения

**Wrapper для strategist:** `strategist-wrapper.sh` переопределяет `CLAUDE_PATH` (FMT хардкодит путь).

**Scheduler — диспетчер:** Координирует агентов через маркеры в `~/.local/state/exocortex/`.

**.nocloud не пушится:** Obsidian vault = сырые мысли (локально). Очищенное → `creativ-convector` (GitHub).

**Pack = source-of-truth:** VK-offee — единственное место формализованных знаний. Downstream следует за Pack.

---

## Статус агентов

| Агент | Статус | Расписание |
|-------|--------|-----------|
| `scheduler` | ✅ | 10 раз/день |
| `strategist.morning` | ✅ | 4:00 ежедн. |
| `strategist.weekreview` | ✅ | Пн 00:00 |
| `extractor.inbox-check` | ✅ | каждые 3ч |
| `extractor.session-watcher` | ✅ | каждые 5 мин |

**Критично:** Все требуют OAuth. При сбросе → `claude /login`.

---

## Ключевые пути

```
~/Github/DS-strategy/current/SESSION-CONTEXT.md
~/Github/DS-strategy/current/WeekPlan*.md
~/Github/DS-strategy/inbox/captures.md
~/Github/close-task.sh
~/.local/state/exocortex/
```

---

## Интеграции

| Что | Статус |
|-----|--------|
| Obsidian → GitHub | ✅ sync_obsidian.sh |
| Telegram бот | ✅ VK-offee-rag |
| Google Drive | ✅ sync_google_drive.py |

---

**Обновлено:** 2026-03-14
