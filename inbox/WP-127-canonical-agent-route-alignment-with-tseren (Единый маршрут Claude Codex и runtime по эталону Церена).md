---
type: work-product
id: WP-127
status: in_progress
priority: critical
created: 2026-04-28
updated: 2026-04-28
owner: Engineer
domain: exocortex
approved: true
---

# WP-127 — Единый маршрут Claude Codex и runtime по эталону Церена

## Почему открыто

После update из upstream Церена `v0.29.11` выяснилось, что разные агенты и automation-контуры заходят в экзокортекс по разным operational routes:

- `Claude` ручным маршрутом видел truthy `Требует внимания` и hook/runtime defects;
- `Codex` и scheduler-runtime местами шли по другому path/env слою;
- в `SchedulerReport 2026-04-28` остались симптомы `{{IWE_RUNTIME}}` drift и failed dispatch.

Пользователь явно потребовал: **любой агент, кто бы это ни был, должен ходить по одному и тому же маршруту**, а не по параллельным траекториям.

## Truthful factual finding

На момент открытия РП подтверждено:

- root hooks физически существуют в `/Users/alexander/Github/.claude/hooks/`, но относительные вызовы ломались при запуске не из workspace root;
- root `memory/` указывал в пустую цель, из-за чего `Claude/Codex/runtime` читали разный context layer;
- `~/.iwe-paths` был неполным: отсутствовали `IWE_RUNTIME` и `IWE_GOVERNANCE_REPO`;
- `.iwe-runtime` и substituted launchd-plists уже существовали, но shell/env слой отставал;
- upstream Церена подтверждает канон: один `workspace root`, один `memory route`, один `.iwe-runtime`, один `install-iwe-paths.sh`.

## Сверка с Цереном

Проверить и удерживать:

1. `setup/install-iwe-paths.sh` из `upstream/main` как source-of-truth для `IWE_*`.
2. `setup.sh` / `memory` symlink contract из `upstream/main`.
3. `scheduler.sh` / `roles/synchronizer/config.yaml` как канон runtime через `.iwe-runtime`.
4. Любые локальные отклонения допустимы только если они уменьшают drift и сохраняют **один** маршрут, а не плодят второй.

## Согласованный scope

Разрешено:

- чинить root hook route;
- восстанавливать canonical `memory` route;
- чинить `~/.iwe-paths` и env lookup layer;
- сверять runtime/launchd/scheduler с `upstream/main`;
- вносить минимальные локальные отклонения только если без них единый маршрут не достигается.

Не входит:

- полный rollback update `v0.29.11`;
- параллельный `codex-only` маршрут;
- массовый рефактор всех ролей без конкретного failure mode;
- подмена эталона Церена локальными привычками.

## Acceptance criteria

- `Claude`, `Codex`, `Strategist`, `Extractor` и `Scheduler` читают один и тот же `workspace root`.
- hooks не зависят от того, из какого `cwd` стартовал агент.
- `MEMORY.md` и `memory/protocol-*.md` резолвятся в один живой source-of-truth.
- `~/.iwe-paths` содержит полный набор `IWE_WORKSPACE`, `IWE_TEMPLATE`, `IWE_RUNTIME`, `IWE_GOVERNANCE_REPO`.
- свежая runtime-проверка подтверждает, что automation идёт тем же маршрутом, что и ручной агент.
- все решения сверены с `upstream/main`, а отклонения перечислены явно.

## Что уже сделано

- hooks в root `.claude/settings.json` выровнены на workspace-root path;
- live-memory восстановлен в `~/.claude/projects/-Users-alexander-Github/memory`;
- `~/.iwe-paths` регенерирован через canonical `install-iwe-paths.sh`;
- root `MEMORY.md` и `memory/protocol-open.md` снова резолвятся;
- root hook scripts успешно запускаются из `DS-strategy`.

## Что осталось

1. Подтвердить, что automation `scheduler/health-check` идёт тем же маршрутом.
2. Найти и убрать оставшийся runtime drift, если launchd/scheduler всё ещё живут по старому path.
3. Зафиксировать итоговый verdict: что совпадает с Цереном, а где есть минимальное допустимое отклонение.

## Критерий завершения

РП не считается закрытым, пока:

- свежий runtime-check не подтвердит один и тот же route для ручного и автоматического контуров;
- не будет явного списка `совпадает с Цереном / локально отклонено осознанно`;
- пользователь не увидит одинаковую truthy-картину состояния у `Claude`, `Codex` и automation.
