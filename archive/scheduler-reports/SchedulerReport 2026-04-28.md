---
type: scheduler-report
date: 2026-04-28
week: W18
agent: Синхронизатор
---

# Отчёт планировщика: 2026-04-28

## 🔴 Критический сбой — требуется внимание

> **Замечания:** strategist morning не запустился; 

## Результаты

| # | Задача | Статус | Время |
|---|--------|--------|-------|
| 1 | Сканирование кода | **✅** | 17:02:18 |
| 2 | Стратег утренний | **❌** | — |
| 5 | Проверка входящих | **✅** | 557366 сек назад |

## Ошибки и предупреждения

- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/strategist/scripts/strategist.sh’: No such file or directory
- [2026-04-28 17:02:18] [scheduler] WARN: strategist morning failed (will retry next dispatch)
- [2026-04-28 17:02:18] [scheduler] WARN: daily-report failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/extractor/scripts/extractor.sh’: No such file or directory
- [2026-04-28 17:02:18] [scheduler] WARN: extractor inbox-check failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/strategist/scripts/strategist.sh’: No such file or directory
- [2026-04-28 17:17:18] [scheduler] WARN: strategist morning failed (will retry next dispatch)
- [2026-04-28 17:17:18] [scheduler] WARN: daily-report failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/extractor/scripts/extractor.sh’: No such file or directory
- [2026-04-28 17:17:18] [scheduler] WARN: extractor inbox-check failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/strategist/scripts/strategist.sh’: No such file or directory
- [2026-04-28 17:32:18] [scheduler] WARN: strategist morning failed (will retry next dispatch)
- [2026-04-28 17:32:18] [scheduler] WARN: daily-report failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/extractor/scripts/extractor.sh’: No such file or directory
- [2026-04-28 17:32:18] [scheduler] WARN: extractor inbox-check failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/strategist/scripts/strategist.sh’: No such file or directory
- [2026-04-28 17:47:21] [scheduler] WARN: strategist morning failed (will retry next dispatch)
- [2026-04-28 17:47:21] [scheduler] WARN: daily-report failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/extractor/scripts/extractor.sh’: No such file or directory
- [2026-04-28 17:47:21] [scheduler] WARN: extractor inbox-check failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/strategist/scripts/strategist.sh’: No such file or directory
- [2026-04-28 18:02:23] [scheduler] WARN: strategist morning failed (will retry next dispatch)
- [2026-04-28 18:02:23] [scheduler] WARN: daily-report failed (will retry next dispatch)
- timeout: failed to run command ‘{{IWE_RUNTIME}}/roles/extractor/scripts/extractor.sh’: No such file or directory
- [2026-04-28 18:02:23] [scheduler] WARN: extractor inbox-check failed (will retry next dispatch)
- [2026-04-28 18:02:57] WARN: falling back to Codex for day-plan (reason=primary_provider, model=gpt-5.4, timeout=1200s)
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 3/5
- [2026-04-28 18:03:14]   2026-04-28T18:03:01.701741Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 403 Forbidden, url: wss://chatgpt.com/backend-api/codex/responses
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 4/5
- [2026-04-28 18:03:14]   2026-04-28T18:03:03.325311Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 403 Forbidden, url: wss://chatgpt.com/backend-api/codex/responses
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 5/5
- [2026-04-28 18:03:14]   2026-04-28T18:03:06.646255Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 403 Forbidden, url: wss://chatgpt.com/backend-api/codex/responses
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 1/5
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 2/5
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 3/5
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 4/5
- [2026-04-28 18:03:14]   ERROR: Reconnecting... 5/5
- [2026-04-28 18:03:14]   ERROR: unexpected status 403 Forbidden: <html>
- [2026-04-28 18:03:14]   ERROR: unexpected status 403 Forbidden: <html>
- [2026-04-28 18:03:14]   2026-04-28T18:03:14.320492Z ERROR codex_core::session: failed to record rollout items: thread 019dd542-312f-7380-9ab7-13f771ac491a not found
- [2026-04-28 18:03:14] ERROR: Codex provider exited with code 1 for scenario: day-plan
- [2026-04-28 18:03:14] Scenario result: day-plan status=failed exit_code=1 provider=codex model=gpt-5.4
- [2026-04-28 18:03:14] WARN: Codex primary failed for day-plan — falling back to Claude provider
- [2026-04-28 18:03:17] CRITICAL: Claude-compatible provider auth failed for scenario: day-plan
- [2026-04-28 18:03:17] WARN: falling back to Codex for day-plan (reason=claude_auth_failed, model=gpt-5.4, timeout=1200s)
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 3/5
- [2026-04-28 18:03:34]   2026-04-28T18:03:21.829644Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 403 Forbidden, url: wss://chatgpt.com/backend-api/codex/responses
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 4/5
- [2026-04-28 18:03:34]   2026-04-28T18:03:23.620453Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 403 Forbidden, url: wss://chatgpt.com/backend-api/codex/responses
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 5/5
- [2026-04-28 18:03:34]   2026-04-28T18:03:26.852783Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 403 Forbidden, url: wss://chatgpt.com/backend-api/codex/responses
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 1/5
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 2/5
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 3/5
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 4/5
- [2026-04-28 18:03:34]   ERROR: Reconnecting... 5/5
- [2026-04-28 18:03:34]   ERROR: unexpected status 403 Forbidden: <html>
- [2026-04-28 18:03:34]   ERROR: unexpected status 403 Forbidden: <html>
- [2026-04-28 18:03:34]   2026-04-28T18:03:34.341291Z ERROR codex_core::session: failed to record rollout items: thread 019dd542-813f-7b13-8bc2-de3c7f36b2c2 not found
- [2026-04-28 18:03:34] ERROR: Codex provider exited with code 1 for scenario: day-plan
- [2026-04-28 18:03:34] Scenario result: day-plan status=failed exit_code=1 provider=codex model=gpt-5.4
- [2026-04-28 18:03:34] [scheduler] WARN: strategist morning failed (will retry next dispatch)

**Что делать:**
