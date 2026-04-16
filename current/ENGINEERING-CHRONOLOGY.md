---
type: engineering-chronology
updated: 2026-04-16 20:25
source_of_truth: DS-strategy/inbox/INBOX-TASKS.md + PACK-exocortex-engineering/04-work-products
---

# Engineering Chronology (Exocortex)

## Зачем
- Один журнал инженерных решений и незакрытых хвостов.
- Цель: не переделывать одно и то же, каждый новый агент заходит в контекст за 5-10 минут.

## Ключевые вехи (что уже сделано)
1. 2026-03-26 → 2026-03-30: стабилизация базовых путей/entrypoints и notify-контур (`ENG.WP.001`..`ENG.WP.004`).
2. 2026-04-05: reliability-блок по Strategist + модельные fallback/always-on направления (`ENG.WP.019`..`ENG.WP.021`, `ENG.WP.023`).
3. 2026-04-07: codex-primary миграция, runtime-arbiter, восстановление daily Telegram отчётов, truthful close-flow (`ENG.WP.024`..`ENG.WP.028`).
4. 2026-04-08 → 2026-04-13: агентный hardening + target-capability implementation + recovery loop + opening/open-contract modernization (`ENG.WP.030`..`ENG.WP.038`, `WP-60`).
5. 2026-04-15: найден и закрыт root-cause зависаний `strategist morning` (ошибочный route `day-plan -> protocol-open`), открыт `WP-61` для финальной стабилизации 24/7 и решения по pristine-reset.
6. 2026-04-15: в `WP-62` материализован складской автоконтур (`sync -> cards -> bot kb -> telegram`), добавлены quota-retry/backoff и launchd full-loop entrypoint.
7. 2026-04-15: открыт `WP-63` как production-hardening слой для склада (registry, DLQ, idempotency, Drive contract, daily health-report).
8. 2026-04-15: в `WP-63` реализована итерация `WH.REGISTRY` — pipeline фиксирует статусы `new/processed/duplicate/error` и показывает операционные счётчики в warehouse summary.
9. 2026-04-16: в `WP-63` реализован `DLQ/quarantine` для склада — проблемные CSV уходят в quarantine-folder и получают отдельный DLQ-report.
10. 2026-04-16: найден production-risk в Telegram bot layer — `monitor_bot.py` мог использовать тот же `TELEGRAM_BOT_TOKEN`, что и product bot. Контур разделён на отдельный `MONITOR_BOT_TOKEN`, чтобы не создавать повторный `409 Conflict` своими же руками.
11. 2026-04-16: устранён runtime-gap `extractor inbox-check` (headless hardening + актуальный extraction-report), статус экзокортекса возвращён в зелёный контур.
12. 2026-04-16: открыт `WP-64` для рефактора инженерного backlog (дедупликация задач, единый closeout-порядок и anti-rework контракт).
13. 2026-04-16: `WP-61` закрыт — зафиксированы success-окна strategist, выбран путь `controlled migration`, материализован rollback runbook до `pristine-reset`.

## Что критично открыто (не закрыто)
1. `ENG.WP.031`: довести агентный слой до целевого состояния без зависших статусов и с подтверждённым full-loop.
2. Connector parity Codex/Claude (`Google Drive + Gmail`) — критичный pending в `INBOX-TASKS`.
3. Ритуальные WP (`WP-21/WP-28/WP-29`) — закрывать только после синхронизации всех трекеров.
4. `WP-62`: подтвердить финальный warehouse Telegram chat routing (`WAREHOUSE_REPORT_CHAT_ID`) и стабильность 2+ циклов подряд.
5. `WP-63`: внедрить storage-governance склада и закрепить архитектуру поставки документов из Google Drive.
6. `WP-64`: завершить дедупликацию инженерных задач и удерживать единый weekly closeout-порядок.

## Правило anti-rework (обязательный старт)
1. Прочитать этот файл + `current/SESSION-CONTEXT.md`.
2. Проверить соответствующий `WP-xx` контекстный файл.
3. Сверить статус в `INBOX-TASKS.md` и `ENG.WP.000-repair-registry`.
4. Только после этого вносить кодовые/процессные изменения.

## Быстрые ссылки
- `DS-strategy/inbox/INBOX-TASKS.md`
- `DS-strategy/current/SESSION-CONTEXT.md`
- `DS-strategy/inbox/WP-60-opening-open-contract-modernization (Переделка opening и open-contract контура).md`
- `DS-strategy/inbox/WP-61-strategist-24x7-stabilization-and-pristine-reset-decision (Стабилизация Strategist 24x7 и решение по pristine-reset).md`
- `DS-strategy/inbox/WP-62-warehouse-autocontour-cards-and-telegram-reports (Складской автоконтур карточек и Telegram-отчетов).md`
- `DS-strategy/inbox/WP-63-warehouse-governance-and-drive-architecture-hardening (Доведение governance склада и архитектуры Google Drive).md`
- `DS-strategy/inbox/WP-64-engineering-contour-refactor-and-closeout-plan (Рефактор инженерного контура и план закрытия хвостов).md`
- `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.000-repair-registry (Реестр инженерных работ по экосистеме).md`
