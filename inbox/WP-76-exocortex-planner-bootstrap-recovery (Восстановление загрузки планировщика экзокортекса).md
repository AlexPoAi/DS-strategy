---
id: WP-76
title: "Exocortex planner bootstrap recovery"
status: active
priority: critical
owner: "Environment Engineer + Code Engineer"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

В отчёте Экзокортекса от `2026-04-19 15:46` зафиксирован критичный сигнал:
- `🔴 Планировщик экзокортекса не загружен`

Это блокирует стабильный day-flow и влияет на 24/7 контур.

# Цель

Вернуть планировщик в состояние `loaded/healthy` и зафиксировать post-check без ложных red-алертов.

# Scope

1. Определить точный слой деградации: runtime mode, unit/timer, пути к скриптам, env.
2. Восстановить bootstrap планировщика.
3. Прогнать post-check по статусу агентов и `inbox-check`.
4. Зафиксировать root-cause и регрессионную защиту.

# Acceptance

1. Сигнал `Планировщик экзокортекса не загружен` не воспроизводится.
2. Планировщик выдаёт валидный статус в окне day-start.
3. Хронология и INBOX обновлены с root-cause и fix-note.

# Next slice (today)

1. Быстрая диагностика status/runtime на текущем хосте.
2. Перезапуск/починка bootstrap слоя.
3. Повторный health-report и фиксация результата.

# Прогресс на 2026-04-19

1. Сверка с эталоном Церена выполнена:
   - локальный Mac: `com.exocortex.scheduler` загружен, `scheduler.sh status` зелёный;
   - VPS: `com.exocortex.scheduler.timer` был `disabled`, что и давало red-сигнал по планировщику.
2. На VPS включён и запущен таймер:
   - `systemctl enable --now com.exocortex.scheduler.timer`
   - подтверждён успешный `scheduler dispatch`.
3. Найден кроссплатформенный дефект в `health-check.sh`:
   - проверка планировщика была launchctl-only и на Linux давала ложный red.
4. В `FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh` внесён фикс:
   - launchd/systemd-aware bootstrap-check;
   - legacy launchd conflict-check пропускается на Linux корректно.

# Остаток до close

1. Протянуть свежий шаблон на VPS (`git pull` в `FMT-exocortex-template`).
2. Повторить health-check на VPS и убедиться, что красный сигнал по планировщику не воспроизводится.
