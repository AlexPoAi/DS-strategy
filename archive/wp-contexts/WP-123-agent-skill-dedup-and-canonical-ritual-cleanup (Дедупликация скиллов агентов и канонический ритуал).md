---
type: work-plan
wp_id: 123
title: Дедупликация скиллов агентов и канонический ритуал
created: 2026-04-27
status: done
owner: Environment Engineer
support:
  - DS-agent-workspace
  - PACK-agent-skills
domain: exocortex-governance
mode: ritual-cleanup
---

# WP-123 — Дедупликация скиллов агентов и канонический ритуал

## Зачем открыт

В контуре агентных правил накопились пересекающиеся ритуалы:

- `AGENT.SKILL.001` уже задает канонический инженерный цикл;
- `AGENT.SKILL.003` дублирует bounded `WP` и truthful closeout;
- `agency/skills/environment-engineer/bounded-work-product-ritual.md` повторяет тот же контракт в локальном слое.

Из-за этого ритуал не усиливается, а размывается.

## Цель slice

Оставить один канонический инженерный ритуал, удалить дубли и перевести ссылки на один source of truth.

## Что входит в scope

- сравнить `AGENT.SKILL.001`, `AGENT.SKILL.003` и локальный bounded ritual;
- перенести недостающие полезные правила в канонический skill, если они правда нужны;
- удалить дублирующиеся skill-файлы;
- обновить ссылки в manifest и role-card.

## Что не входит в scope

- создание новых ритуалов;
- переписывание всех agent cards;
- реформа всей skill-системы.

## Acceptance

1. Есть один канонический инженерный ритуал.
2. Дублирующие файлы удалены.
3. Активные ссылки больше не указывают на удаленные дубли.
4. Closure зафиксирован отдельным git-slice.

## Следующий честный шаг

После cleanup:

1. проверить дерево в `DS-strategy` и `DS-agent-workspace`;
2. сделать отдельные коммиты по этому slice;
3. честно попробовать `push`;
4. повторно проверить `git status`.

## Result

- `AGENT.SKILL.001` оставлен единственным каноническим инженерным ритуалом.
- В него перенесен полезный `Acceptance Gate` из удаляемого дубля.
- `AGENT.SKILL.003` удален как пересекающийся duplicate.
- `agency/skills/environment-engineer/bounded-work-product-ritual.md` удален как локальный duplicate.
- `PACK-agent-skills/00-pack-manifest` и `environment-engineer.md` переведены на один source of truth.

## Truthful closeout

Сделано в этом slice:

1. Выявлен один реальный канон вместо трех пересекающихся ритуалов.
2. Сохранено полезное правило интеграционной проверки без сохранения второго skill-файла.
3. Удалены живые дубли и очищены активные ссылки.

Не делалось в этом slice:

- переписывание архивных `WP`, где сохранена историческая хронология;
- реформа остальных agent cards за пределами `environment-engineer`.

Следующий bounded шаг, если понадобится:

- пройтись отдельно по остальным role-card и сверить, нет ли там таких же локальных duplicate skill-слоев.
