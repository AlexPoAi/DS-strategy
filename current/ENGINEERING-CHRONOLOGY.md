---
type: engineering-chronology
 updated: 2026-04-21 19:40
source_of_truth: DS-strategy/inbox/INBOX-TASKS.md + PACK-exocortex-engineering/04-work-products
---

# Engineering Chronology (Exocortex)

## Зачем
- Один журнал инженерных решений и незакрытых хвостов.
- Цель: не переделывать одно и то же, каждый новый агент заходит в контекст за 5-10 минут.

## Ключевые вехи (что уже сделано)
1. 2026-03-26 → 2026-03-30: стабилизация базовых путей/entrypoints и notify-контур (`ENG.WP.001`..`ENG.WP.004`).
2. 2026-04-05: reliability-блок по Strategist + модельные fallback/always-on направления (`ENG.WP.019`..`ENG.WP.021`, `ENG.WP.023`).
3. 2026-04-07: codex-primary миграция, runtime-arbiter, восстановление daily Telegram отчётов, truthful close-flow (`ENG.WP.024`..`ENG.WP.028`).
4. 2026-04-08 → 2026-04-13: агентный hardening + target-capability implementation + recovery loop + opening/open-contract modernization (`ENG.WP.030`..`ENG.WP.038`, `WP-60`).
5. 2026-04-15: найден и закрыт root-cause зависаний `strategist morning` (ошибочный route `day-plan -> protocol-open`), открыт `WP-61` для финальной стабилизации 24/7 и решения по pristine-reset.
6. 2026-04-15: в `WP-62` материализован складской автоконтур (`sync -> cards -> bot kb -> telegram`), добавлены quota-retry/backoff и launchd full-loop entrypoint.
7. 2026-04-15: открыт `WP-63` как production-hardening слой для склада (registry, DLQ, idempotency, Drive contract, daily health-report).
8. 2026-04-15: в `WP-63` реализована итерация `WH.REGISTRY` — pipeline фиксирует статусы `new/processed/duplicate/error` и показывает операционные счётчики в warehouse summary.
9. 2026-04-16: в `WP-63` реализован `DLQ/quarantine` для склада — проблемные CSV уходят в quarantine-folder и получают отдельный DLQ-report.
10. 2026-04-16: найден production-risk в Telegram bot layer — `monitor_bot.py` мог использовать тот же `TELEGRAM_BOT_TOKEN`, что и product bot. Контур разделён на отдельный `MONITOR_BOT_TOKEN`, чтобы не создавать повторный `409 Conflict` своими же руками.
11. 2026-04-16: устранён runtime-gap `extractor inbox-check` (headless hardening + актуальный extraction-report), статус экзокортекса возвращён в зелёный контур.
12. 2026-04-16: открыт `WP-64` для рефактора инженерного backlog (дедупликация задач, единый closeout-порядок и anti-rework контракт).
13. 2026-04-16: `WP-61` закрыт — зафиксированы success-окна strategist, выбран путь `controlled migration`, материализован rollback runbook до `pristine-reset`.
14. 2026-04-16: по `WP-63` на VPS зафиксирован `WAREHOUSE_REPORT_CHAT_ID` и установлен `vk-warehouse-full-loop.timer`; выявлен blocker `credentials.json` (Google OAuth) для старта sync, сервис переведён в graceful-skip до загрузки секрета.
15. 2026-04-16: blocker `WP-63` снят — `credentials.json` и `token.pickle` доставлены на VPS, установлен Python venv для `.github/scripts`, запущен длинный warehouse sync с рабочим retry/backoff на `429`.
16. 2026-04-17: открыт `WP-69` для pristine-выравнивания под Церен; в `FMT-exocortex-template` убраны персональные хардкоды и восстановлен skeleton-контур `memory/MEMORY.md` (`validate-template` снова зелёный), в `DS-strategy/exocortex` нормализован opening contract (`memory/MEMORY.md` вместо legacy `MEMORY.md`).
17. 2026-04-17: в post-check `WP-69` выявлен повторный drift root-копий `exocortex/protocol-open.md` и `exocortex/checklists.md`; canonical маршрут `memory/MEMORY.md` повторно восстановлен и закреплён как обязательная проверка перед close.
18. 2026-04-17: зафиксирован внешний blocker `Anthropic organization disabled`; оформлен support-case и отправлен appeal в Trust & Safety. До ответа включена policy: только свои credentials + fallback runtime для непрерывности инженерного контура.
19. 2026-04-19: выполнен Codex-first UX hardening в VS Code (startup без Welcome, one-click/hotkey на `New Codex Agent`, удаление конфликтных chat-расширений) и открыт `WP-70` для production-мультимодальности Codex Pro.
20. 2026-04-19: как приоритет недели W16 открыт `WP-71` — предметные агенты и skill-контур для `VK-offee` (бар/кухня/сервис/маркетинг/финансы) с привязкой к репозиторию и практическим артефактам.
21. 2026-04-19: `WP-64` закрыт — выполнена повторная дедупликация `INBOX-TASKS`, сняты устаревшие инженерные pending и нормализован набор `in_progress` до фактически активных контуров.
22. 2026-04-19: открыт `WP-75` под складского предметного агента (`Warehouse Demand Analyst`) и проведён VPS post-check: `vk-warehouse-full-loop.timer` активен, но в папке `Новое` сейчас `0` таблиц; следующий шаг — подтверждение intake для `.xlsx/.csv` и появление ABC-файлов в рабочем окне.
23. 2026-04-19: в план дня добавлен критичный `WP-76` после red-сигнала Exocortex (`Планировщик экзокортекса не загружен`) с обязательным bootstrap recovery и post-check.
24. 2026-04-19: для нового агента `Knowledge Registry Curator` создан первый агентский skill `notes-registry-and-domain-mapping`; capability зафиксирован до будущей миграции в `PACK-agent-skills` (`WP-82`).
25. 2026-04-19: выполнен первый live proof run `Knowledge Registry Curator`; дополнительно зафиксировано новое обязательное инженерное требование — этот агент должен получить отдельный `24/7 VPS runtime` контур.
26. 2026-04-19: по `WP-75` материализован supplier-layer склада — архитектура цикла кладовщика, supplier map по PDF-накладным, индекс supplier cards, manager-friendly карточки поставщиков с оборотом периода и частично подтверждёнными контактами из баристского supplier-файла.
27. 2026-04-19: в `WP-89` зафиксирован следующий системный slice — единый `DOCUMENT-REGISTRY` по всей базе знаний как master-layer над локальными registry по доменам.
28. 2026-04-20: открыт `WP-96` / `ENG.WP.042` на системную ликвидацию оставшихся `Claude-first` canonical routes; symptom `Not logged in · Please run /login (Claude path)` признан не локальным auth-хвостом, а инженерным дефектом route-layer.
29. 2026-04-20: открыт `WP-98` по складу для bounded hardening manager-layer: устранение битого SKU, удержание `WH.SESSION.001` как decision board и разведение supplier routing `Тэйсти Кофе` / `Субмарина`.
30. 2026-04-20: дополнительно зафиксирован guardrail: временные sidecar-аудиторы без согласования не считаются допустимым шаблоном; повторяющиеся складские задачи должны усиливать skill постоянного агента `Кладовщик VK Coffee`, а не подменять его новым агентом.
31. 2026-04-20: в рамках `WP-96` / `ENG.WP.042` закрыт отдельный repair-slice `synchronizer status freshness`: `scheduler.sh` и `daily-report.sh` теперь materialize свежие `.status` для `synchronizer-code-scan` и `synchronizer-daily-report`, чтобы execution-layer, health-check и report-layer больше не расходились по evidence.
32. 2026-04-20: `WP-96` / `ENG.WP.042` закрыт полностью: дополнительно materialized `notify outbox evidence`, поэтому Telegram transport-layer теперь оставляет прямой локальный след сообщений, а не только косвенные delivery-логи.
33. 2026-04-21: `WP-76` закрыт truthfully до конца — найден semantic-tail в `strategist-week-review` skip-path (`STALENESS_BUDGET_SEC=86400` вместо weekly `604800`), из-за которого opening/status artifacts ложнопоказывали `yellow/stale` на следующий день; после точечного фикса в `strategist.sh` и refresh `daily-report.sh --refresh-status-artifacts` `SESSION-OPEN` и `AGENTS-STATUS` вернулись в полностью зелёный контур.
34. 2026-04-21: открыт planning-контур `WP-99` / `ENG.WP.043` на превращение `Obsidian` в human-facing мозг поверх `Extractor` и `Strategist`: зафиксирована целевая архитектура `Obsidian = human layer`, `captures = machine queue`, `DS-strategy = governance`, `Pack = knowledge source-of-truth`, а первым bounded slice выбран `Selection Board v1` с safety-beacons.
35. 2026-04-21: в `WP-97` выполнен первый warehouse hardening после ритуального согласования — кладовщик переведён на supplier-card manager format: `WH.REPORT.002`, `WH.SESSION.001` и Telegram-слой теперь группируют срочный заказ по поставщику с общим каналом и общим базовым дедлайном вместо повторения контактов на каждой SKU-строке.
36. 2026-04-21: в `WP-97` усилен `ABC`-слой кладовщика: `warehouse_reports_pipeline.py` научен читать `xlsx` по листам, выбирать лучший `ABC`-лист по quality signal (`matched_rows / unmatched_rows / total_rows`) и материализовать evidence `sheet/status/matched/unmatched`; truthful verdict после live run — кодовый слой усилен, но в живом intake `ABC` пока ещё не подхватывается как реальный источник.
37. 2026-04-21: в `WP-97` закрыт factual audit по `ABC intake`: warehouse sync переведён с intake-подпапки на весь warehouse root, `.xlsx`/`pdf` гарантированно materialize локально, а `ABC анализ1/2.xlsx` возвращены из `Обработано` в `Новые документы`.
38. 2026-04-21: corrected verdict по `ABC` — исходные файлы не были пустыми; root-cause оказался в `sync-google-sheets.py`, где `openpyxl` в режиме `read_only=True` обрезал `ABC`-xlsx до первых 10 строк. После фикса на normal-mode и live sync кладовщик снова увидел `ABC`, а `WH.REPORT.002` поднялся до `320` SKU с ABC-категорией.
39. 2026-04-28: открыт `WP-127` под canonical route alignment — после update из upstream Церена `v0.29.11` подтверждено требование пользователя: `Claude`, `Codex` и automation должны ходить по одному маршруту. Сверка с `upstream/main` показала канон `workspace root + memory symlink + .iwe-runtime + install-iwe-paths.sh`; первично уже выровнены root hooks, live-memory и `~/.iwe-paths`, дальше нужен runtime-check scheduler/health-check.
40. 2026-04-28: первый verification pass по `WP-127` подтвердил, что manual route и automation route снова сблизились: `health-check` зелёный по canonical protocol route, `launchd` загружен, `strategist-morning/week-review` и `synchronizer-*` успешны, а старый symptom `{{IWE_RUNTIME}}/... not found` в свежем прогоне не повторился. Открыты только остаточные хвосты `selection board stale`, `extractor stale after reboot` и необходимость пересобрать status artifacts.
41. 2026-04-28: в `WP-127` найден следующий локальный drift уже внутри reporting-layer: после update из Церена из `daily-report.sh` выпал маршрут `--refresh-status-artifacts`, хотя на него продолжали опираться `daily-telegram-report`, `AGENTS-STATUS` и `SESSION-OPEN`. Refresh-route восстановлен без отката всего файла назад: сохранён portable `IWE_WORKSPACE/IWE_GOVERNANCE_REPO` слой, а `RUNTIME-MODE`, `AGENTS-STATUS` и `SESSION-OPEN` снова materialize штатно по одному canonical route.

## Что критично открыто (не закрыто)
1. `ENG.WP.031`: довести агентный слой до целевого состояния без зависших статусов и с подтверждённым full-loop.
2. Connector parity Codex/Claude (`Google Drive + Gmail`) — критичный pending в `INBOX-TASKS`.
3. Ритуальные WP (`WP-21/WP-28/WP-29`) — закрывать только после синхронизации всех трекеров.
4. `WP-62`: подтвердить финальный warehouse Telegram chat routing (`WAREHOUSE_REPORT_CHAT_ID`) и стабильность 2+ циклов подряд.
5. `WP-63`: внедрить storage-governance склада и закрепить архитектуру поставки документов из Google Drive.
6. `WP-64`: завершить дедупликацию инженерных задач и удерживать единый weekly closeout-порядок.
7. `WP-69`: закрыть финальный postcheck по brain verdict после template-first выравнивания.
8. `WP-62/WP-63`: подтвердить 2-3 стабильных warehouse цикла на VPS и закрыть production-tail.
9. `WP-69`: дождаться verdict по Anthropic appeal и зафиксировать post-incident credentials contract.
10. `WP-70`: подтвердить стабильность Codex UX после restart/VPN-flap и зафиксировать image-workflow runbook.
11. `WP-71`: материализовать минимум 3 доменных агента VK-coffee и провести live-пилот.
12. `WP-75`: закрепить складской агентный протокол и получить стабильные actionable карточки на каждой новой поставке данных Жанны.
14. `WP-75`: довести decision-layer `low-stock -> supplier -> contact -> deadline` и получить первую manager-ready закупочную карточку.
15. `WP-97`: довести `ABC` до реального intake-path и затем реализовать `PDF invoice -> line items -> supplier/date/price/confidence`.
16. `WP-127`: подтвердить, что manual-agent route и automation route совпадают и не расходятся между `Claude`, `Codex` и scheduler.

## Правило anti-rework (обязательный старт)
1. Прочитать этот файл + `current/SESSION-CONTEXT.md`.
2. Проверить соответствующий `WP-xx` контекстный файл.
3. Сверить статус в `INBOX-TASKS.md` и `ENG.WP.000-repair-registry`.
4. Только после этого вносить кодовые/процессные изменения.

## Быстрые ссылки
- `DS-strategy/inbox/INBOX-TASKS.md`
- `DS-strategy/current/SESSION-CONTEXT.md`
- `DS-strategy/inbox/WP-60-opening-open-contract-modernization (Переделка opening и open-contract контура).md`
- `DS-strategy/inbox/WP-61-strategist-24x7-stabilization-and-pristine-reset-decision (Стабилизация Strategist 24x7 и решение по pristine-reset).md`
- `DS-strategy/inbox/WP-62-warehouse-autocontour-cards-and-telegram-reports (Складской автоконтур карточек и Telegram-отчетов).md`
- `DS-strategy/inbox/WP-63-warehouse-governance-and-drive-architecture-hardening (Доведение governance склада и архитектуры Google Drive).md`
- `DS-strategy/inbox/WP-64-engineering-contour-refactor-and-closeout-plan (Рефактор инженерного контура и план закрытия хвостов).md`
- `DS-strategy/inbox/WP-69-exocortex-pristine-alignment-with-tseren (Pristine-выравнивание экзокортекса под Церен).md`
- `DS-strategy/inbox/ENG-SUPPORT-ANTHROPIC-2026-04-17 (Appeal по disabled organization).md`
- `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.000-repair-registry (Реестр инженерных работ по экосистеме).md`
