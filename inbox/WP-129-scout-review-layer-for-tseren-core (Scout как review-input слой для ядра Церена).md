---
type: work-product
id: WP-129
status: in_progress
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

1. Проверить текущий route запуска и review-маршрут `Scout`.
2. Описать целевой контракт `Scout` как input-layer.
3. Довести это до рабочего локального решения без конкуренции с ядром Церена.
