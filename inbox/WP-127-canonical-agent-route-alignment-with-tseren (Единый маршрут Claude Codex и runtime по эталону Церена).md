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

Дополнительно 2026-04-29 подтверждена причина различия Day Close отчётов `Claude` и `Codex`:

- `Claude` по умолчанию попадает в `/Users/alexander/Github/.claude/skills/day-close/SKILL.md`;
- на шаге `11. Верификация (Haiku R23)` он запускает отдельного verifier-subagent с чеклистом Day Close;
- именно этот verifier возвращает формат `PASS / PASS WITH WARNINGS / FAIL`;
- `Codex` раньше шёл через manual/protocol route и не читал Claude skill как canonical method, поэтому выдавал другой формат.

Для `Extractor` подтверждено отдельное различение:

- root skill `/Users/alexander/Github/.claude/skills/экстрактор/SKILL.md` сейчас отсутствует;
- canonical template skill есть в `/Users/alexander/Github/FMT-exocortex-template/.claude/skills/экстрактор/SKILL.md`;
- skill `экстрактор` отвечает за применение KE/extraction-report через `roles/extractor/prompts/apply-ke-report.md`;
- создание отчёта (`inbox-check`, `session-close`, `session-import`) живёт в runtime route `roles/extractor/scripts/extractor.sh` и prompt-файлах `roles/extractor/prompts/`;
- truthful acceptance для Codex/Claude должен сверяться с `roles/extractor/ACCEPTANCE.md`.

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
- установлен локальный Codex bridge-skill `/Users/alexander/.codex/skills/iwe-claude-route-bridge/SKILL.md`: он не копирует Claude skills, а заставляет Codex читать live `.claude/skills/*/SKILL.md` как canonical method для IWE-ритуалов.

## Первый verification pass (2026-04-28 23:51)

Свежий запуск `health-check.sh` + `scheduler.sh status` дал такой truthful результат:

- `launchd` для scheduler и health-check загружен;
- canonical protocol route теперь зелёный: `memory`, `MEMORY.md`, `protocol-open/work/close`;
- runtime arbiter видит `provider=codex`, `codex=available`, `claude=available`;
- `strategist-morning`, `strategist-week-review`, `synchronizer-code-scan`, `synchronizer-daily-report` — `success`;
- вчерашний `{{IWE_RUNTIME}}/... not found` в свежем прогоне **не воспроизвёлся**.

Остаточные предупреждения:

- `selection board stale`;
- `extractor-inbox-check` отмечен stale после перезагрузки;
- `strategist-note-review` stale в пределах нормального окна после reboot;
- `AGENTS-STATUS.md` как артефакт дня ещё не пересобран под новый verification pass, поэтому исторически остаётся жёлтым.

## Что осталось

## Второй verification pass (2026-04-28 23:59)

Выявлен и сразу закрыт ещё один drift внутри локального synchronizer-layer:

- история `DS-strategy` и `daily-telegram-report.sh` продолжали считать каноническим маршрут `daily-report.sh --refresh-status-artifacts`;
- в текущем `FMT-exocortex-template/roles/synchronizer/scripts/daily-report.sh` после update этот refresh-route фактически выпал;
- из-за этого `AGENTS-STATUS.md` и `SESSION-OPEN` не пересобирались штатным путём, хотя health/runtime verdict уже был новым.

Что сделано:

- в `daily-report.sh` восстановлен refresh-layer `--refresh-status-artifacts` и materialization `AGENTS-STATUS.md`, `SESSION-OPEN`, `RUNTIME-MODE.md`;
- при этом сохранён нынешний portable env-route через `IWE_WORKSPACE` / `IWE_GOVERNANCE_REPO`, чтобы не откатываться широко назад;
- после live-run `daily-report.sh --refresh-status-artifacts` status-артефакты снова materialize штатно.

Truthful результат после пересборки:

- `Canonical protocol route` — `🟢`;
- `Runtime arbiter` — `🟢`;
- `Provider plane` — `primary=codex`, `codex=available`, `claude=available`;
- `Статус-артефакты` — снова materialize штатно и согласованы с runtime mode;
- полный мозг экзокортекса остаётся `🟡`, потому что `strategist-note-review` и `extractor-inbox-check` сейчас truthful `stale`, а не из-за route/path defect.

Сверка с Цереном по этому месту:

- сам `daily-report` refresh-layer является локальным расширением, а не прямым upstream-файлом `upstream/main`;
- значит, тут не было задачи «вернуться один в один к Церену», а была задача не потерять локально принятый канонический route, который уже использует `daily-telegram-report` и инженерный протокол.

## Codex bridge decision (2026-04-29)

Принято решение не копировать все Claude skills в Codex, потому что это создало бы второй источник правды и новый drift после обновления Церена.

Выбран вариант:

- `Claude/Tseren skills` остаются canonical source-of-truth;
- `Codex` получает тонкий adapter/bridge;
- при командах вроде `закрой день`, `day close`, `открой день`, `run protocol`, `проверь как Claude` Codex должен читать соответствующий live skill из `/Users/alexander/Github/.claude/skills/`;
- если Claude skill требует subagent verifier, а Codex не может или не должен запускать subagent, Codex локально воспроизводит тот же verifier prompt/checklist и явно называет это `R23-style verification`.
- для `day-open` Codex должен следовать Claude route: первым действием `date`, затем ordered Day Open steps, запись DayPlan, checks, commit/push и compact dashboard.
- для `extractor` Codex должен держать два режима раздельно: report-generation через runtime/prompts и report-application через skill `экстрактор`; если root skill отсутствует, читать template skill и назвать это route drift, а не создавать Codex-only extractor flow.

Первый установленный adapter:

- `/Users/alexander/.codex/skills/iwe-claude-route-bridge/SKILL.md`

Это локальная Codex-настройка вне git; в этом WP зафиксирован её смысл и путь. На 2026-04-29 bridge явно покрывает `day-close`, `day-open` и `extractor`.

## Что осталось

1. Проверить, является ли `strategist-note-review stale` нормальным состоянием окна на `23:59` или это отдельный scheduling-tail.
2. Проверить, почему `extractor-inbox-check` остаётся stale после reboot, если route уже зелёный.
3. Зафиксировать итоговый verdict: что совпадает с Цереном, а где есть минимальное допустимое локальное расширение.

## Критерий завершения

РП не считается закрытым, пока:

- свежий runtime-check не подтвердит один и тот же route для ручного и автоматического контуров;
- не будет явного списка `совпадает с Цереном / локально отклонено осознанно`;
- пользователь не увидит одинаковую truthy-картину состояния у `Claude`, `Codex` и automation.
