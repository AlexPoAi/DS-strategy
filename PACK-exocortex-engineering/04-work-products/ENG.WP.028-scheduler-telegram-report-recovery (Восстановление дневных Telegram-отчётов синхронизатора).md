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

## Truthful status

Дневной Telegram-отчёт синхронизатора восстановлен.

При этом во время прогона всплыли ещё два отдельных хвоста, не блокирующих саму отправку отчёта:

- `strategist note-review` имеет отдельную runtime-ошибку;
- `extractor inbox-check` живёт с отдельной workspace/captures drift-семантикой.

То есть Telegram notification path уже починен, но агентный runtime ещё требует следующего cleanup-цикла.
