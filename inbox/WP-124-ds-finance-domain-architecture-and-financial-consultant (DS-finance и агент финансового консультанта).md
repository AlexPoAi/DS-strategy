---
type: work-plan
wp_id: 124
title: DS-finance и агент финансового консультанта
created: 2026-04-27
status: done
owner: Strategist
support:
  - Environment Engineer
  - FPF Consultant
  - DS-agent-workspace
domain: finance
mode: domain-architecture
---

# WP-124 — DS-finance и агент финансового консультанта

## Зачем открыт

Выявлен новый межконтурный домен, который нельзя честно удерживать только внутри
`VK Coffee` или в одном `Pack`:

- решения по `VK Coffee`;
- решения по `Park`;
- стройка и проектное финансирование;
- кредитная нагрузка;
- обязательные платежи;
- будущие контуры, которые ещё не materialize.

Нужен отдельный `DS-finance`, внутри которого появятся свои `Pack` и свои агенты.

## Цель slice

Materialize skeleton `DS-finance`, различить его внутренние `Pack` и нанять
первого доменного агента — `Financial Consultant`.

## В scope

- `FPF -> SRT -> SPF` различение `DS-finance`;
- skeleton внутренних `Pack`;
- модель того, как домен узнаёт про `VK Coffee`, `Park` и будущие области;
- первая role-card финансового консультанта;
- решение, какие базовые агенты поддерживают этот `DS`.

## Не в scope

- полноценная финансовая модель всех проектов;
- запуск отдельного репозитория под `DS-finance`;
- автоматическая интеграция с банками, учётом и Saby;
- набор всех будущих finance-агентов.

## Truthful result

- `DS-finance` различён как самостоятельный домен, а не просто один `Pack`;
- зафиксированы стартовые внутренние `Pack`;
- materialized первая role-card `Financial Consultant`;
- определено, что `Strategist` и `Extractor` входят в supporting layer домена,
  но не подменяют primary finance-agent.

## Acceptance

1. Есть явная архитектурная карточка `DS-finance`.
2. Виден стартовый pack-map домена.
3. Есть первая role-card финансового консультанта.
4. Понятно, как домен получает knowledge про `VK Coffee`, `Park` и другие контуры.

## Следующий bounded шаг

После этого slice:

1. отдельно materialize первый operational `Pack` внутри домена;
2. выпустить первые `Finance View` для `VK Coffee` и `Park`;
3. определить, нужен ли второй агент (`project-funding` / `cash-discipline`) уже на этой неделе.
