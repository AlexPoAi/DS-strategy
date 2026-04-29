---
type: work-product
id: WP-129
status: done
priority: high
created: 2026-04-29
updated: 2026-04-29
owner: Engineer
domain: exocortex
approved: true
---

# WP-129 — Scout как review-input слой для ядра Церена

## Почему открыто

После закрытия `WP-127` и `WP-128` стало ясно:

- ядро приоритетов должно оставаться у Церена: `Strategist -> DayPlan -> WeekPlan -> Требует внимания`;
- `Scout` не должен строить параллельную доску приоритетов;
- при этом `Scout` по-прежнему нужен как слой review/input для этого ядра.

Пользователь явно подтвердил целевую архитектуру:

`Scout -> review/input -> Strategist core -> DayPlan/WeekPlan/Attention`

## Truthful factual finding на старте

- `Scout` у Церена и у нас не является обязательным core-runtime сервисом;
- локальный `Scout` живёт в `DS-agent-workspace/scout`;
- последний живой отчёт и analytics stale (`2026-03-23`, `2026-03-24`);
- текущий human-layer больше не должен опираться на `Доску выбора` как на competing priority layer.

## Цель

Вернуть `Scout` не как второй центр управления, а как review-agent, который:

- ищет сигналы и находки;
- предлагает captures / WP / attention items;
- кормит каноническое ядро Церена;
- не создаёт собственного competing decision layer.

## Acceptance

- зафиксирован явный контракт роли `Scout`;
- определено, какие его выходы идут в `Strategist`/`DayPlan`, а какие нет;
- принято решение: как именно запускать/ревьюить `Scout` в локальном контуре;
- `Доска выбора` не используется как обязательный источник приоритетов для агентов.

## Следующий шаг

1. Если нужен отдельный operational run, открыть новый bounded WP под `Scout runbook / launcher`.
2. Не расширять этот WP за пределы уже закрытого контрактного slice.

## Progress (2026-04-29)

Первый truthy slice уже materialized:

- подтверждено, что живого template/runtime script для `Scout` сейчас нет;
- значит, на этом шаге его нельзя честно называть обязательным live service;
- в `DS-agent-workspace/scout/README.md` зафиксирован явный контракт `Scout` как review/input слоя;
- в `DS-agent-workspace/CLAUDE.md` добавлено то же различение на уровне репозитория:
  - `Scout -> report/candidates -> Strategist review -> DayPlan / WeekPlan / Требует внимания`
  - без competing priority layer и без прямой записи в `DayPlan`/`WeekPlan`/`MEMORY.md`.

Следующий кусок после этого:

- решить отдельным WP, нужен ли `Scout` ручной runbook/launcher;
- или для локального контура достаточно review ritual + bounded on-demand run.

## Финальное решение

- `Scout` закреплён как `review/input` слой, а не competing priority layer.
- Его выходы идут только через review в ядро Церена: `Strategist -> DayPlan / WeekPlan / Требует внимания`.
- Для текущего bounded slice не требуется live runtime recovery или отдельный launchd-service.

## Итог

РП закрыт как `done`.

Главный результат:

- контракт `Scout` materialized в `DS-agent-workspace/scout/README.md`;
- repo-level различение зафиксировано в `DS-agent-workspace/CLAUDE.md`;
- дальнейший operational launcher, если вообще нужен, выносится в отдельный WP, а не раздувает этот.
