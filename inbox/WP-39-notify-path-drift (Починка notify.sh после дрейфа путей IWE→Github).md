---
type: work-product-context
wp_id: 39
title: Починка notify.sh после дрейфа путей IWE→Github
created: 2026-03-28
status: pending
priority: high
---

# WP-39: Починка notify.sh после дрейфа путей IWE→Github

## Цель

Устранить остаточный path drift в экзокортексе: strategist успешно выполняет сценарии, но в post-step пытается вызвать `notify.sh` по устаревшему пути `/Users/alexander/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh`, из-за чего «мозг экзокортекса» остаётся в жёлтом статусе.

## Инцидент

**Дата обнаружения:** 2026-03-28
**Источник:** ручная проверка после закрытия дня
**Симптом в логе:**

```bash
/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh: line 64:
/Users/alexander/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh: No such file or directory
```

## Диагностика

Файл:
- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh:64`

Текущая строка:
```bash
"$HOME/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh" strategist "$scenario"
```

Фактический существующий путь:
```bash
FMT-exocortex-template/roles/synchronizer/scripts/notify.sh
```

## Почему это важно

- сценарии strategist (`day-plan`) завершаются, но post-step падает на уведомлении;
- стартовый экран показывает «мозг экзокортекса: требует внимания»;
- остаётся ложное ощущение частично сломанной среды после уже выполненной починки `~/IWE → ~/Github`;
- path drift может повториться при следующих обновлениях от апстрима.

## Что нужно сделать

1. Исправить путь вызова `notify.sh` в `strategist.sh` на реальный путь внутри `FMT-exocortex-template`.
2. Проверить, нет ли других захардкоженных ссылок на старую структуру `IWE/DS-IT-systems/DS-ai-systems/...`.
3. Прогнать верификацию:
   - strategist `day-plan`
   - health-check / AGENTS-STATUS
   - подтверждение, что уведомление больше не падает.
4. Зафиксировать урок в `PACK-exocortex-engineering` как новый типовой incident/path-drift pattern.

## Критерий готовности

- в логах strategist больше нет `No such file or directory` для `notify.sh`;
- post-step уведомления работает;
- статус «мозга экзокортекса» возвращается в зелёный или имеет честное новое основание для жёлтого статуса.

## Связанные артефакты

- `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.002-iwe-symlink-2026-03-28 (Симлинк IWE и починка путей стратега).md`
- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/notify.sh`
- `DS-strategy/current/AGENTS-STATUS.md`

## Агент

**Environment Engineer**

## Триггер продолжения

Когда пол��зователь скажет:
- «продолжи WP-39»
- «почини notify у стратега»
- «сделай мозг экзокортекса зелёным»

начать с этого документа и с чтения последнего лога strategist.
