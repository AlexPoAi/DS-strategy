---
id: WP-90
title: "Knowledge Registry Curator SRT-aware upgrade"
status: done
priority: high
owner: "Strategist + Knowledge Registry Curator"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После `WP-87` и `WP-88` стало ясно, что `Knowledge Registry Curator` уже полезен как registry/handoff слой, но ему не хватает тонкого `SRT`-слоя раскладки.

При этом было важно не нарушить границы:
- не превратить `SRT` в source-of-truth;
- не отдать Библиотекарю методологию domain boundaries;
- не перебить `Extractor`, `Strategist` и профильных доменных агентов.

# Цель

Сделать `Knowledge Registry Curator` `SRT-aware` минимальным и безопасным способом:
- добавить `srt_slot` в skill и контракт агента;
- зафиксировать `SRT` как placement layer;
- не расширять агента до методологического владельца границ домена.

# Что изменено

## Skill

В `notes-registry-and-domain-mapping` добавлено:
- поле `srt_slot`;
- дополнительный результат `SRT Placement View`;
- режим `place into SRT`;
- guardrail, что `SRT` не задаёт domain/subdomain boundaries;
- правило `needs-review`, если placement спорный;
- дополнительные поля для domain-pilot:
  - `coverage_state`
  - `primary_source`

## Агент

В карточке `Knowledge Registry Curator` зафиксировано:
- агент строит `SRT`-aware placement view;
- агент не использует `SRT` как source-of-truth;
- агент не утверждает финальные domain/subdomain boundaries из матрицы.

# Truthful Verdict

Апгрейд сделан узко и по делу:
- `Curator` стал `SRT-aware`;
- `Curator` не стал `SRT-agent`;
- `Curator` не стал владельцем `FPF/SPF`;
- границы доменов по-прежнему удерживаются выше, а `SRT` используется как рабочая матрица раскладки.

# Interference Check

## Что не сломано

- `Extractor` остаётся upstream ingestion-слоем.
- `Strategist` остаётся владельцем weekly decisions.
- `FPF / SPF / SRT` не смешаны в один operational agent.
- `Knowledge Registry Curator` по-прежнему registry/handoff слой, а не монстр-агент.

# Acceptance

1. В skill агента появился `srt_slot`.
2. Появился явный `SRT Guardrail`.
3. В карточке агента зафиксировано, что `SRT` — placement layer, а не source-of-truth.
4. Апгрейд не расширил роль за безопасные границы.

# Следующий шаг

1. Прогнать следующий живой domain-slice уже с `srt_slot`.
2. После этого решить, переносится ли модель с `Park` на другие домены.
