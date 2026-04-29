# ENGINEERING-CONTEXT — google-workspace

> Инженерная ветка по Google Workspace контурам экзосистемы.

## Что входит в ветку

- `Google Drive connectors`
- локальные `Google Drive API tokens`
- `Gmail connector`
- `Google Calendar connector`
- drift между аккаунтами, токенами и видимыми папками

## Verified facts

- канонический `Google Drive` контур переведён на `alexpoaiagent@gmail.com`
- канонический `Google Calendar connector` переведён на `alexpoaiagent@gmail.com`
- `Gmail connector` по Park работает от `oooterrasimf@gmail.com`
- локальный `VK-offee` token видит папку `Парк` `12GgllpEOiRnGviQhivVm_bcAzX53E2wK`
- app-created старый `PARK.DOC.036` не виден локальному `VK-offee` token
- 2026-04-29: Codex Google Drive app connector live-read видит папку `Парк`
  `12GgllpEOiRnGviQhivVm_bcAzX53E2wK` и документы `PARK.DOC.036`/`PARK.DOC.037`
- 2026-04-29: Claude project MCP route не содержит активный `google-drive` server
  в `.mcp.json`; при этом `.claude/settings.json` уже разрешает
  `mcp__google-drive__*` tools
- 2026-04-29: `google-drive` server добавлен в project `.mcp.json` через
  `npx -y @piotr-agier/google-drive-mcp` с постоянным token path
  `/Users/alexander/.config/google-drive-mcp/tokens.json`; OAuth успешно пройден
- 2026-04-29: post-restart check пройден — Claude подключился к Google Drive и
  работает по отдельной задаче в обычном рабочем контуре
- 2026-04-29: Google Workspace route подписан как общий процессный контракт
  для Claude и Codex через `AGENT.SKILL.004`; tool-surface считается адаптером,
  а не отдельным маршрутом
- 2026-04-29: route placement aligned with Tseren layering: Google Workspace
  specifics live in author L3 (`CLAUDE.md` §9 + `memory/*` navigation), not in
  FMT L1 core

## Materialized work

- `ENG.WP.046` — operating contract по Google Workspace
- `ENG.WP.047` — проверочный прогон Google Drive и Google Calendar
- `AGENT.SKILL.004` — общий маршрут Claude/Codex для Google Workspace контуров
- `WP-109` — bounded slice на сборку единого контракта и skill-слоя
- `WP-110` — bounded slice на end-to-end verification и acceptance gate
- `WP-111` — миграция канонического Google-контура на `alexpoaiagent@gmail.com`
- `WP-112` — стратегия `Gmail` между `alexpoaiagent` и `ООО ТЕРРА`

## Open technical tails

- выявить точный аккаунт `Google Drive app connector`
- если понадобится исходящий `Gmail` от `alexpoaiagent@gmail.com`,
  открыть отдельный bounded slice под это
- убрать Park document drift и задокументировать cleanup-порядок
