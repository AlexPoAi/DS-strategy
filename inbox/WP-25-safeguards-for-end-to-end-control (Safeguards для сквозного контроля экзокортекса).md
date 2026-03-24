---
type: work-package-context
id: WP-25
created: 2026-03-24
status: in_progress
budget: 2h
depends_on: WP-24
---

# РП#25: Safeguards для сквозного контроля экзокортекса

## Почему это отдельный РП

WP-23 зафиксировал карту сквозного контроля, а WP-24 задал truthful semantics состояний. Но сама по себе карта и state machine ещё не защищают систему от реальных провалов исполнения. Нужен отдельный слой safeguards: механизмы, которые вовремя замечают зависание, частичное выполнение, ложный успех и пропуск шага, а затем либо безопасно восстанавливают контур, либо поднимают честную тревогу.

## Цель

Собрать **пакет защитных механизмов** для всех критических стадий runtime-контура, чтобы система:
- не молчала при зависании или частичном исполнении;
- не показывала зелёный статус без доказательства;
- не крутилась бесконечно в retry;
- явно эскалировала проблему, если автоматическое восстановление не сработало.

## Какие safeguards нужны

### 1. Контроль stale lock
Если lock живёт дольше допустимого окна сценария, он больше не считается признаком `running`.

Что должно происходить:
- lock сравнивается с допустимым TTL для сценария;
- при превышении TTL состояние переходит в `stale` или `stuck`;
- scheduler/status layer не трактуют такой lock как нормальное выполнение;
- при необходимости запускается safe recovery или поднимается ручная тревога.

### 2. Контроль stuck queue
Любая очередь должна иметь upper bound по времени ожидания.

Примеры:
- session file слишком долго лежит в `pending-sessions/`;
- captures появились, но `inbox-check` не дошёл до extraction report;
- задачи из сессии не попали в `INBOX-TASKS.md`.

Что должно происходить:
- очередь получает возраст элемента;
- при превышении SLA элемент считается stuck;
- stuck queue попадает в status-artifacts как явный красный/жёлтый сигнал;
- для каждого stuck-элемента показывается конкретный backlog item, а не только общий цвет.

### 3. Ограниченный retry
Retry допустим только как bounded mechanism.

Правила:
- повторяем только временные сбои (network, transient API, кратковременный race);
- retry ограничен по числу попыток;
- между попытками должен быть понятный backoff;
- после лимита система переводит шаг в `failed` или `blocked`, а не продолжает бесконечно делать вид, что восстановление ещё идёт.

### 4. Canary-проверки
Критические сценарии должны иметь lightweight проверку “жив ли реальный контур”.

Canary нужен не для того, чтобы просто запустить команду, а чтобы проверить минимальное доказательство жизни:
- strategist morning действительно формирует свежий status artifact;
- note-review действительно проходит путь до evidence;
- session-import действительно создаёт captures;
- session-tasks действительно создаёт секцию задач;
- inbox-check действительно создаёт extraction report.

### 5. Escalation ladder
У системы должен быть явный маршрут эскалации.

```text
аномалия -> warning -> degraded -> critical -> manual action required
```

Смысл:
- warning: что-то пошло неидеально, но цепочка ещё может восстановиться;
- degraded: часть контура работает, часть нет;
- critical: продолжать обычный режим нельзя;
- manual action required: нужен человек, автомат дальше не должен скрытно продолжать попытки.

### 6. Защита от partial execution
Частичное выполнение должно фиксироваться как отдельный failure class, а не как success.

Примеры:
- заметки найдены, но не все классифицированы;
- captures записаны, а tasks потерялись;
- commit есть, а `SESSION-CONTEXT.md` не обновлён;
- сценарий завершился `0`, но downstream artifact не появился.

Что должно происходить:
- partial execution ловится на стыке upstream/downstream;
- статус выставляется как `partial`, а не `success`;
- в артефакте статуса указывается, какой именно шаг не дошёл до expected result.

## Safeguards по стадиям WP-23

| Стадия | Нужный safeguard |
|--------|------------------|
| Intake и strategizing | контроль полного покрытия заметок + manual-review queue |
| Pending sessions | stuck queue detection + возраст session file |
| Session import | проверка, что появились captures и файл сессии ушёл из pending |
| Session tasks | проверка, что появилась секция задач по дате сессии |
| Inbox-check | проверка, что создан extraction report и captures получили processing mark |
| Runtime orchestration | stale lock detection + bounded retry + error classification |
| Status layer | запрет inherited green и обязательная freshness/evidence verification |
| Close-flow | проверка commit/push + обновления SESSION-CONTEXT + truthful dirty-repo detection |

## Что не должно больше происходить

1. **Silent skip** — шаг не выполнился, но никто этого не заметил.
2. **Infinite retry illusion** — сценарий бесконечно пытается восстановиться и маскирует сбой.
3. **Stale running illusion** — старый lock выглядит как активная работа.
4. **Queue invisibility** — backlog растёт, но status layer этого не показывает.
5. **False green after partial** — часть контура умерла, но общий verdict всё ещё зелёный.
6. **Auto-recovery without boundary** — система слишком долго пытается лечить себя без эскалации человеку.

## Операторский смысл WP-25

После этого РП пользователь должен видеть не только цвет статуса, но и:
- где именно контур завис;
- это временный сбой или системный;
- будет ли ещё retry;
- когда требуется ручное действие;
- можно ли продолжать рабочий день или обычный режим уже запрещён.

## Критерий завершения WP-25

- Для ключевых failure modes определены safeguards
- У lock’ов и очередей есть truthful semantics по возрасту
- Retry ограничен и не может идти бесконечно
- Есть escalation ladder до ручного вмешательства
- Partial execution больше не маскируется под success
- WP-25 становится входом для WP-26 (truthful observability)

## Следующий РП

**WP-26** — truthful observability: dashboard, queue counts, backlog visibility, status-artifacts с явным показом stuck/stale/partial состояний.
