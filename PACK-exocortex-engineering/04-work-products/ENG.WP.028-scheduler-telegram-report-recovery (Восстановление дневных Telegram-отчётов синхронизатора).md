---
type: engineering-work-product
wp_id: ENG.WP.028
title: Восстановление дневных Telegram-отчётов синхронизатора
date: 2026-04-07
status: completed
priority: high
linked_inbox: ENG-telegram-report
author: Environment Engineer (Codex)
---

# ENG.WP.028 — Восстановление дневных Telegram-отчётов синхронизатора

## Контекст

Пользовательский симптом: в течение дня не приходят большие Telegram-отчёты о состоянии агентов.

При диагностике подтверждено:

- `daily-report.sh` сам по себе не отправляет Telegram-сводку, он только пишет markdown-артефакты;
- за отправку отвечает отдельный путь `daily-telegram-report.sh`;
- scheduler часто не доходил до этого шага.

## Root cause

Обнаружены две системные поломки в `scheduler.sh`:

- role runner discovery жил с неразрешённым `{{WORKSPACE_DIR}}`, поэтому `Strategist` и `Extractor` вызывались по битым путям;
- блок `strategist morning` был несовместим с `set -e`, и неуспешный запуск мог оборвать весь dispatch раньше `daily-report` и `daily-telegram-report`.

Дополнительно сам Telegram-дайджест был слишком бедным и не отражал runtime/opening verdict достаточно явно.

## Что сделано

- в `scheduler.sh` добавлен truthful `WORKSPACE_DIR` resolution (`~/Github` с fallback на `~/IWE`);
- `ROLES_DIR` и pre-archive путь переведены с template-placeholder на реальные runtime paths;
- morning block сделан resilient к non-zero exit через controlled `set +e / set -e`;
- шаблон `daily-telegram-report` усилен:
  - brain verdict;
  - agent status snapshot;
  - runtime mode;
  - блок `Что требует внимания`;
  - счётчик рабочих продуктов и нанятых агентов.
- в adjacent nightly paths дополнительно снят runtime drift:
  - `extractor.sh` переведён на truthful workspace resolution вместо literal `{{HOME_DIR}}/Github`;
  - `inbox-check` снова видит реальный `DS-strategy/inbox/captures.md` и truthfully возвращает `SKIP: No pending captures`, а не `captures.md not found`;
  - `code-scan.sh` переведён на реальный workspace path и перестал ломаться на empty array / `set -u`.
- снят ещё один observability drift перед отправкой Telegram-дайджеста:
  - `daily-report.sh` получил отдельный refresh-route `--refresh-status-artifacts`, который пересобирает `RUNTIME-MODE.md`, `AGENTS-STATUS.md` и `SESSION-OPEN` без полного пересоздания SchedulerReport;
  - `daily-telegram-report.sh` теперь вызывает этот refresh перед отправкой, поэтому Telegram-report больше не зависит от старого утреннего snapshot-а;
  - opening/status artifacts и runtime arbiter теперь синхронизируются на одном живом состоянии provider plane.
- снят stale-semantics drift внутри opening/status artifacts:
  - `daily-report.sh` и `health-check.sh` теперь предпочитают свежие daily/interval markers старым `~/.local/state/exocortex/status/*.status`, если marker новее;
  - `strategist-note-review`, `synchronizer-code-scan`, `synchronizer-daily-report` и `extractor-inbox-check` больше не рисуются как stale только потому, что мартовский `.status` старше живого marker-а;
  - stale для задач вне текущего окна (например `week-review` не в понедельник) больше переводится в neutral `missing`, а не раздувает yellow noise.
- снята путаница между `stale` и реально пропущенным сегодняшним окном:
  - для `strategist-morning` после 22:00 при отсутствии marker-а вводится отдельный truthful статус `missed_window`, а не абстрактный `stale`;
  - `AGENTS-STATUS.md` и `SESSION-OPEN` теперь показывают человеческое сообщение `окно на сегодня уже пропущено`;
  - `health-check.sh` логирует это отдельно как `ПРОПУЩЕНО ОКНО`, но всё ещё suppress-ит stale-only Telegram alert, чтобы этот хвост не перекрывал полезный дневной отчёт.

## Проверка

- `bash -n` прошёл для:
  - `scheduler.sh`
  - `daily-telegram-report.sh`
  - `templates/synchronizer.sh`
- ручной запуск `daily-telegram-report.sh` успешно отправил сообщение в Telegram;
- повторный `scheduler.sh dispatch` дошёл до:
  - `daily-telegram-report`
  - `extractor inbox-check`
  - `dispatch completed`
- в `~/.local/state/exocortex/` появились:
  - `telegram-report-2026-04-07`
  - `synchronizer-telegram-report-2026-04-07`
- `extractor.sh inbox-check` вручную подтверждает реальный путь и даёт `SKIP: No pending captures in inbox`
- `code-scan.sh --dry-run` проходит и показывает truthful summary по найденным репозиториям
- `daily-report.sh --refresh-status-artifacts` вручную пересобирает:
  - `current/RUNTIME-MODE.md`
  - `current/AGENTS-STATUS.md`
  - `current/SESSION-OPEN (Экран открытия сессии).md`
- после refresh `AGENTS-STATUS` и `SESSION-OPEN` больше не показывают legacy `primary=claude, codex=missing`; теперь они truthfully отражают `primary=codex, codex=available, claude=available`
- после stale-semantics fix:
  - `health-check.sh` показывает truthful картину: stale остался только у `strategist-morning`;
  - `strategist-note-review`, `synchronizer-code-scan`, `synchronizer-daily-report` и `extractor-inbox-check` подтверждаются как `success`;
  - `strategist-week-review` во вторник больше не шумит как stale/error, а считается задачей вне текущего окна.
- после `missed_window` fix:
  - вместо формулировки `устаревший или неполный статус` opening/status artifacts показывают `окно на сегодня уже пропущено`;
  - remaining yellow verdict теперь объясним: это исторически пропущенное утреннее окно до фиксов, а не текущая поломка runtime plane.

## Truthful status

Дневной Telegram-отчёт синхронизатора восстановлен.

При этом во время прогона всплыли ещё два отдельных хвоста, не блокирующих саму отправку отчёта:

- `strategist note-review` имел отдельную runtime-ошибку, она уже снята отдельным follow-up в `ENG.WP.020`;
- remaining next layer — уже не stale source-of-truth drift, а product-level решение: считать ли одиночный `strategist-morning missed_window` просто информационным recovery-note или отдельным operational debt до следующего утра.

То есть Telegram notification path уже починен, но агентный runtime ещё требует следующего cleanup-цикла.
