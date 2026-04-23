# ENGINEERING.DOMAIN.REGISTRY

> Реестр предметных веток, по которым уже materialized инженерный слой.

## Как читать

- `Domain` — предметная область.
- `Engineering branch` — путь в инженерном слое.
- `Context` — основной context-файл ветки.
- `Latest WP` — последний инженерный WP, который расширял ветку.
- `Статус`:
  - `seeded` — ветка создана, но ещё не насыщена;
  - `active` — инженерный слой по домену живо развивается;
  - `mature` — ветка стабилизирована и служит опорным слоем.

| Domain | Engineering branch | Context | Latest WP | Статус |
|---|---|---|---|---|
| `management` | `engineering-branches/management/` | `engineering-branches/management/ENGINEERING-CONTEXT.md` | `ENG.WP.045` | seeded |
| `google-workspace` | `engineering-branches/google-workspace/` | `engineering-branches/google-workspace/ENGINEERING-CONTEXT.md` | `ENG.WP.046` | active |

## Следующие кандидаты

- `park-development`
- `warehouse`
- `obsidian-human-layer`
- `agent-skills`

## Правило

Этот реестр не заменяет предметные Pack.

Он хранит только инженерную карту:

- какие работы проходили по домену;
- где лежит engineering-context;
- какой последний инженерный WP это расширял.
