---
type: work-plan
wp_id: 109
title: Единый operating contract для Google Workspace и skill для агентов
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - Strategist
domain: exocortex-engineering
mode: integration-contract
---

# WP-109 — Единый operating contract для Google Workspace и skill для агентов

## Зачем открыт

Нужно собрать в один понятный контур работу экзосистемы с:

- `Google Drive`
- `Gmail`
- `Google Calendar`

Сейчас у нас подтверждён drift:

- разные Google-контуры видят разные документы;
- `connector-created` документы и локальный `VK-offee` OAuth-токен не совпадают;
- по Парку есть конфликт между root-папкой проекта и фактической папкой документов.

## Цель slice

Materialize единый operating contract:

1. какой аккаунт и какой контур за что отвечает;
2. что уже `verified`, а что ещё `unverified`;
3. какой путь канонический для Park-документов;
4. какой skill нужен агентам, чтобы они не путали `connector`, `token` и `canonical folder`.

## Что должно materialize

- `ENG.WP.046`
- engineering-ветка `google-workspace`
- канонический skill `AGENT.SKILL.004`

## Truthful scope

В этот slice входит:

- архитектурная карта Google-контура;
- фиксация verified/unverified слоёв;
- skill-контракт для агентов.

В этот slice не входит:

- полная починка всех connector-ов;
- чистка старых дубликатов в чужом Google-контуре;
- bind live-skill в грязный `DS-agent-workspace`.

## Следующий честный шаг

После materialization контракта открыть отдельный bounded slice на:

- `connector parity / account drift`
- или на live-binding skill в агентный workspace.

## Truthful verdict

Slice закрыт как architectural contract layer.

Что реально materialized:

- единый `Google Workspace operating contract`;
- engineering-ветка `google-workspace`;
- канонический skill `AGENT.SKILL.004`;
- поправка `START-HERE` по фактической папке документов `Парк`.

Что сознательно не доведено в этом slice:

- live-binding нового skill в `DS-agent-workspace`;
- cleanup старых документов в чужом Google-контуре;
- финальное сведение всех connector-ов к одному аккаунту.
