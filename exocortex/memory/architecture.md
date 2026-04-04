# Архитектура экзокортекса (выжимка)

*Обновлено: 2026-02-26*

---

## Репозитории

| Репо | Тип | Роль | Путь |
|------|-----|------|------|
| `FMT-exocortex-template` | Base/Format | Шаблон: скрипты агентов, промпты, launchd-шаблоны. **Только читать** | ~/Github/FMT-exocortex-template |
| `VK-offee` | Pack | Source-of-truth домена кофейни. Всё остальное следует за ним | ~/Github/VK-offee |
| `DS-strategy` | Governance | Стратегический хаб: WeekPlan, SESSION-CONTEXT, inbox, отчёты | ~/Github/DS-strategy |
| `creativ-convector` | Downstream | Творческий конвейер: черновики, сессии стратегирования | ~/Github/creativ-convector |
| `creativ-convector.nocloud` | Local only | Obsidian vault: исчезающие заметки, архив. **Не пушится** | ~/Documents/creativ-convector.nocloud |

---

## Агенты (launchd)

| Агент | Расписание | Скрипт | Что делает | Куда пишет |
|-------|-----------|--------|-----------|-----------|
| `com.exocortex.scheduler` | 10 раз/день | `scheduler.sh dispatch` | Центральный диспетчер. Координирует всех агентов через маркеры в `~/.local/state/exocortex/` | Маркеры состояния |
| `com.strategist.morning` | 4:00 ежедн. | `strategist.sh morning` | Пн→session-prep, Вт-Вс→day-plan. Claude пишет план дня | DS-strategy/ |
| `com.strategist.weekreview` | Пн 00:00 | `strategist.sh week-review` | Обзор прошедшей недели | DS-strategy/ |
| `com.extractor.inbox-check` | каждые 3ч | `extractor.sh inbox-check` | Обрабатывает pending captures → извлекает знания в VK-offee | DS-strategy/inbox/, VK-offee/ |
| `com.extractor.session-watcher` | каждые 5 мин | `session-watcher.sh` | Следит за pending-sessions/, запускает session-import | DS-strategy/inbox/processed-sessions/ |

---

## Поток данных

```
Obsidian (nocloud)
  └─ 1. Исчезающие заметки/
        ↓ strategy_session.py
creativ-convector (GitHub)
  └─ 2. Черновики/{Проект}/{F1-F9}/
  └─ Сессия стратегирования/
        ↓ run_session_import()
DS-strategy/inbox/pending-sessions/
        ↓ session-watcher.sh (5 мин)
extractor.sh session-import
        ↓
DS-strategy/inbox/captures.md
        ↓ extractor.sh inbox-check (3ч)
DS-strategy/inbox/extraction-reports/
VK-offee/ ← знания формализуются в Pack
```

---

## Локально vs Облако

| | Локально | GitHub |
|-|----------|--------|
| Obsidian vault (.nocloud) | ✅ | ❌ |
| Логи ~/logs/ | ✅ | ❌ |
| Маркеры ~/.local/state/exocortex/ | ✅ | ❌ |
| DS-strategy, VK-offee, creativ-convector | ✅ | ✅ |
| FMT-exocortex-template | ✅ | ✅ |

---

## Ключевые пути

```
~/Github/                          — все репо
~/Github/DS-strategy/inbox/        — captures, pending-sessions, extraction-reports
~/Github/DS-strategy/current/      — WeekPlan, SESSION-CONTEXT
~/Documents/creativ-convector.nocloud/ — Obsidian vault
~/logs/strategist/, ~/logs/extractor/, ~/logs/synchronizer/ — логи агентов
~/.local/state/exocortex/          — маркеры состояния scheduler
~/.config/aist/env                 — переменные окружения (Telegram токены и др.)
```

---

## Статус агентов (2026-02-26)

Все 5 агентов — exit 0. Исправлено:
- `{{WORKSPACE_DIR}}` плейсхолдеры в `strategist.sh` и `scheduler.sh`
- `com.exocortex.scheduler` развёрнут впервые
- `extractor inbox-check` перезагружен после OAuth login
