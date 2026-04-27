---
id: WP-76
title: "Exocortex planner bootstrap recovery"
status: done
priority: critical
owner: "Environment Engineer + Code Engineer"
created: 2026-04-19
updated: 2026-04-21
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

1. Зафиксировать отдельно инфраструктурные деградации VPS (`/root/Github` неполный workspace: нет `memory`, `CLAUDE.md`, `DS-agent-workspace`) — это уже не баг планировщика.
2. Принять решение по модели эксплуатации VPS:
   - либо полноценный workspace как на Mac,
   - либо ограниченный runtime без полного `health-check` контракта.

# Post-check VPS (2026-04-19 17:28 UTC)

- `health-check.sh` после фикса показывает:
  - ✅ `ОК: планировщик загружен (systemd)` — red по планировщику устранён.
  - ⚠️ Остальные ошибки относятся к неполному составу репозиториев/контрактов на VPS, не к scheduler bootstrap.

# Финальный closeout (2026-04-21)

1. Найден и устранён остаточный semantic-tail в local status layer:
   - `strategist-week-review` при skip-path `already completed earlier this week-window` записывал `STALENESS_BUDGET_SEC=86400`;
   - из-за этого уже на следующий день `SESSION-OPEN` и `AGENTS-STATUS` рисовали ложный `yellow/stale`, хотя weekly window был закрыт успешно.
2. В `FMT-exocortex-template/roles/strategist/scripts/strategist.sh` добавлен явный weekly staleness budget `604800` для skip-path week-review.
3. Выполнена верификация:
   - `bash .../strategist.sh week-review` → `SKIP: week-review already completed in current week-window`;
   - `bash .../daily-report.sh --refresh-status-artifacts` пересобрал `AGENTS-STATUS.md` и `SESSION-OPEN`.
4. Итог:
   - `current/SESSION-OPEN (Экран открытия сессии).md` → `🟢 green`;
   - `current/AGENTS-STATUS.md` → все ключевые агенты и задачи зелёные;
   - `strategist-week-review.status` теперь truthfully хранит `STALENESS_BUDGET_SEC=604800`.

# Verdict

`WP-76` закрыт truthfully: red-сигнал по planner bootstrap снят ранее, а 2026-04-21 добит последний observability-tail, из-за которого opening screen ещё оставался жёлтым.
