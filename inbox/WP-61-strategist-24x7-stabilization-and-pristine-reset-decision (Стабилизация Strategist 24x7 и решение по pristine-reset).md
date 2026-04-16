---
type: wp-context
status: active
owner: environment-engineer
created: 2026-04-15
updated: 2026-04-16
tags: [engineering, strategist, runtime, 24x7, upstream]
---

# WP-61: Стабилизация Strategist 24x7 и решение по pristine-reset

## Контекст
- `WP-60` (opening/open-contract modernization) закрыт; текущий цикл продолжает уже завершённую нормализацию маршрутов открытия.
- В runtime-контуре подтверждён блокер: headless `strategist morning` запускал интерактивный opening-протокол вместо неинтерактивного day-plan сценария.
- Исправления в `strategist.sh` уже внесены: route для `day-plan` переведён на `roles/strategist/prompts/day-plan.md`, добавлен codex path fallback и codex-first fallback порядок.
- Нужен управляемый выбор архитектурного пути: продолжать controlled migration текущего контура или выполнить pristine-reset от шаблона Церена с переносом наших кастомизаций по whitelist.

## Цель
Добиться подтверждённого 24/7 исполнения Strategist и зафиксировать одно выбранное направление (A/B) с rollback-планом.

## Что сделать
1. Подтвердить `strategist-morning/day-plan/week-review` в статусах как `success` в живом окне.
2. Синхронизировать runtime-артефакты (`RUNTIME-MODE`, `AGENTS-STATUS`, `SESSION-OPEN`) из одного источника.
3. Подготовить decision memo:
   - Option A: controlled migration;
   - Option B: pristine-reset от Церена + whitelist-перенос.
4. Зафиксировать выбранный вариант и rollback runbook.

## Acceptance
- В status-артефактах есть подтверждённые `success` для ключевых strategist-сценариев.
- В scheduler-контуре нет зависаний из-за интерактивных протоколов.
- Зафиксирован выбранный A/B путь и проверяемый rollback.
- Хронология изменений отражена в `current/SESSION-CONTEXT.md`.

## Артефакты
- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `DS-strategy/current/RUNTIME-MODE.md`
- `DS-strategy/current/SESSION-CONTEXT.md`
- `DS-strategy/current/ENGINEERING-CHRONOLOGY.md`

## Прогресс на 2026-04-15
- Подтверждён и устранён root-cause зависания headless day-plan (ошибочный route на `protocol-open`).
- Runtime policy/scope возвращены в `split + product-only`, локальный dispatch включён.
- Добавлен единый инженерный таймлайн для анти-дублирования работ и быстрого входа новых агентов.
- Подтверждён живой morning-run: `strategist-morning.status=success` (2026-04-15 19:35), DayPlan материализован.
- Фактический контур дня в DayPlan: `#58 in_progress`, `#51 blocked` (ожидание документов), `#59 pending`.
- Открытый хвост: зафиксировать свежие `success` status-окна для strategist-сценариев и закрыть decision memo A/B.

## Прогресс на 2026-04-16
- В `AGENTS-STATUS` подтверждены зелёные статусы по strategist и синхронизатору.
- `health-check` проходит без critical-ошибок; opening-contract и runtime-arbiter в зелёной зоне.
- Оставшийся блокер `WP-61`: не техническая стабильность, а архитектурное решение `A/B` (`controlled migration` vs `pristine-reset`) и явный rollback runbook.
