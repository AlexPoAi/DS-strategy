# ENGINEERING-CONTEXT — google-workspace

> Инженерная ветка по Google Workspace контурам экзосистемы.

## Что входит в ветку

- `Google Drive connectors`
- локальные `Google Drive API tokens`
- `Gmail connector`
- `Google Calendar connector`
- drift между аккаунтами, токенами и видимыми папками

## Verified facts

- `Google Calendar connector` работает от `alexpoipad@gmail.com`
- `Gmail connector` по Park работает от `oooterrasimf@gmail.com`
- локальный `VK-offee` token видит папку `Парк` `12GgllpEOiRnGviQhivVm_bcAzX53E2wK`
- app-created старый `PARK.DOC.036` не виден локальному `VK-offee` token

## Materialized work

- `ENG.WP.046` — operating contract по Google Workspace
- `WP-109` — bounded slice на сборку единого контракта и skill-слоя

## Open technical tails

- выявить точный аккаунт `Google Drive app connector`
- свести `connector parity` между `Drive / Gmail / Calendar`
- решить, оставляем ли role-based split аккаунтов или сводим всё к одному canonical owner
- убрать Park document drift и задокументировать cleanup-порядок
