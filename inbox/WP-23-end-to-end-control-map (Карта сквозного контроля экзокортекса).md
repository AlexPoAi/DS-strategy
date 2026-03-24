---
type: work-package-context
id: WP-23
created: 2026-03-24
status: in_progress
budget: 2h
depends_on: WP-22
---

# РП#23: Карта сквозного контроля экзокортекса

## Почему это отдельный РП

Локальные фиксы больше не подходят. Нужна единая карта всей экосистемы: какие стадии проходит рабочий день, где source-of-truth у каждой стадии, какие артефакты должны появляться, и в каких точках система может выглядеть зелёной при неполном выполнении.

## Цель

Собрать **end-to-end карту runtime-контура** экзокортекса, чтобы дальше стабилизировать систему не фрагментами, а по всей цепочке целиком.

## Контур

### 1. Intake и стратегирование
- `.nocloud` inbox заметок
- sync в `creativ-convector`
- `strategy_session.py`
- `pending-sessions/`

### 2. Extractor pipeline
- `session-watcher`
- `session-import`
- `session-tasks`
- `captures.md`
- `INBOX-TASKS.md`
- `inbox-check`
- `extraction-reports/`

### 3. Runtime orchestration
- `scheduler.sh`
- `health-check.sh`
- `daily-report.sh`
- launchd jobs
- status store `~/.local/state/exocortex/status/`

### 4. Session control
- `AGENTS-STATUS.md`
- `SESSION-OPEN (Экран открытия сессии).md`
- `SchedulerReport YYYY-MM-DD.md`
- `SESSION-CONTEXT.md`
- `close-task.sh`

## Source-of-truth по стадиям

| Стадия | Source-of-truth | Доказательство выполнения |
|--------|------------------|---------------------------|
| Появились новые заметки | `.nocloud/1. Исчезающие заметки/` | файл физически существует |
| Заметки увидены сессией | `strategy_session.py` + session file | счётчик найденных заметок + session file |
| Заметки разложены | `creativ-convector/2. Черновики/` | каждая заметка либо в проекте, либо в manual-review, либо в error |
| Сессия ушла в extractor | `DS-strategy/inbox/pending-sessions/` | session file в очереди |
| Session import выполнен | `captures.md` + `processed-sessions/` | новые captures + перемещение session file |
| Session tasks выполнен | `INBOX-TASKS.md` | секция задач с source по дате сессии |
| Inbox-check выполнен | `extraction-reports/` + processed marks в `captures.md` | новый extraction report |
| Runtime truthful | status store + `AGENTS-STATUS` + `SESSION-OPEN` + `SchedulerReport` | verified status, а не только exit code |
| Закрытие итерации | `close-task.sh` + `SESSION-CONTEXT.md` | commit/push + обновлённый контекст |

## Основные failure modes

1. **Silent skip intake** — заметка есть в `.nocloud`, но не попала в runtime-контур.
2. **Partial strategy session** — session file создан, но часть заметок не разложена и не вынесена в manual-review.
3. **Watcher gap** — сессия зависла в `pending-sessions/`.
4. **Knowledge/task asymmetry** — captures появились, а задачи не попали в `INBOX-TASKS.md`.
5. **Exit code without evidence** — сценарий завершился `0`, но артефакт не появился.
6. **Stale green** — статус унаследован от прошлого окна и выглядит успешным.
7. **Close-flow false success** — задача объявлена закрытой, но контекст/коммиты не зафиксированы.

## Критерий завершения WP-23

- Есть единая end-to-end карта контура
- Для каждой стадии указан source-of-truth
- Для каждой стадии указан expected artifact
- Зафиксированы основные failure modes
- Эта карта становится входом для WP-24 (state machine) и WP-25 (safeguards)

## Следующий РП

**WP-24** — failure state machine и truthful status semantics для всех стадий контура.
