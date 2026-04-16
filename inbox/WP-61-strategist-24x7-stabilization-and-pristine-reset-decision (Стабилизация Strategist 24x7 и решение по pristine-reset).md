---
type: wp-context
status: done
owner: environment-engineer
created: 2026-04-15
updated: 2026-04-16 20:35
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
- Закрыт оставшийся блокер `A/B`: выбран `Option A (controlled migration)` с явным rollback runbook до `Option B`.

## Decision Memo (A/B)

### Вариант A: controlled migration (выбран)
- Суть: сохраняем текущий рабочий контур, переносим только проверенные upstream-изменения по whitelist.
- Плюсы:
  1. Нет потери рабочих артефактов и ритуальных контекстов.
  2. Меньше риск обрушить `24/7` в процессе пересборки.
  3. Можно делать изменения итерациями с быстрым откатом.
- Минусы:
  1. Требует дисциплины дедупликации и регулярного upstream-audit.

### Вариант B: pristine-reset от Церена
- Суть: полный пересбор от шаблона с повторным переносом локальных кастомизаций.
- Плюсы:
  1. Чистая база без исторического дрейфа.
- Минусы:
  1. Высокий риск потерять рабочие интеграции/артефакты.
  2. Существенная цена в токенах и времени.
  3. На период пересборки растёт риск деградации `24/7` контура.

### Вердикт
- Выбран `Option A (controlled migration)` как основной архитектурный путь для W16.
- `Option B` оставлен как аварийный rollback-сценарий, а не как baseline.

## Rollback Runbook (A -> B)
1. Зафиксировать snapshot текущего состояния: `DS-strategy`, `FMT-exocortex-template`, `DS-agent-workspace` (commit + tag/snapshot note).
2. Зафиксировать whitelist кастомизаций, которые обязательны после reset:
   - runtime policy (`split + product-only`);
   - canonical memory/opening routes;
   - strategist headless day-plan route;
   - extractor headless guard/fallback policy;
   - scheduler/status artifacts contract.
3. Развернуть clean-template ветку и применить whitelist-перенос по слоям: docs -> prompts -> scripts -> launch/runtime.
4. Прогнать acceptance-пакет:
   - `health-check` без critical;
   - `strategist-morning`, `strategist-note-review`, `strategist-week-review` = success;
   - `synchronizer-code-scan`, `synchronizer-daily-report`, `extractor-inbox-check` = success.
5. Только после зелёного acceptance переводить reset-ветку в основной runtime.

## Итог закрытия WP-61
- `strategist-morning/day-plan/week-review` подтверждены как `success` в статус-артефактах.
- Runtime-артефакты синхронизированы (`RUNTIME-MODE`, `AGENTS-STATUS`, `SESSION-OPEN`).
- A/B решение зафиксировано (`controlled migration`).
- Rollback runbook материализован и проверяем.
