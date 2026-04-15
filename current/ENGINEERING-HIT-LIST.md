---
type: engineering-hit-list
updated: 2026-04-15 19:36
---

# Engineering Hit List (W16)

## Сначала (critical)
1. `WP-61`: закрыть strategist 24/7 (убрать зависшие `running`, получить свежие `success` окна, зафиксировать A/B решение по reset от Церена).
2. `ENG.WP.031`: завершить target-capability слой агентов (Extractor/Synchronizer/Strategist без потерь и с проверяемыми артефактами).
3. Connector parity Codex/Claude (`Google Drive + Gmail`) из `INBOX-TASKS` — убрать runtime gap в app-connectors.

## Далее (high)
1. `WP-21 / WP-28 / WP-29`: синхронизировать ritual/atomicity контур и закрыть расхождения между трекерами.
2. `ENG.WP.020/021/038`: закрыть хвосты strategist-hardening и связать их с `WP-61` как единый контракт.
3. `UPSTREAM audit` (`ENG.WP.029`): проверить обновления Церена и применить только whitelist-изменения.

## Контроль против повторов
1. Перед началом каждой задачи сверять: `ENGINEERING-CHRONOLOGY.md` + `WP-xx` + `INBOX-TASKS.md`.
2. Любое «done» ставить только после sync: WP-файл + INBOX + SESSION-CONTEXT.
