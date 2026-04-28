---
type: work-product
id: WP-127
status: done
priority: critical
created: 2026-04-28
updated: 2026-04-29
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

## Extractor reboot-tail closed (2026-04-29 00:25)

Проверка причины `extractor-inbox-check stale after reboot` показала:

- активный `~/Library/LaunchAgents/com.extractor.inbox-check.plist` уже указывал на правильный runtime script `/Users/alexander/Github/.iwe-runtime/roles/extractor/scripts/extractor.sh`;
- сам `extractor.sh` успешно materialize status-artifact и на `2026-04-28 20:31` давал `success: no pending captures in inbox`;
- проблема была не в route/path исполнении, а в startup-policy: `com.extractor.inbox-check.plist` оставался на `RunAtLoad=false`;
- после reboot/login агент не стартовал сразу и ждал свой `StartInterval=10800`, поэтому health-layer успевал видеть stale-окно, несмотря на рабочий runtime;
- это расходилось и с соседними агентами (`strategist-morning`, `health-check`, live `session-watcher`), и с вашим историческим контуром `RunAtLoad для агентов`.

Что сделано:

- в `FMT-exocortex-template/roles/extractor/scripts/launchd/com.extractor.inbox-check.plist` включён `RunAtLoad=true`;
- то же изменение внесено в live runtime-copy `.iwe-runtime/roles/extractor/scripts/launchd/com.extractor.inbox-check.plist`;
- `roles/extractor/install.sh` переустановил `LaunchAgent`, так что live `~/Library/LaunchAgents/com.extractor.inbox-check.plist` тоже стал `RunAtLoad=true`;
- после переустановки launchd сразу materialized новый status-artifact `2026-04-29 00:25:24` с `STATUS=success`, `SUMMARY='outside work hours'`;
- свежий `health-check.sh` в `2026-04-29 00:25:35` подтвердил: `extractor-inbox-check status=success`.

Truthful вывод:

- `Extractor` у нас падал не как сценарий, а как startup-contract после reboot;
- path/env drift для него уже был закрыт раньше;
- текущий remaining yellow по `WP-127` больше не связан с `extractor-inbox-check`.

## Extractor full-loop recovery (2026-04-29 00:40)

Следующий truthful разрыв оказался глубже status-layer:

- `inbox-check` уже был зелёным, но это не доказывало, что до него реально доходит intake из Obsidian;
- live `Творческий конвеер/Сессия стратегирования/` содержал реальные session-files;
- canonical queue `DS-strategy/inbox/pending-sessions/` физически отсутствовала;
- `session-watcher` жил как локальный extractor-extension вне `upstream/main`, запускался из template-path, а не из `.iwe-runtime`;
- prompts `session-tasks.md` и часть report-layer всё ещё ссылались на legacy path `System/Сессии стратегирования` и `2. Черновики/00-Ручной разбор`.

Это значило:

- ядро extractor было уже частично рабочим;
- но связка `Obsidian brain -> Extractor` ещё не была восстановлена как единый canonical route.

Что сделано:

- `session-watcher.sh` и `com.extractor.session-watcher.plist` включены в runtime overlay, поэтому теперь materialize в `.iwe-runtime`, а не живут отдельным route;
- live `LaunchAgent` `com.extractor.session-watcher` теперь идёт через `/Users/alexander/Github/.iwe-runtime/roles/extractor/scripts/session-watcher.sh`;
- `roles/extractor/install.sh` расширен: теперь ставит оба extractor-агента, `inbox-check` и `session-watcher`, через один install-route;
- `session-watcher.sh` восстановил bridge `Творческий конвеер/Сессия стратегирования -> DS-strategy/inbox/pending-sessions/`;
- auto-queue ограничен только каноническими файлами вида `Сессия стратегирования YYYY-MM-DD_HH-MM.md`, чтобы не подхватывать governance-файлы `Strategic Session ...`;
- добавлена защита от повторного захвата уже обработанных сессий из `processed-sessions` и `archive/notes/processed-sessions`;
- prompts `session-import.md` и `session-tasks.md` выровнены на live path `Творческий конвеер/Сессия стратегирования`, с legacy fallback только как запасной маршрут;
- `chain-report.sh` перестал ссылаться только на устаревший `00-Ручной разбор` и теперь truthfully показывает human-layer snapshot через `Банк экстрактора`.

Live verification:

- `session-watcher` сам создал `DS-strategy/inbox/pending-sessions/`;
- первая сессия `2026-02-03` прошла полный маршрут:
  - queued from Obsidian
  - `session-import` success, commit `e0ca198`
  - `session-tasks` success
  - moved to `processed-sessions/`
  - `chain-report` generated
- вторая сессия `2026-02-16` прошла тот же маршрут:
  - `session-import` success, commit `5d144f5`
  - `session-tasks` success, commit `596d340`
  - moved to `processed-sessions/`
  - финальный `chain-report` показал `Pending sessions: 0`, `Processed sessions: 2`

Truthful вывод:

- для локального Obsidian-expanded контура `Extractor` снова работает end-to-end, а не только как isolated `inbox-check`;
- это не “чистый upstream Tseren one-to-one”, потому что `session-watcher`, `session-tasks` и Obsidian bridge вообще отсутствуют в `upstream/main`;
- но после фикса это локальное расширение снова живёт на том же install/runtime/env route, что и остальной agent layer, а не на отдельной поломанной траектории.

## Финальный verdict (2026-04-29)

РП закрыт как `done`.

Что подтверждено:

- `Claude`, `Codex` и automation снова опираются на один workspace-root, один `memory` route и один `.iwe-runtime`;
- hooks больше не зависят от `cwd`;
- `~/.iwe-paths` восстановлен как source-of-truth для `IWE_*`;
- status-artifacts materialize штатно;
- `Extractor` подтверждён end-to-end, включая Obsidian bridge;
- свежий `health-check` после refresh `Доски выбора` даёт `✅ Среда исправна`.

Что сверено с Цереном и признано осознанным локальным расширением, а не drift-дефектом:

- `Scout` — optional/local слой в `DS-agent-workspace`, не core-runtime;
- `Доска выбора` — local human-layer beacon, не upstream-core;
- `session-watcher` и Obsidian bridge у `Extractor` — локальное расширение поверх общего runtime route;
- absolute root hook paths в `.claude/settings.json` — минимальное локальное отклонение ради одного маршрута из любого `cwd`.

Итог:

- единый canonical route для `Claude/Codex/runtime` восстановлен;
- дальнейшие хвосты относятся уже не к route alignment, а к отдельным продуктовым/управленческим контурам вроде `WP-101`.
