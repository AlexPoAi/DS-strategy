---
type: work-package-context
id: WP-24
created: 2026-03-24
status: in_progress
budget: 2h
depends_on: WP-23
---

# РП#24: Failure state machine и truthful status semantics

## Почему это отдельный РП

После WP-23 карта контура собрана, но сама система статусов всё ещё недостаточно формализована. Пока нет явной state machine, зелёный статус может появляться из-за exit code, старого артефакта или частично завершённого сценария. Нужна единая семантика состояний для всех стадий runtime-контура.

## Цель

Задать **единый набор состояний и переходов**, по которым strategist / extractor / scheduler / status-artifacts должны оценивать реальное состояние системы, а не только факт запуска команды.

## Базовые состояния

| State | Смысл | Когда ставится |
|------|-------|----------------|
| `not-run` | шаг ещё не запускался в текущем окне наблюдения | нет evidence запуска |
| `running` | шаг запущен и ещё не завершён | есть lock / активный процесс / свежий start log |
| `success-verified` | шаг завершён и есть подтверждённый артефакт | exit code + artifact + freshness + semantic checks |
| `success-unverified` | команда завершилась без ошибки, но доказательство неполное | есть `0`, но нет полного evidence layer |
| `partial` | выполнена только часть ожидаемого контура | часть артефактов создана, часть отсутствует |
| `failed` | сценарий завершился ошибкой | non-zero exit / явный error marker |
| `stale` | когда-то был успех, но он устарел для текущего окна | артефакт старый, lock старый, report из прошлого окна |
| `stuck` | шаг завис и не переходит ни в успех, ни в fail | lock/queue/process живут дольше допустимого окна |
| `blocked` | шаг не может быть выполнен из-за внешнего блокера | auth/billing/network/dependency/downstream block |
| `skipped` | шаг был пропущен по явному правилу | intentional skip с recorded reason |

## Truthful semantics по состояниям

### 1. `success-verified`
Зелёный статус допустим **только** при выполнении всех условий:
1. сценарий реально запускался в текущем окне наблюдения;
2. нет активного stale lock;
3. exit code не сигнализирует об ошибке;
4. создан expected artifact для этой стадии;
5. artifact семантически валиден (не пустой, не старый snapshot, не след от прошлого окна);
6. downstream stage может опираться на результат.

### 2. `success-unverified`
Жёлтый статус. Используется, когда команда выглядит успешной, но evidence неполный:
- есть только exit code `0`;
- есть лог завершения, но нет expected artifact;
- есть artifact, но нет проверки freshness или содержательной валидности.

### 3. `partial`
Жёлтый/красный в зависимости от критичности стадии. Примеры:
- strategy session увидела 18 заметок, но разложила только 12;
- `session-import` создал captures, но `session-tasks` не записал задачи;
- close-flow обновил commit, но не обновил `SESSION-CONTEXT.md`.

### 4. `stale`
Отдельная truthful-категория. Нельзя трактовать как success.
Примеры:
- `AGENTS-STATUS.md` зелёный, но построен вчера;
- status-file не обновлялся в текущем окне;
- старый `SchedulerReport` показывает успех сценария, который сегодня не запускался.

### 5. `stuck`
Состояние для зависших очередей и lock’ов:
- файл остаётся в `pending-sessions/` дольше SLA;
- lock существует дольше ожидаемого времени сценария;
- есть start log без finish/evidence.

### 6. `blocked`
Состояние для внешней невозможности выполнения. Подтипы:
- `blocked/auth`
- `blocked/billing`
- `blocked/network`
- `blocked/dependency`
- `blocked/manual-gate`

## Переходы состояний

```text
not-run -> running
running -> success-verified
running -> success-unverified
running -> partial
running -> failed
running -> stuck
not-run -> skipped
not-run -> blocked
success-verified -> stale
success-unverified -> stale
partial -> stale
blocked -> running
stuck -> running
```

## Правила verdict layer

| Verdict | Разрешённые states |
|--------|---------------------|
| Зелёный | только `success-verified` |
| Жёлтый | `success-unverified`, `partial`, `stale`, `blocked/manual-gate`, кратковременный `running` |
| Красный | `failed`, `stuck`, `blocked/auth`, `blocked/billing`, `blocked/network`, критический `partial` |

## Привязка к стадиям WP-23

| Стадия | Минимум для `success-verified` |
|--------|--------------------------------|
| Intake note discovery | заметка найдена в `.nocloud` и отражена в session input |
| Strategy session | каждая найденная заметка классифицирована либо попала в manual-review/error |
| Pending session queue | session file появился в `pending-sessions/` |
| Session import | есть новые captures и session file перемещён в processed |
| Session tasks | есть новая секция задач в `INBOX-TASKS.md` по дате сессии |
| Inbox-check | создан новый extraction report и captures получили processed mark |
| Status layer | status store + AGENTS-STATUS + SESSION-OPEN + SchedulerReport согласованы между собой |
| Close-flow | есть commit/push + обновлённый `SESSION-CONTEXT.md` |

## Основные нарушения truthful semantics

1. **Exit code illusion** — `0`, но expected artifact отсутствует.
2. **Artifact illusion** — файл есть, но он stale.
3. **Queue illusion** — upstream завершён, но downstream завис без эскалации.
4. **Detached success** — локальный шаг успешен, но не доставлен в следующий контур.
5. **Inherited green** — старый зелёный статус переживает новое окно наблюдения.
6. **Close illusion** — commit есть, но close-flow не завершил полный протокол.

## Что должно измениться после WP-24

- scheduler, health-check, daily-report и session-open используют единый словарь состояний;
- зелёный verdict невозможен без `success-verified`;
- stale/partial/stuck больше не маскируются под success;
- любой следующий safeguard в WP-25 опирается на эту state machine, а не на разрозненные эвристики.

## Критерий завершения WP-24

- Есть единая state machine для runtime-контура
- Есть truthful semantics для каждого класса состояний
- Определено, когда возможен зелёный verdict
- Определены ключевые переходы состояний
- WP-24 становится входом для WP-25 (safeguards)

## Следующий РП

**WP-25** — safeguards: stale-lock recovery, stuck-queue detection, bounded retry, canaries и escalation ladder.
