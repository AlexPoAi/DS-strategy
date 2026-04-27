---
type: domain-architecture
domain_id: DS-finance
title: Архитектура домена финансов
status: draft
created: 2026-04-27
updated: 2026-04-27
source_wp: 124
---

# DS-finance — Архитектура домена финансов

## Назначение

`DS-finance` — отдельный домен для финансового различения, cash-discipline,
проектного финансирования и verdict-ов по расходам/инвестициям поперёк всех
предметных областей экосистемы.

Его предмет — не "финансы вообще" и не бухгалтерский хвост, а финансы
системы создания: какие траты усиливают экосистему, какие только вынимают
ресурс, где узкое место и где инвестиция создаёт будущую мощность.

Это не копия `VK Coffee` и не копия `Park`. Это домен, который держит
их финансовые представления и принимает решения уровня:

- `freeze / keep / invest`
- `opex / capex`
- `must-pay / can-wait`
- `cash now / cash later / funding gap`

Он должен отвечать на вопросы:

- что сейчас усиливает систему;
- что только отнимает ресурс;
- где узкое место;
- где инвестиция создаёт будущую мощность;
- где трата не возвращает ни деньги, ни capability.

## FPF

### Что это за сущность

Это отдельный домен, потому что финансовое различение проходит поперёк всех
контуров и не принадлежит честно ни одному из них.

### Почему это не просто Pack внутри VK Coffee

Потому что финансовые решения касаются:

- `VK Coffee`
- `Park`
- строительства
- аренды / земли
- кредитной нагрузки
- будущих проектов

Значит, граница проходит не внутри одного бизнес-контура, а поверх нескольких.

### Source of truth

- первичное знание остаётся в родных доменах;
- `DS-finance` хранит финансовые представления этих доменов;
- weekly / strategic financial verdict materialize здесь.

## SRT

### Placement

`DS-finance` = отдельный межконтурный домен в слое управления экосистемой.

### Входы

- `VK Coffee`
- `Park`
- будущие домены
- captures / weekly session outputs
- manual executive inputs

### Выходы

- financial verdicts
- приоритеты расходов
- funding decisions
- weekly constraints for strategist
- finance-ready views per domain

## SPF

### Стартовые внутренние Pack

1. `PACK-finance-views`
   - финансовые представления по доменам:
   - `Finance View — VK Coffee`
   - `Finance View — Park`
   - позже `Finance View — Samir`

2. `PACK-cash-discipline`
   - правила расходов;
   - `freeze / keep / invest`;
   - tempo control при кассовом напряжении.

3. `PACK-project-funding`
   - стройка;
   - проектное финансирование;
   - gap analysis;
   - сценарии старта и дофинансирования.

4. `PACK-finance-agents`
   - role-cards;
   - hiring contracts;
   - skill growth финансовых агентов.

### Первый агент домена

`Financial Consultant` — primary domain agent.

Он отвечает за:

- сбор финансовой реальности по контурам;
- различение обязательного и необязательного;
- verdict по тратам;
- оценку funding gap;
- подготовку финансовых решений для собственника и strategist.
- оценку того, усиливает ли конкретная трата систему создания или ослабляет её.

### Supporting layer

`Strategist`
- weekly portfolio;
- приоритизация между контурами;
- эскалация финансовых verdict в недельное управление.

`Extractor`
- intake новых financial captures;
- routing в backlog / WP / finance views;
- не принимает финансовых решений сам.

### Что должен знать Financial Consultant

Не весь домен целиком, а его финансовую проекцию:

- текущий cash;
- обязательные расходы;
- инициативы, которые просят деньги;
- ожидания по доходу;
- долги / обязательства;
- сроки и критичность;
- риск заморозки или перерасхода.

## Первый practical use-case

`VK Coffee + Park`: при ограниченном cash определить:

- что нельзя трогать;
- что надо заморозить;
- во что можно инвестировать сейчас;
- какой funding gap по Парку остаётся после обязательных трат.

## Truthful current status

На 2026-04-27 `DS-finance` materialized как skeleton architecture,
но ещё не как отдельный repo/runtime domain.

Следующий честный шаг:

1. создать первый operational pack;
2. выпустить `Finance View — VK Coffee`;
3. выпустить `Finance View — Park`.
