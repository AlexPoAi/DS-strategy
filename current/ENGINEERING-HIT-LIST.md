---
type: engineering-hit-list
updated: 2026-04-17 22:05
---

# Engineering Hit List (W16)

## Сначала (critical)
1. `WP-62` + `WP-63`: закрыть складской production-tail (`WAREHOUSE_REPORT_CHAT_ID`, 2-3 стабильных цикла, Drive 00/10/90 + health digest).
2. `WP-69`: завершить pristine-выравнивание экзокортекса под Церен (post-check + rollback-note + финальный closeout).
3. `Anthropic appeal`: дождаться Trust & Safety verdict по `organization disabled` и закрепить обновлённый credentials-contract.
4. `WP-64`: довести дедупликацию инженерного backlog и удержать единый closeout-порядок без rework.

## Далее (high)
1. Connector parity Codex/Claude (`Google Drive + Gmail`) — убрать runtime gap в app-connectors.
2. `ENG.WP.031`: завершить target-capability слой агентов (Extractor/Synchronizer/Strategist без потерь и с проверяемыми артефактами).
3. `ENG.WP.020/021/038` + ritual WP (`WP-21/WP-28/WP-29`): синхронизировать hardening и закрытие трекеров в одном цикле.
4. `UPSTREAM audit` (`ENG.WP.029`): проверить обновления Церена и применять только whitelist-изменения.

## Контроль против повторов
1. Перед началом каждой задачи сверять: `ENGINEERING-CHRONOLOGY.md` + `WP-xx` + `INBOX-TASKS.md`.
2. Любое «done» ставить только после sync: WP-файл + INBOX + SESSION-CONTEXT.
