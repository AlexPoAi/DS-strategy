---
type: work-plan
wp_id: 105
title: Скилл ритуала чистого рабочего продукта
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - Strategist
domain: agent-skills
mode: skill-materialization
---

# WP-105 — Скилл ритуала чистого рабочего продукта

## Зачем открыт

Пользователь явно зафиксировал желаемое поведение агента:

- сначала открывать рабочий продукт;
- явно назначать primary/support агента;
- не размазывать изменения по грязному дереву;
- держать bounded scope;
- закрывать РП truthfully;
- потом делать отдельный `commit/push`.

Это не разовая договорённость, а повторяемый operational contract, значит он должен
быть сохранён как skill.

## Что materialized

- live skill у `Environment Engineer`:
  - `agency/skills/environment-engineer/bounded-work-product-ritual.md`
- ссылка на skill в карточке `Environment Engineer`
- каноническая Pack-версия:
  - `AGENT.SKILL.003-bounded-work-product-ritual`

## Acceptance

- skill оформлен как повторяемый контракт;
- привязан к живому агенту;
- сохранён в каноническом домене `PACK-agent-skills`.

## Truthful verdict

Slice закрыт как skill-only materialization.

Следующий честный шаг:

- применять этот skill на следующих bounded slices;
- отдельно вычистить уже накопившийся Park/runtime хвост в грязном дереве через
  отдельные РП, а не вперемешку.
