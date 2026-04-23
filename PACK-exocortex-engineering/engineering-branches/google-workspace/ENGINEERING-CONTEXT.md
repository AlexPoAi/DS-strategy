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

## Materialized work

- `ENG.WP.046` — operating contract по Google Workspace
- `ENG.WP.047` — проверочный прогон Google Drive и Google Calendar
- `WP-109` — bounded slice на сборку единого контракта и skill-слоя
- `WP-110` — bounded slice на end-to-end verification и acceptance gate
- `WP-111` — миграция канонического Google-контура на `alexpoaiagent@gmail.com`

## Open technical tails

- выявить точный аккаунт `Google Drive app connector`
- решить стратегию `Gmail`:
  - один активный connector
  - или параллельная multi-account модель
- убрать Park document drift и задокументировать cleanup-порядок
