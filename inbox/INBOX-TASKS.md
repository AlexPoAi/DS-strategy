---
type: inbox
created: 2026-03-04
---

- [in_progress] 2026-04-08: [AGENTS] Довести агентный слой до реально подтверждённого целевого состояния
  - Контекст: пользователь справедливо заметил разрыв между замыслом агентной архитектуры и фактически подтверждённым поведением. Сейчас часть ролей уже работает, но такие способности как структурный разбор хаоса репозиториев, recovery потерянных входов, point-level каталогизация и автономное поддержание knowledge layer пока существуют скорее как design intent, а не как доказанная operational capability.
  - Цель: перевести агентные роли из режима `задумано` в режим `реально выполняет`, с явными acceptance-критериями и проверкой устойчивости.
  - Что сделать:
    1. Для каждого ключевого агента описать две зоны: `подтверждённо умеет сейчас` и `целевое состояние`
    2. Убрать из role/docs завышенные claims, которые не подтверждены практикой
    3. Для `Strategist`, `Extractor`, `Knowledge Engineer`, `Environment Engineer`, `Scheduler/Synchronizer` определить конкретные сценарии, которые агент обязан пройти end-to-end
    4. Собрать test matrix: какие реальные задачи агент должен выполнить, чтобы capability считалась доказанной
    5. Прогнать verification cycle и отдельно проверить, что агент не ломается в процессе длительной работы, повторного запуска, ошибок среды и частичного recovery
    6. Зафиксировать truthful verdict по каждому агенту: `ready / partial / design-only / broken`
  - Acceptance:
    - по каждому агенту есть список подтверждённых capabilities;
    - есть минимум один живой сценарий end-to-end с артефактом результата;
    - недоказанные обещания убраны или помечены как target capability;
    - зафиксированы failure modes и post-check;
    - есть итоговая карта зрелости агентного слоя.
  - Приоритет: critical
  - Бюджет: 3-5h
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.030-agent-capability-hardening-and-verification (Доведение агентного слоя до подтверждённого целевого состояния).md`
    - обновлённые role/docs по агентам

- [pending] 2026-04-08: [STRUCTURE] Развернуть point-level knowledge layer для точек VK-offee
  - Контекст: пользователь зафиксировал правильную логику: Самокиша, Тургенева и Луговая — это не просто разрозненные документы в `knowledge-base`, а отдельные operational точки со своими договорами, арендой, подрядчиками и вопросами согласования. Уже поднят первый pilot `POINT-samokisha`, и теперь нужен дисциплинированный структурный контур с ритуалом открытия/закрытия и явным агентным составом.
  - Что сделать:
    1. Закрепить `POINT-samokisha` как первый point-level source-of-truth слой
    2. Определить границу `point-specific vs shared network docs`
    3. Тем же паттерном поднять `POINT-turgeneva` и `POINT-lugovaya`
    4. Добавить перекрёстные ссылки на общие документы сети без лишнего дублирования
    5. Синхронизировать этот контур с recovery-задачей по потерянным входам и заметкам
  - Агентный состав:
    - `Strategist` — логика структуры и очередность разворачивания точек
    - `Extractor` — сбор документов и потерянных point-specific материалов
    - `Knowledge Engineer` — каталоги, индексы, source-of-truth слой
    - `Environment Engineer` — opening/closing ритуалы и фиксация WP
  - Приоритет: high
  - Бюджет: 2-3h на первый полный цикл
  - Артефакт:
    - `VK-offee/PACK-cafe-operations/04-work-products (Рабочие продукты)/CO.WP.004-point-knowledge-hub-pilot-samokisha (Point-level knowledge hub для точки Самокиша).md`
    - `VK-offee/POINT-samokisha/`

- [pending] 2026-04-08: [UPSTREAM] Проверить обновления Церена и механизм безопасного применения его изменений
  - Контекст: пользователь заметил, что у Церена вышли какие-то обновления, и справедливо ожидает, что у нас должен быть понятный контур: где смотреть его изменения, как их сравнивать с нашим форком и как безопасно применять только нужное.
  - Что сделать:
    1. Проверить `upstream` в `FMT-exocortex-template` и собрать список новых коммитов/изменений
    2. Сверить это с нашим текущим `update.sh`, `update-manifest.json` и локальными кастомизациями
    3. Отдельно оценить, есть ли у Церена полезные обновления в knowledge/prompt/runtime слоях, которые нам нельзя пропустить
    4. Зафиксировать truthful runbook: `check -> diff -> apply -> post-check`
  - Приоритет: high
  - Бюджет: 45-60 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.029-upstream-update-audit-and-apply-contract (Аудит upstream-обновлений Церена и контракт их применения).md`

- [pending] 2026-04-08: [RECOVERY] Восстановить потерянные задачи, заметки и пользовательские входы в единый каталог
  - Контекст: пользователь прямо чувствует, что значительная часть мыслей, запросов и рабочих заготовок потерялась внутри множества репозиториев, Telegram-captures, extraction-reports, processed sessions и разрозненных заметок. Это уже не одна потерянная запись, а системный recovery-контур.
  - Что сделать:
    1. Собрать карту всех источников входящих: `captures.md`, `fleeting-notes.md`, `inbox/processed-sessions`, `inbox/extraction-reports`, scout results, Telegram-derived files
    2. Найти задачи/идеи/запросы, которые не дошли до нормального `INBOX` или до отдельных WP
    3. Сложить это в единый recovery-каталог с дедупликацией и пометками `new / already tracked / rejected`
    4. Вернуть живые элементы обратно в контур Extractor/Strategist, чтобы они снова могли попадать в список рабочих продуктов
  - Приоритет: critical
  - Бюджет: 2-3h
  - Артефакт:
    - `DS-strategy/inbox/RECOVERY-CATALOG-LOST-INPUTS-2026-04-08.md`
    - обновлённый `INBOX-TASKS.md`

- [done] 2026-04-07: [ENGINEERING] Close-flow — сделать SESSION-CONTEXT обязательной частью реального закрытия
  - Контекст: пользователь справедливо заметил разрыв доверия в закрытии сессии. Рабочие продукты и коммиты могли сохраняться, но `SESSION-CONTEXT.md` при этом оставался мартовским, из-за чего закрытие выглядело успешным только частично. Для экосистемы это недопустимо: контекст должен переписываться в той же логической цепочке, что и WP/артефакты.
  - Что сделано:
    1. В `close-task.sh` убраны жёстко прошитые мартовские поля (`W12`, неделя 2026-03-16 → 2026-03-22, `Claude Sonnet 4.6`)
    2. Автозапись `SESSION-CONTEXT.md` переведена на динамические значения текущей недели, диапазона дат и активного агента
    3. Верхний пролог `Последнее обновление` теперь тоже переписывается, а не остаётся старым
    4. Добавлен gate: success запрещён, если `SESSION-CONTEXT.md` не обновился текущим timestamp/датой
    5. Сам `SESSION-CONTEXT.md` вручную выровнен под реальное состояние W15/Codex и сохранён отдельным коммитом
    6. В успешный финал `close-task.sh` добавлен Telegram day-close summary через `notify.sh synchronizer day-close`, чтобы закрытие дня автоматически завершалось пользовательским отчётом
  - Приоритет: critical
  - Бюджет: 30-45 мин
  - Артефакт:
    - `~/Github/close-task.sh`
    - `DS-strategy/current/SESSION-CONTEXT.md`

- [done] 2026-04-07: [ENGINEERING] Восстановить дневные Telegram-отчёты синхронизатора
  - Контекст: пользователь перестал получать в течение дня большие Telegram-отчёты о состоянии агентов. При этом markdown-артефакты `daily-report` продолжали создаваться, что означало разрыв между report generation и Telegram delivery.
  - Что сделано:
    1. В `scheduler.sh` починены runtime paths для role runner discovery
    2. Устранён `set -e` abort в блоке `strategist morning`, который мог обрывать dispatch до Telegram-шага
    3. Восстановлен проход scheduler до `daily-telegram-report`
    4. Усилен сам текст daily Telegram report: brain verdict, runtime mode, block `Что требует внимания`
    5. Подтверждена реальная отправка в Telegram и появление marker-файлов доставки
  - Приоритет: high
  - Бюджет: 45 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.028-scheduler-telegram-report-recovery (Восстановление дневных Telegram-отчётов синхронизатора).md`
- [done] 2026-04-07: [ENGINEERING] Runtime arbiter для равноправного выбора Codex / Claude по доступности
  - Контекст: после `Codex-primary` миграции система стала устойчивее, но всё ещё жила с hardcoded operational default. Пользовательский вектор другой: `Codex` и cloud/Claude provider paths должны работать на равных, а primary path должен определяться по реальной доступности и продлённой подписке, а не по старой привязке к одному vendor'у.
  - Что сделано:
    1. Добавлен `runtime-arbiter.sh` как единый source-of-truth для provider/runtime plane
    2. Введён `DS-strategy/current/RUNTIME-POLICY.env`
    3. `strategist.sh` и `extractor.sh` переведены на `AI_CLI_PROVIDER_PRIMARY=auto`
    4. `health-check.sh` перестал считать Anthropic helper единственным критическим auth/runtime verdict'ом
    5. `daily-report.sh`, `AGENTS-STATUS.md` и opening screen теперь показывают runtime mode и provider resolution
  - Приоритет: high
  - Бюджет: 45-60 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.027-runtime-arbiter-codex-cloud-parity (Арбитр доступности Codex и Cloud provider plane).md`

- [done] 2026-04-07: [ENGINEERING] Provider fallback `Claude -> Codex` для агентного слоя
  - Контекст: после каскада `Haiku -> Sonnet` агентный слой всё ещё зависел от одного vendor-path. Если Anthropic runtime/auth/preflight ломается, runner'ы снова деградируют в hard fail. При этом в среде уже доступен рабочий `codex` CLI (`login status: Logged in using ChatGPT`).
  - Что сделано:
    1. В `strategist.sh` добавлен provider fallback `Claude -> Codex`
    2. В `extractor.sh` добавлен provider fallback `Claude -> Codex`
    3. Введены `AI_CLI_PROVIDER_FALLBACK`, `CODEX_PATH`, `CODEX_MODEL`
    4. Логи теперь фиксируют `provider=codex`
    5. Пройдены mock smoke tests для обоих runner'ов
  - Приоритет: high
  - Бюджет: 45-60 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.024-provider-fallback-claude-to-codex (Provider fallback Claude→Codex для агентного слоя).md`

- [done] 2026-04-07: [ENGINEERING] Codex-primary миграция локального агентного слоя
  - Контекст: provider fallback уже был добавлен, но operational default всё ещё оставался Claude-first. Пользовательский вектор — перевести локальных агентов на более стабильный Codex-path, сохранив Claude как запасной путь.
  - Что сделано:
    1. В `strategist.sh` и `extractor.sh` добавлен `AI_CLI_PROVIDER_PRIMARY`
    2. Дефолт переведён на `codex`
    3. `Claude` оставлен fallback-provider'ом
    4. Документация и архитектурный контур обновлены под `Codex-primary / Claude-fallback`
    5. Legacy extractor entrypoint переведён на `ai-run.sh`, старый `claude-run.sh` оставлен wrapper'ом
    6. README / IWE-HELP / LEARNING-PATH / onboarding-guide выровнены под AI-CLI-first wording
  - Приоритет: high
  - Бюджет: 45 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.025-codex-primary-agent-migration (Codex-primary миграция локального агентного слоя).md`

- [done] 2026-04-07: [ENGINEERING] Open protocol routing — устранить пустой canonical path для `memory/protocol-open.md`
  - Контекст: в корневом `CLAUDE.md` opening route указывает на `memory/protocol-open.md`, но по этому пути файла нет. В реальной среде протокол открытия живёт в `DS-strategy/exocortex/memory/protocol-open.md` и/или `FMT-exocortex-template/memory/protocol-open.md`. Получается разрыв между объявленным canonical route и фактическим source-of-truth.
  - Почему это нельзя оставлять: агент получает ссылку, которая должна быть рабочей по контракту экосистемы. Недопустимо, чтобы в стартовом протоколе была пустая ссылка или битый путь даже при наличии обходного маршрута.
  - Что сделать:
    1. Определить единый canonical source-of-truth для open protocol на уровне workspace
    2. Устранить пустой маршрут: либо создать файл по `memory/protocol-open.md`, либо исправить ссылки в корневом `CLAUDE.md` и связанных раннерах
    3. Проверить same issue для `memory/protocol-work.md` и `memory/protocol-close.md`
    4. Добавить smoke-check, который валит opening-state при битом canonical path
  - Приоритет: critical
  - Бюджет: 30-45 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.022-open-protocol-routing-fix (Починка canonical route протоколов открытия).md`
  - Итог: done — восстановлен workspace symlink `~/Github/memory -> ~/.claude/projects/-Users-alexander-Github/memory`, canonical `protocol-open/work/close` снова резолвятся из корня, в `health-check.sh` и `daily-report.sh` добавлен smoke-check на broken/missing canonical protocol route

- [done] 2026-04-05: [ИНЖ] R-1: Автопереиндексация RAG после push VK-offee
  - Контекст: WF-3 разорван — ChromaDB на VPS не обновляется при изменении Pack. Бот отвечает по устаревшей базе. Выявлено: ENG.WP.014 (Workflow Architect audit).
  - Что сделать: добавить server-side `systemd timer` на VPS → проверка `origin/main` в `VK-offee` → запуск `indexer.py` только при изменении HEAD → restart `vk-rag-api`
  - Приоритет: high
  - Бюджет: 1h
  - Артефакт: ENG.WP.017-rag-auto-reindex-after-push (Автопереиндексация RAG после push в VK-offee).md
  - Итог: done — `vk-rag-reindex.timer` установлен на VPS `72.56.4.61`, первый полный reindex завершён (`263` файлов, `579` документов), повторный запуск без новых коммитов корректно уходит в `pack unchanged`

- [done] 2026-04-05: [ИНЖ] R-3: Разделить RAG-индекс на core knowledge и Saby analytics
  - Контекст: Saby-данные нужны, но их нельзя держать в одной коллекции с operational Pack-knowledge. Иначе продуктовый бот загрязняется накладными и закупочной аналитикой.
  - Что сделать:
    1. Разделить индексацию на `core` и `saby` коллекции
    2. Обычные вопросы направлять в `core`
    3. Вопросы о закупках/накладных/поставщиках направлять в `saby`
    4. Обновить `/health` и `/stats` под multi-collection
  - Приоритет: high
  - Бюджет: 1.5h
  - Артефакт: `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.026-rag-core-saby-split (Разделение RAG на core knowledge и Saby analytics).md`
  - Результат: done — в `VK-offee-rag` подтверждены две отдельные коллекции (`core`, `saby`), query routing разделяет обычные вопросы и закупочно-аналитические запросы, `/health` и `/stats` отдают per-collection status, добавлен regression-test `tests/test_routing.py`

- [done] 2026-04-05: [ИНЖ] R-2: Каскадный fallback моделей в агентах (Haiku → Sonnet, Opus запрещён)
  - Контекст: Haiku недоступен на текущем ключе, Opus вызывает 429 cost limit. Нужен fallback: пробуем Haiku → если недоступен → Sonnet. Opus полностью отключить.
  - Архитектура:
    ```
    run_claude() {
      try: claude-haiku-4-5 → если exit=model_unavailable → try: claude-sonnet-4-6
      Opus: ЗАПРЕЩЁН (удалить из всех скриптов)
    }
    ```
  - Где применить:
    1. `strategist.sh` — все сценарии (morning, week-review, note-review, day-close)
    2. `extractor.sh` — inbox-check
    3. `scheduler.sh` — dispatch логика проверена, изменения не требуются
  - Как проверено:
    1. `bash -n` для `strategist.sh` и `extractor.sh`
    2. mock smoke test fallback-сценария `Haiku -> Sonnet`
  - Приоритет: high
  - Бюджет: 1h
  - Артефакт: `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.023-model-fallback-cascade (Каскадный fallback моделей Haiku→Sonnet для агентного слоя).md`

- [done] 2026-04-05: [ENGINEERING] Strategist — собрать единый reliability dossier и roadmap hardening
  - Контекст: история сбоев `strategist` уже размазана между inbox, failure-modes, SESSION-CONTEXT и точечными WP. Это самый проблемный local-primary агент экосистемы: у него уже были path drift, зависание `day-close`, auth failures, runtime drift и truthful route mismatch.
  - Что сделать:
    1. Собрать единый dossier по классам сбоев и уже выполненным фиксам
    2. Отделить “уже починено” от “осталось системным риском”
    3. Зафиксировать truthful verdict по зрелости `strategist`
    4. Подготовить следующий WP на hardening или remote-capable runner
  - Приоритет: high
  - Бюджет: 45 мин
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.019-strategist-reliability-history (История надёжности и сбоев Strategist).md`
  - Результат: done — единый reliability dossier собран, truthful verdict по зрелости `Strategist` зафиксирован, следующий operational слой выделен в `ENG.WP.020`

- [pending] 2026-04-05: [ENGINEERING] Strategist — hardening auth/day-close/week-review runtime
  - Контекст: после ENG.WP.019 картина уже собрана, но operational issues не сняты. Сейчас нужны не новые наблюдения, а hardening-цикл: auth-failure observability, предсказуемый `day-close`, recovery для `week-review`, снижение shell/runtime хрупкости.
  - Что сделать:
    1. Собрать один actionable checklist по всем pending хвостам `strategist`
    2. Усилить auth-failure observability
    3. Довести `day-close` до предсказуемого truthful результата
    4. Разобрать `week-review`: починка или честный downgrade
  - Приоритет: critical
  - Бюджет: 1.5-2h
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.020-strategist-hardening (Укрепление надёжности Strategist).md`

- [pending] 2026-04-06: [ENGINEERING] Strategist — спроектировать 24/7 runtime contract
  - Контекст: подтверждено, что текущий `Strategist` живёт на ноутбуке: `launchd`, локальный `claude` CLI, локальные logs/locks/state. Значит при выключенном ноутбуке он не работает. Нужен честный ответ, как именно `Strategist` должен жить в модели `24/7`: оставаться local-only, стать remote-capable или разделиться по сценариям.
  - Что сделать:
    1. Разложить сценарии `Strategist` на `local-only / cloud-safe / requires redesign`
    2. Зафиксировать `runtime mode source-of-truth`
    3. Определить `no-double-run` и unified result semantics
    4. Выбрать первый сценарий для реального 24/7 выноса
  - Приоритет: critical
  - Бюджет: 1.5h
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.021-strategist-24x7-runtime-contract (Контракт 24/7 исполнения Strategist).md`

- [pending] 2026-04-05: [АГЕНТ] Report Distribution Agent для pipeline презентаций
  - Контекст: в agency-agents найдены два профильных агента для pipeline «документ из репо → презентация → Telegram»
  - Что сделать:
    1. Прочитать `agency-agents/specialized/specialized-document-generator.md`
    2. Прочитать `agency-agents/specialized/report-distribution-agent.md`
    3. Адаптировать карточки под нашу систему (по шаблону AGENT-TEMPLATE.md v2.0)
    4. Сохранить в `DS-agent-workspace/agency/agents/`
    5. Описать конкретный сценарий: «сроки годности» → Playwright + Нана Банана → Telegram
  - Приоритет: medium
  - Бюджет: 1h
  - Связано с: INBOX задача «Автогенерация презентаций через Playwright»

- [pending] 2026-04-05: [ИДЕЯ/ИНСТРУМЕНТ] Автоматическая генерация презентаций из базы знаний через агента + Нана Банана → Telegram
  - Контекст: пользователь говорит агенту «подготовь презентацию по срокам годности» → агент находит документ в репо → генерирует красивую презентацию через Нана Банана → отправляет в Telegram
  - Техническое решение: браузерная автоматизация (Playwright) — API нет, работает только через веб-интерфейс. Доступ через Google-аккаунт пользователя (инструмент уже куплен, подключён к Нана Банана).
  - Pipeline:
    1. Агент читает документ из репо
    2. Формирует структуру (заголовки, тезисы, данные)
    3. Playwright открывает браузер → логин через Google → вставляет контент в инструмент
    4. Нана Банана генерирует слайды с картинками
    5. Playwright скачивает PDF/экспортирует → отправляет в Telegram
  - Что нужно проработать:
    1. IntegrationGate — определить контур
    2. Уточнить название инструмента (Google-аккаунт пользователя)
    3. Найти в агентстве DS: Playwright Engineer / Browser Automation
    4. Спроектировать и протестировать на одном документе
  - Приоритет: medium
  - Бюджет: 4-5h (Playwright + интеграция)
  - Артефакт: скрипт presentation-generator.py + тест на документе «Сроки годности»

- [pending] 2026-04-05: [AUDIT] Аудит экосистемы глазами внешнего агента
  - Контекст: нужен взгляд «снаружи» — как будто новый агент заходит в систему и оценивает: что за экосистема, где дыры, как оптимизировать под задачу развития базы знаний сети кофеен «Вкусный кофе»
  - Что проанализировать:
    1. Все репозитории — типы, назначение, актуальность
    2. Все Pack — полнота, слабые места, дублирование
    3. Агенты — какие запущены, какие нет, где простаивают
    4. Автоматизации — что работает, что сломано, что лишнее
    5. Вывод: список приоритетных рефакторингов с обоснованием
  - Приоритет: high
  - Бюджет: 3h (отдельный агент-аналитик)
  - Артефакт: ENG.WP.012-ecosystem-refactoring-audit (Аудит рефакторинга экосистемы).md

- [pending] 2026-04-05: [ИДЕЯ/СТРАТЕГИЯ] Рабочая среда для управления небольшими сетями кофеен — потенциальный продукт
  - Контекст: в процессе разработки базы знаний VK-offee формируется универсальная система управления кофейней. Идея: оформить это как тиражируемый продукт для небольших сетей.
  - Состав системы (что должно быть):
    1. База знаний (Pack): меню, рецепты, стандарты, регламенты сотрудников
    2. Маркетинг: контент, Яндекс Карты, отзывы, акции
    3. Менеджмент: смены, задачи, контроль выполнения
    4. Учёт продукции: остатки, накладные, списания, вакуум
    5. HR: договоры, обучение, оценка знаний
    6. Аналитика: Saby + RAG-бот + дашборд
    7. Telegram-бот: заметки, запросы, статус системы
  - Следующий шаг: рефакторинг VK-offee под этот стандарт + анализ чего не хватает
  - Приоритет: medium (стратегическая идея, не срочно)
  - Бюджет: отдельная стратегическая сессия (3-4h)
  - Артефакт: DS-strategy/docs/IDEA.001-coffee-network-management-platform (Идея — Платформа управления сетью кофеен).md

- [pending] 2026-04-05: [RECOVERY] Вернуть утекшие задачи из сессий стратегирования в INBOX
  - Контекст: задачи из сессий стратегирования не попадают в INBOX автоматически — «утекают». Нужно однократно пройти по archive/ сессий и собрать всё нерешённое в INBOX-TASKS.
  - Что сделать:
    1. Найти все файлы сессий стратегирования в DS-strategy/archive/ и docs/
    2. Извлечь задачи со статусом pending/не выполнено
    3. Добавить в INBOX-TASKS.md (без дублирования существующих)
    4. После — настроить автоматический перенос через Extractor (РП 47)
  - Приоритет: high
  - Бюджет: 1h (агентом)
  - Артефакт: обновлённый INBOX-TASKS.md + фиксация gap в РП 47

- [pending] 2026-04-05: [ENG] FMT-exocortex-template — CI validate-template: убрать личные пути из шаблона, починить validate-template.yml
  - Контекст: после миграции на AlexPoAi сработал GitHub Actions → шаблон содержал /Users/alexander/ в 86 местах + /opt/homebrew hardcoded
  - Что сделано (2026-04-05): заменены личные пути на {{WORKSPACE_DIR}}/{{HOME_DIR}} плейсхолдеры в 25 файлах, добавлены exclusions в CI, CI зелёный
  - Остаток: проверить через update.sh что placeholders корректно подставляются при установке

- [pending] 2026-04-04: [SECURITY] VK-offee — провести проверку уязвимых мест хранения секретов и каналов авторизации
  - Контекст: в VK-offee смешаны несколько каналов хранения секретов и доступа: история git/GitHub, локальные `.env`, Google OAuth-файлы, системные credential helpers, документация с остатками токенов. Нужна инвентаризация без поломки экосистемы.
  - Что проверить:
    1. Почему у репозитория `alexpoaiagent-sudo/VK-offee` не переключается visibility в `private`
    2. Историю git на старые `.env`, Telegram token, Anthropic/OpenAI keys, GitHub PAT
    3. `.git/config`, `remote.origin.url`, credential helpers, `gh`, VS Code / Claude Code auth
    4. `telegram-bot/.env` и `$HOME/.config/aist/env` как runtime-источники секретов
    5. `.github/scripts/credentials.json`, `token.pickle`, `token_upload.pickle` и Google sync scripts
    6. `saby-integration` на реальные runtime-секреты и места их хранения
    7. Логи и документацию на следы секретов и частичных утечек
  - Приоритет: high
  - Бюджет: 2h
  - Артефакт:
    - `VK-offee/content/0.Management/0.9. Входящие/security-review-priority-checklist-2026-04-04.md`
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.007-post-migration-security-inspection (Постмиграционная инспекция безопасности экосистемы после переезда на новый GitHub-аккаунт).md`
    - при подтверждении рисков: отдельный runbook ротации секретов без остановки автоматизаций

- [pending] 2026-04-05: [ENGINEERING] Экосистема — держать актуальной карту автоматизаций и источников окружения
  - Контекст: после миграции и параллельной работы агентов нужен единый инженерный документ, из которого видно, что автоматизировано, где живут точки запуска, откуда берётся env и какие контуры нельзя ломать.
  - Что поддерживать в актуальном состоянии:
    1. GitHub Actions по ключевым репозиториям
    2. launchd / shell automation и scheduler-контуры
    3. соответствие `automation -> env/source-of-truth`
    4. critical dependency paths и smoke-test paths
  - Приоритет: high
  - Бюджет: living document
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.008-automation-map (Карта автоматизаций экосистемы и источников окружения).md`

- [pending] 2026-04-05: [ENGINEERING] OpenAI-first always-on migration агентного слоя
  - Контекст: подтверждено, что ключевые локальные агенты перестают работать при выключенном ноутбуке. Нужен roadmap, который снижает desktop-bound зависимость без ломки strategist/extractor/scheduler.
  - Что уже выяснено:
    1. `VK-offee-rag` и `VK-offee/telegram-bot` — first migration targets
    2. `strategist.sh`, `extractor.sh`, `scheduler.sh` — desktop-bound, требуют отдельного runtime-refactor
    3. массовый перевод “всех агентов на OpenAI” простой заменой ключа — неверная стратегия
  - Следующий шаг:
    1. открыть implementation WP на `always-on RAG + bot`
    2. потом отдельно проектировать remote runtime contract для strategist/extractor/scheduler
  - Приоритет: high
  - Бюджет: 2 этапа
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.014-openai-first-always-on-migration (OpenAI-first always-on миграция агентного слоя).md`
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.016-always-on-rag-and-bot (Always-on RAG и Telegram bot на VPS/cloud).md`

- [pending] 2026-04-05: [ENGINEERING] Local-first / cloud-fallback архитектура агентного слоя
  - Контекст: пользовательский контракт уточнён — пока ноутбук включён, локальные агенты работают как primary; когда local runtime unavailable, always-on облачный слой берёт на себя жизненно важные сервисы. Нужен единый контракт, чтобы не было двойных запусков и разъехавшихся маршрутов.
  - Что уже зафиксировано:
    1. `VK-offee-rag` и `VK-offee/telegram-bot` — cloud-primary кандидаты
    2. `strategist.sh`, `extractor.sh`, `scheduler.sh` — local-primary до redesign
    3. требуется heartbeat/failover contract и правило `no-double-run`
  - Следующий шаг:
    1. открыть implementation WP на `always-on RAG + bot`
    2. определить source-of-truth для runtime mode / heartbeat
    3. описать smoke tests online/offline для ноутбука
  - Приоритет: critical
  - Бюджет: 2 этапа
  - Артефакт:
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.015-local-first-cloud-fallback-architecture (Local-first / cloud-fallback архитектура агентного слоя).md`
    - `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.016-always-on-rag-and-bot (Always-on RAG и Telegram bot на VPS/cloud).md`

- [pending] 2026-04-04: [ПАРК] Создать реестр документов по проекту Парк Голубинка
  - Контекст: все документы парка разбросаны по PACK-park-development, Google Drive, Telegram, Downloads. Нужен единый реестр.
  - Что сделать:
    1. Собрать все документы из PACK-park-development/04-work-products/
    2. Проверить Google Drive (папка Парк)
    3. Составить реестр: название, тип, статус, источник, дата, ссылка/путь
    4. Сохранить как `VK-offee/PACK-park-development/04-work-products/PARK.WP.027-document-registry (Реестр документов проекта Парк Голубинка).md`
  - Приоритет: high
  - Бюджет: 1h

- [pending] 2026-04-04: [РП] Оценка внедрения вакуумной упаковки на кухне
  - Контекст: вакуум увеличивает срок хранения рыбных позиций с 24ч до 72ч — решает проблему выходных (пятничное производство доживает до понедельника). Обсуждалось 04.04.
  - Что проработать:
    1. Оборудование — вакуумный упаковщик (модель, цена)
    2. Изменения в ТТК — «хранение в вакуумной упаковке»
    3. Требования к температурному контролю (строго 0…+4°C)
    4. Обновление маркировки (указывать «вакуум» на этикетке)
    5. Пересчёт производственного графика Пн/Ср/Пт с новыми сроками
  - Приоритет: high
  - Бюджет: 2h
  - Артефакт: KITCHEN.WP.013 (Оценка внедрения вакуумной упаковки)

- [pending] 2026-04-04: VK-offee — карточка с картой папки
  - Контекст: Жанна загружает отчёты Сабы в папку https://drive.google.com/drive/folders/1sGGcG1DBHIMMhZFvPGd_gGOesncQwhiq
  - Реестр документов: https://docs.google.com/spreadsheets/d/14PxApr1x8iHuD-ioCzYjpRoaEJw_7iYWKjPAkpaOvsM/edit?gid=0#gid=0
  - Что сделать:
    1. Использовать скрипт `VK-offee/saby-integration/google_drive_parser.py` + credentials из `.github/scripts/`
    2. Прочитать содержимое папки Google Drive (рекурсивно)
    3. Составить карточку: какие файлы лежат, по каким Pack можно использовать
    4. Сохранить как `VK-offee/knowledge-base/Разработано в базе данных/GDRIVE-MAP-001 (Карта Google Drive VK-offee).md`
  - Приоритет: medium
  - Бюджет: 30 мин

- [pending] 2026-04-04: [KE] Применить: IWE.METHOD.001 — Метод непрерывного обучения (замыкать контур регулярного слота)
  - Контекст: Extraction report 2026-04-04 #2, кандидат #1
  - Репо: PACK-iwe-culture → 02-methods/IWE.METHOD.001-continuous-learning-loop (Метод непрерывного обучения — замыкать контур).md
  - Действие: create file (готовый текст в extraction report)
  - Приоритет: medium
  - Бюджет: 10 мин

- [pending] 2026-04-04: [KE] Применить: IWE.DISTINCTION.001 — Устарел vs Ошибка агента в health-check уведомлениях
  - Контекст: Extraction report 2026-04-04 #2, кандидат #2
  - Репо: PACK-iwe-culture → 03-distinctions/IWE.DISTINCTION.001-stale-vs-failed-agent (Устарел vs Ошибка агента).md
  - Действие: create file (готовый текст в extraction report)
  - Приоритет: medium
  - Бюджет: 10 мин

- [pending] 2026-04-04: [KE] Применить: IWE.METHOD.002 — Экстрактор читает только captures.md
  - Контекст: Extraction report 2026-04-04 #2, кандидат #3
  - Репо: PACK-iwe-culture → 02-methods/IWE.METHOD.002-extractor-reads-captures-only (Экстрактор читает только captures.md).md
  - Действие: create file (готовый текст в extraction report)
  - Приоритет: medium
  - Бюджет: 10 мин

- [done] 2026-04-04: [KE] Routing gap — добавить PACK-iwe-culture в routing.md
  - Контекст: Extraction report 2026-04-04 #2 — все 3 кандидата направлены в PACK-iwe-culture, но он отсутствует в таблице routing.md
  - Репо: FMT-exocortex-template → roles/extractor/config/routing.md
  - Действие: добавить строку: PACK-iwe-culture | IWE | ~/Github/PACK-iwe-culture | Культура работы IWE: протоколы, навыки, различения, методы
  - Итог: done — PACK-iwe-culture добавлен в routing.md как официальный Pack extractor routing, gap закрыт
  - Приоритет: high
  - Бюджет: 5 мин

- [pending] 2026-04-04: [KE] Применить: PARK.ENTITY.002 — Блокер: канализационная труба (стратегия отступа)
  - Контекст: Extraction report 2026-04-04, кандидат #1
  - Репо: VK-offee → PACK-park-development/02-domain-entities/PARK.ENTITY.002-sewage-pipe-blocker (Блокер-канализационная труба).md
  - Действие: create file
  - Приоритет: medium
  - Бюджет: 15 мин
  - Готовый текст: см. DS-strategy/inbox/extraction-reports/2026-04-04-inbox-check.md → Кандидат #1

- [pending] 2026-04-04: [KE] Применить: MGMT.DISTINCTION.001 — Кухня ≠ Бариста по конкурентной ценности
  - Контекст: Extraction report 2026-04-04, кандидат #2
  - Репо: VK-offee → PACK-management/01-domain-contract/MGMT.DISTINCTION.001-kitchen-vs-barista-competitive-advantage (Кухня vs Бариста — конкурентное преимущество).md
  - Действие: create file
  - Приоритет: medium
  - Бюджет: 15 мин
  - Готовый текст: см. DS-strategy/inbox/extraction-reports/2026-04-04-inbox-check.md → Кандидат #2

- [pending] 2026-04-06: [НАПОМИНАНИЕ] ПАРК — дедлайн ответа от Елены по графику первой очереди
  - Контекст: 02.04 Елена обещала прислать скорректированный график сроков разработки разделов (приложение к доп.договору). На 04.04 — не прислала.
  - Что сделать: если график не пришёл → написать Елене со ссылкой на обещание от 02.04 18:10
  - Карточка: PARK.COMM.013

- [pending] 2026-04-04: [ИДЕЯ] Создать Pack «Личный помощник» — интеграция напоминаний с Google Календарём
  - Контекст: сейчас напоминания теряются (session-only cron). Нужна система: агент принимает напоминание → пишет в INBOX-TASKS → отправляет в Google Calendar
  - Приоритет: medium (пока не реализовано — все напоминания писать в INBOX-TASKS)
  - Требует: IntegrationGate перед реализацией

- [pending] 2026-04-04: [ИНЖ] Добавить детектор OAuth 401 с macOS-уведомлением в run_claude (по образцу Церена W12)
  - Контекст: Церен описал: агенты падали с 401 10 дней, никто не знал. Решение — 3 строки bash в run_claude: при exit code 401 → CRITICAL в лог + osascript уведомление macOS. У нас та же проблема: extractor inbox-check сегодня упал с "CRITICAL: Auth failed" 3 раза без алерта.
  - Приоритет: high
  - Что сделать:
    1. Найти `run_claude` функцию в `~/Github/FMT-exocortex-template/roles/synchronizer/scripts/scheduler.sh` (или где она определена)
    2. Добавить: если exit code = 1 и в логе есть "401" или "Auth failed" → `osascript -e 'display notification "Auth failed — claude /login" with title "Экзокортекс: КРИТИЧНО"'`
    3. Дополнительно: записать CRITICAL в лог с явным маркером чтобы health-check его находил
    4. Протестировать: симулировать auth failure, убедиться что уведомление приходит
  - Источник: пост Церена DS-Knowledge-Index-Tseren/docs/2026/2026-03-19-week-review-w12.md
  - Репо: FMT-exocortex-template (roles/synchronizer/scripts/)

- [pending] 2026-04-04: [ИНЖ] Починить daily-telegram — TELEGRAM_CHAT_ID не найден в конфиге агента
  - Контекст: За 03.04 ошибка повторилась 5 раз (09:09, 12:00, 15:00, 18:00, 21:15). Telegram-отчёты не доходят. Бот VK-offee на VPS работает нормально, проблема в конфиге планировщика экзокортекса.
  - Приоритет: high
  - Что проверить:
    1. `cat ~/.config/aist/env` — есть ли TELEGRAM_CHAT_ID
    2. `grep -r "TELEGRAM_CHAT_ID" ~/Github/FMT-exocortex-template/roles/synchronizer/` — откуда берётся chat_id в daily-telegram скрипте
    3. Прописать chat_id в нужное место конфига
    4. Протестировать: запустить daily-telegram вручную, убедиться что отчёт приходит в TG
  - Репо: FMT-exocortex-template (roles/synchronizer/)

- [pending] 2026-04-04: [ИНЖ] Починить extractor inbox-check — падает с exit code 1 (claude exited code 1)
  - Контекст: За 03.04 упал 3 раза (10:21, 15:06, 18:03). Причина: auth failed (10:21 — "CRITICAL: Auth failed via helper/env/custom API"), потом просто code 1 без auth ошибки. Inbox не проверяется автоматически.
  - Приоритет: high
  - Что проверить:
    1. `tail -100 ~/logs/synchronizer/scheduler-2026-04-03.log` — полный контекст ошибок
    2. Проверить что `claude` запускается без ошибок сейчас: `claude --version`
    3. Проверить auth: `claude auth status` или запустить `extractor.sh inbox-check` вручную
    4. Если auth — переавторизоваться: `claude /login`
    5. Если модель — проверить какая модель прописана в extractor.sh (после фикса 22.03 убрали жёсткую модель)
  - Репо: FMT-exocortex-template (roles/extractor/)

- [pending] 2026-04-04: [ИНЖ] Обновить SESSION-CONTEXT.md — устарел (данные от 22.03, последнее обновление 03.04 22:19 но содержимое старое)
  - Контекст: SESSION-CONTEXT содержит «что сделано сегодня» за 22.03, не за 03.04. Нужно записать итоги 03.04.
  - Приоритет: medium
  - Что записать в итоги 03.04:
    - WP-48: Telegram-бот починен (systemd на VPS, убран с Мака, исправлен git order)
    - WP-49: правило --resume добавлено в CLAUDE.md (баг кэша v2.1.69+)
    - PARK: 8 артефактов (DOC.015-020, WP.025-026, COMM.010-011) — анализ документов ЛУКС
    - Технический долг после сбоя 01.04 закрыт
  - Репо: DS-strategy

- [pending] 2026-04-03: Изучить оптимизацию токенов у Церена (upstream FMT-exocortex-template)
  - Контекст: За 03.04 потрачено 67.9M токенов (30M cache read, 37.4M input). Opus 4.6 стоит x5 от Sonnet. Нужно изучить как Церен решает проблему расхода токенов в шаблоне экзокортекса.
  - Приоритет: high
  - Что проверить:
    1. `git fetch upstream && git show upstream/main:CLAUDE.md` — есть ли правила по токенам
    2. `git show upstream/main:memory/` — размер файлов, политика сжатия
    3. Какие модели рекомендует Церен для каких задач
    4. Есть ли у него механизм автопереключения моделей
  - Репо: FMT-exocortex-template (upstream Церена)

- [pending] 2026-04-03: Оптимизация кэша Claude Code — два бага увеличивают расходы в 10-20x
  - Контекст: Статья с Reddit (reverse engineering Claude Code binary). Два независимых бага ломают prompt cache.
  - Приоритет: high
  - Баг 1: Замена метки cch=00000 в standalone binary. При обсуждении внутренних деталей CC в разговоре — метка попадает в messages[] вместо system[] → кэш ломается каждый запрос (~$0.04/запрос).
    - Workaround: запускать через `npx @anthropic-ai/claude-code` вместо standalone binary.
  - Баг 2: --resume ВСЕГДА ломает кэш (с v2.1.69). deferred_tools_delta вставляется в разные позиции messages[] при new vs resume → полный cache miss (~$0.15 за resume).
    - Workaround: нет внешнего. Downgrade до v2.1.68 или v2.1.30.
  - Влияние: для 500k контекста — до $0.20+ за запрос. У нас были аналогичные проблемы (7.4M cache creation, 15.6M cache read за день — задача от 14.03).
  - Что сделать:
    1. Проверить какой binary у нас стоит: standalone или npm
    2. Проверить версию Claude Code (`claude --version`)
    3. Если standalone → переключиться на npx
    4. Избегать --resume или минимизировать
  - Источник: Reddit, reverse engineering Claude Code, GitHub issues #40524 и #34629
  - Репо: FMT-exocortex-template (настройка среды)

# Входящие задачи

> Задачи, поступившие вне очереди во время выполнения РП. Обрабатываются после завершения текущего РП.

- [done] 2026-03-28: Починить notify.sh у strategist после дрейфа путей IWE→Github
  - Контекст: `strategist.sh day-plan` завершается, но post-step уведомления падает на старом пути `/Users/alexander/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh`. Из-за этого «мозг экзокортекса» остаётся в жёлтом статусе.
  - Приоритет: high
  - Результат: ✅ Исправлено 2026-03-30. Commit 1fddbc8. Файлы: strategist.sh:64, protocol-close.md (2 места). ENG.WP.004 создан. Мозг экзокортекса → 🟢 зелёный.
  - Артефакт: `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.004-notify-path-drift-2026-03-29.md`
  - Репо: FMT-exocortex-template + DS-strategy

- [pending] 2026-03-28: Красивый Telegram-отчёт закрытия дня вместо raw-лога
  - Контекст: Бот присылает нечитаемый лог (крякозябры + экранированные \n). Нужен форматированный русский отчёт.
  - Приоритет: high
  - Что нужно сделать:
    1. Переделать daily-report — форматировать вывод для Telegram (не raw лог)
    2. Формат: 🔒 Закрытие дня | ✅ Что сделано | 🟢/🟡/🔴 Статус агентов | 🔜 На завтра топ-3
    3. Убрать технические детали (exit codes, пути) — только человекочитаемое
  - Репо: FMT-exocortex-template (roles/synchronizer) + DS-strategy

- [pending] 2026-03-28: PACK-warehouse — накладные, остатки, поставщики как карточки для бота
  - Контекст: Нужен сценарий «найди накладную по поставщику за дату». Данные из Saby уже частично есть.
  - Приоритет: high
  - Источник данных: [Google Sheets — остатки от Жанны (менеджер)](https://docs.google.com/spreadsheets/d/1OHG_qtW3RUty62R1lIx0thaozLZDNJn50Woi551y9II/edit?gid=872814975#gid=872814975) — все остатки по кофейне (добавлено 2026-04-03)
  - Что нужно сделать:
    1. Создать PACK-warehouse в VK-offee
    2. Карточки формата: накладная, поставщик, остаток, дата
    3. Конвертировать выгрузки из Saby в MD-карточки
    4. Импортировать данные из Google Sheets (ссылка выше)
    5. Переиндексировать бота после наполнения
  - Репо: VK-offee (новый PACK-warehouse)

- [pending] 2026-03-28: Сделать репозитории VK-offee-rag приватными (или создать отдельный закрытый репо для секретов)
  - Контекст: Пользователь хочет закрыть репо от публичного доступа. Сейчас VK-offee и VK-offee-rag публичные.
  - Приоритет: medium
  - Что нужно сделать:
    1. Решить: закрыть существующие репо или вынести .env/секреты в отдельный приватный репо
    2. GitHub: Settings → Danger Zone → Change visibility → Private
    3. Обновить deploy.sh — добавить авторизацию через PAT или SSH ключ для клонирования приватных репо
    4. Сохранить PAT в безопасном месте (1Password или системный keychain)
  - Репо: VK-offee, VK-offee-rag

- [done] 2026-03-28: OpenAI embeddings блокируются с российского VPS — починить RAG индексацию
  - Контекст: Сервер 72.56.4.61 (Timeweb Moscow) получает 403 от OpenAI API. ChromaDB пустая — RAG не работает.
  - Результат: ✅ Решено 2026-03-30 (WP-43). Прокси OpenAI настроен, venv создан, ChromaDB переиндексирована (436 docs). Бот работает.

- [pending] 2026-03-30: OOM при переиндексации ChromaDB на VPS — indexer.py убивается (Killed)

- [done] 2026-04-01: Создать PACK-iwe-culture с манифестом
  - Результат: ✅ Создан PACK-iwe-culture, манифест сохранён в 01-concepts/IWE.CONCEPT.001-work-culture-manifesto.md
  - Репо: PACK-iwe-culture (новый)

- [pending] 2026-04-01: Аудит текущей реализации IWE под манифест
  - Контекст: Проверить, какие из 14 элементов уже реализованы, какие отсутствуют
  - Приоритет: high
  - Что проверить:
    1. Протоколы (7): ОРЗ, Каскад, Учёт времени, АрхГейт, Стоп-краны, Стоп-лист, Эволюция
    2. Навыки (5): Capture, Мультитаскинг, Мультиагентность, Экзоскелет, Самоисправление
    3. Форматы (2): Структура знаний, ВДВ
  - Результат: Таблица gap-анализа (что есть, что нет, что нужно доработать)
  - Бюджет: 2h
  - Репо: FMT-exocortex-template, DS-strategy

- [pending] 2026-04-01: Реализовать недостающие протоколы
  - Контекст: По результатам аудита реализовать отсутствующие протоколы
  - Приоритет: high
  - Бюджет: 8-10h (разбить на РП по каждому протоколу)
  - Репо: FMT-exocortex-template

- [pending] 2026-04-01: Реализовать недостающие навыки
  - Контекст: По результатам аудита реализовать отсутствующие навыки
  - Приоритет: medium
  - Бюджет: 6-8h
  - Репо: FMT-exocortex-template, DS-strategy

- [pending] 2026-04-01: Обновить CLAUDE.md под манифест
  - Контекст: Привести корневой CLAUDE.md в соответствие с 14 элементами
  - Приоритет: high
  - Бюджет: 2h
  - Репо: Корневой ~/Github/CLAUDE.md

- [pending] 2026-04-01: Создать чеклисты верификации для каждого элемента
  - Контекст: Чеклисты для проверки соответствия каждому из 14 элементов
  - Приоритет: medium
  - Бюджет: 3h
  - Репо: PACK-iwe-culture/04-work-products/
  - Контекст: VPS 2GB RAM не справляется с полным прогоном indexer.py при переиндексации. Процесс убивается ОС без ошибки.
  - Приоритет: medium
  - Варианты решения:
    1. Добавить swap на VPS: `fallocate -l 2G /swapfile && mkswap /swapfile && swapon /swapfile`
    2. Переиндексировать батчами — разбить find_pack_files() на части, коммитить по 50 документов
    3. Переиндексировать локально и синхронизировать data/chroma через rsync на VPS
  - Репо: VK-offee-rag (src/indexer.py)
  - Приоритет: high
  - Варианты решения:
    1. Настроить OpenAI через прокси (как ANTHROPIC_BASE_URL уже настроен через dev.aiprime.store)
    2. Заменить OpenAI embeddings на Anthropic (если поддерживает)
    3. Запустить переиндексацию локально, закоммитить data/chroma в репо (нет, слишком большой)
    4. Использовать альтернативные embeddings (sentence-transformers локально — без API)
  - Репо: VK-offee-rag (src/indexer.py)

- [pending] 2026-03-28: FPF-моделирование PACK-kitchen — FM-уровень (правила блокировки)
  - Контекст: Домен описан (объекты 003-006 + PACK-SCHEMA). Следующий уровень — failure modes по прослеживаемости партий.
  - Приоритет: medium
  - Что нужно сделать (порядок от FPF Консультанта):
    По Ингредиенту:
    - FM-004 — просрочен → используется
    - FM-005 — неправильно принят (недовес/органолептика)
    - FM-006 — испорчен при хранении
    По Заготовке:
    - FM-007 — неправильно промаркирована
    - FM-008 — превышен срок хранения
    - FM-009 — смешаны партии
    По Блюду:
    - FM-010 — неправильный состав
    - FM-011 — не та маркировка
    По Цеху:
    - FM-012 — пересечение потоков (сырьё + готовое)
    - FM-013 — нарушение санитарии
    Начать с FM-004 (просроченный ингредиент) — самый частый реальный сбой, влияет на всю цепочку
  - Артефакт: два файла в PACK-kitchen/05-failure-modes (Типовые ошибки)/
  - Репо: VK-offee

- [pending] 2026-03-28: Разработать собственную систему продвижения в Яндекс Картах (аналог Smart Discovery)
  - Контекст: Маркетинговое агентство предложило услугу за 6000₽/мес — ведение Яндекс карточки, продвижение в топ, ответы на отзывы, Stories/Новости, Яндекс.Директ, SEO. Идея: сделать это самостоятельно с помощью ИИ-агентов.
  - Приоритет: medium
  - Что нужно сделать:
    1. Изучить Яндекс Бизнес API — что можно автоматизировать (отзывы, Stories, Новости, фото, акции)
    2. Спроектировать агента для мониторинга и ответов на отзывы
    3. Спроектировать пайплайн для генерации контента (Stories/Новости) из базы знаний VK-offee
    4. Оценить что нельзя автоматизировать (реклама Директ, ручные стратегии)
    5. Создать PACK-marketing или раздел в PACK-management
  - Источник: КП от агентства Анастасии (Луговая), 27.03.2026
  - Референс: https://wifi-direct.ru/discovery-prezent (Smart Discovery)
  - Агент: Code Engineer + Supreme HR (подбор агента под маркетинг)
  - Репо: VK-offee (PACK-marketing или PACK-management)
  - Бюджет: архитектурная задача, 3-4h

- [pending] 2026-03-27: Найти и отсканировать ответ ГУП РК «Вода Крыма» на заявление о техприсоединении
  - Контекст: Заявление подано 07.07.2025 на технологическое присоединение к водоснабжению/водоотведению (участок 90:01:070101:767, Голубинка). Ответный документ (ТУ) не найден в базе — статус неизвестен.
  - Приоритет: high
  - Что нужно сделать:
    1. Найти бумажный ответ от «Вода Крыма» (техусловия или отказ)
    2. Отсканировать и скинуть в чат
    3. Агент создаст карточку PARK.DOC.015-water-connection-tu + обновит PARK.CONCEPT.006
  - Что важно в документе: номер и дата ТУ, **срок действия** (критично — прошёл год с заявления), стоимость и условия подключения
  - Артефакт: PARK.DOC.015-water-connection-tu (ТУ Вода Крыма — водоснабжение).md
  - Репо: VK-offee / PACK-park-development

## Формат

```
- [статус] YYYY-MM-DD: Описание задачи
  - Контекст: откуда задача
  - Приоритет: low/medium/high
```

---

- [done] 2026-03-26: FPF-моделирование PACK-management — объектная модель домена управления сменой
  - Контекст: Продолжение FPF-инспекции VK-offee. PACK-bar и PACK-service закрыты. Следующий домен: управление сменой (смена, отчёт).
  - Приоритет: high
  - Результат: ✅ DOMAIN-MODEL-v1 создан в PACK-management. Объекты: смена, период учёта, инвентаризация (документ), возмещение, метрики потерь. Записан в DOMAIN-CONTRACTS-ALL.

- [pending] 2026-03-27: FPF Консультант v2 — кэш threads и интерактивный режим
  - Контекст: FPF Консультант создан и работает. В процессе выявлены два улучшения:
    1. Кэш threads — чтобы консультант помнил контекст диалога между запросами (сейчас каждый вызов = новый thread)
    2. Интерактивный режим — запустить один раз, задавать вопросы без перезапуска скрипта
  - Приоритет: medium
  - Артефакт: обновлённый fpf-consult.sh + опционально интерактивный режим
  - Репо: DS-strategy/tools/
  - Бюджет: ~1h

- [pending] 2026-03-27: Добавить отправку Telegram-отчёта при закрытии дня
  - Контекст: При команде «закрой день» — запустить ритуал закрытия и отправить красивый русский отчёт в ТГ о проделанной работе и состоянии системы
  - Приоритет: high
  - Что нужно сделать:
    1. Добавить триггер «закрой день» в CLAUDE.md (по аналогии с «открывай день»)
    2. Ритуал закрытия: собрать из SESSION-CONTEXT «что сделано сегодня» + статус агентов
    3. Сформировать красивое сообщение на русском: эмодзи, разделы, итоги дня
    4. Отправить в Telegram через существующий бот (токен уже есть в .env)
    5. Формат отчёта:
       - 🔒 Закрытие дня ДД.ММ
       - ✅ Что сделано (список из SESSION-CONTEXT)
       - 🟢/🟡/🔴 Состояние системы (агенты, scheduler)
       - 🔜 На завтра (топ-3 из INBOX)
  - Артефакт: обновлённый CLAUDE.md (триггер) + скрипт/функция day-close-report.sh + шаблон TG-сообщения
  - Репо: FMT-exocortex-template + DS-strategy
  - Бюджет: 1-2h

 (списание, финансовый контур, PACK-hr)
  - Контекст: FPF-инспекция VK-offee продолжается. Завершены все PACK кроме hr. Добавлены новые объекты в сессии 26.03: списание, ингредиент (обновлён). Баланс остатков замкнут: поставки − продажи − списания = остатки.
  - Приоритет: high
  - Что сделано (26.03):
    - DOMAIN-CONTRACTS-ALL v1.1: 11 объектов по FPF-шаблону (заказ, поставка, расхождение, списание, заказ кухни, порция еды, напиток, ингредиент, стол, посадка, период учёта, возмещение)
    - Новый объект: списание (PACK-cafe-operations) — факт удаления, фиксирует сотрудника
    - Обновлён: ингредиент (PACK-bar) — добавлен срок годности, различение с порцией еды
    - Два потока на баре: еда (целые порции, шт) vs ингредиенты (молоко/сиропы/фрукты, мл/г)
  - Что нужно сделать:
    1. Учёт ингредиентов бара — детализировать движение мл/г, объект «остатки бара»
    2. Финансовый контур — себестоимость напитков и еды
    3. PACK-hr — отдельный РП, объекты: сотрудник, договор, обучение, роль, должность, график
  - Артефакт: DOMAIN-CONTRACTS-ALL (Все карточки объектов системы).md + DOMAIN-MODEL-v1 в PACK-hr
  - Репо: VK-offee
  - Бюджет: 2-3h
  - Источник: FPF-сессия 26.03.2026
  - Что нужно сделать:
    1. Определить объекты PACK-management (смена, отчёт и др.)
    2. Определить связи с cafe-operations, hr, bar, service
    3. Сохранить DOMAIN-MODEL-v1 в PACK-management/01-domain-contract/
  - Артефакт: DOMAIN-MODEL-v1 (Объектная модель PACK-management v1).md
  - Репо: VK-offee
  - Бюджет: 1-2h
  - Источник: FPF-сессия 26.03.2026

- [pending] 2026-03-26: FPF-моделирование PACK-hr — объектная модель домена персонала
  - Контекст: Продолжение FPF-инспекции VK-offee. Все PACK кроме hr закрыты. Тип «сотрудник» живёт здесь, ссылки на него во всех других PACK.
  - Приоритет: high
  - Что нужно сделать:
    1. Определить объекты PACK-hr (сотрудник, должность, договор, график и др.)
    2. Определить связи с cafe-operations, management, bar, service, kitchen
    3. Сохранить DOMAIN-MODEL-v1 в PACK-hr/01-domain-contract/
    4. Написать полные domain-contract для всех PACK по шаблону карточки
  - Артефакт: DOMAIN-MODEL-v1 (Объектная модель PACK-hr v1).md + domain-contract карточки
  - Репо: VK-offee
  - Бюджет: 2-3h
  - Источник: FPF-сессия 26.03.2026

- [done] 2026-03-26: Переработка архитектуры базы знаний VK-offee — domain-contract для всех PACK
  - Контекст: FPF-инспекция выявила что PACK-cafe-operations = контейнер домена «кофейня», остальные PACK (bar, kitchen, service, management, hr) = поддомены. Точки Самокиша/Тургенева/Луговая = объекты-экземпляры типа «кофейная точка» внутри PACK-cafe-operations. PACK-kitchen = отдельный PACK, связан через объекты еды.
  - Приоритет: high
  - Что нужно сделать:
    1. Написать domain-contract для PACK-cafe-operations (тип, экземпляры, атрибуты, связи)
    2. Написать domain-contract для каждого поддомена (bar, kitchen, service, management, hr)
    3. Описать объекты-экземпляры точек (Самокиша, Тургенева, Луговая)
    4. Обновить 00-pack-manifest.md во всех PACK
    5. Убрать дублирование между PACK-cafe-operations и поддоменами
  - Артефакт: domain-contract файлы во всех PACK + обновлённые манифесты
  - Репо: VK-offee
  - Бюджет: 3-4h
  - Источник: сессия FPF-инспекции 26.03.2026 + FPF-консультант

- [pending] 2026-03-26: Агентство ИИ-агентов — реестр + механизм найма при согласовании
  - Контекст: При ритуале согласования выбираем не просто модель, а конкретного ИИ-агента из реестра. Агент = роль + специализация + инструменты + контракт. Вся экосистема экзокортекса завязана на этот реестр.
  - Приоритет: high
  - Что нужно сделать:
    - Определить понятие «ИИ-агент» в нашей системе (роль vs агент vs модель)
    - Создать реестр агентов (кто есть, специализация, когда нанимать)
    - Встроить выбор агента в Ритуал согласования (шаг «Модель» → «Агент»)
    - Связать с DS-agent-workspace и экзокортексом
  - Артефакт: реестр агентов + обновлённый протокол Ритуала
  - Бюджет: 3-4h (архитектурная задача, нужен IntegrationGate + ArchGate)

- [pending] 2026-03-26: Диагностировать strategist-week-review — почему падает с 23 мар
  - Контекст: evidence=failed с 2026-03-23 23:03:12, нужно найти причину в логах
  - Приоритет: medium

- [pending] 2026-03-25: Архитектура цифровой платформы VK-offee: Claude + Nana Banana + TG-бот + MCP + БД
  - Контекст: Спроектировать полную архитектуру цифровой системы управления кофейней — от базы знаний до автоматизации через ботов и агентов
  - Приоритет: critical
  - Что нужно сделать:
    - **Архитектура связки Claude + Nana Banana:** определить как Claude работает с Nana Banana для задач сайта, какие роли, какие процессы, какие артефакты
    - **Изолированная среда для TG-бота:** спроектировать изоляцию (Docker/worktree/venv), определить как бот запускается через Claude Code, как обновляется
    - **MCP-сервер для непрерывной работы:** спроектировать MCP-сервер для фоновых задач (индексация, мониторинг, синхронизация), определить протоколы и endpoints
    - **БД и контур данных:** выбрать БД (PostgreSQL/SQLite/Supabase), спроектировать схему (меню, цены, продажи, сотрудники, задачи), определить источники данных (Saby API, Pack, RAG)
    - **Интеграция компонентов:** как все части связаны (VK-offee Pack → RAG → TG-бот → MCP → БД → Saby)
    - **Deployment:** где хостить (VPS/Railway/local), как обновлять, как мониторить
  - Артефакт: Архитектурный документ (ADR) + диаграммы + план реализации по РП
  - Репо: DS-strategy (архитектура) → VK-offee (реализация) → новые DS-instrument репо
  - Бюджет: 6-8h (большая архитектурная задача)

- [pending] 2026-03-25: Адаптировать DS-agent-workspace: структура workspace, роли extractor/scheduler/scout/strategist/verifier
  - Контекст: Форк github.com/alexpoaiagent-sudo/DS-agent-workspace содержит продвинутую структуру workspace для автономных агентов. Нужно адаптировать под нашу экосистему
  - Приоритет: high
  - Что нужно сделать:
    - Проанализировать структуру DS-agent-workspace (роли, артефакты, процессы)
    - Сопоставить с текущей структурой FMT-exocortex-template
    - Определить что взять: новые роли (scout, verifier), улучшенные процессы, workspace patterns
    - Спроектировать миграцию без breaking changes
    - Обновить документацию и PROCESSES.md
  - Артефакт: План адаптации + обновлённая структура workspace
  - Репо: FMT-exocortex-template
  - Бюджет: 3-4h

- [pending] 2026-03-25: Интегрировать agency-agents: реестр 75+ специализированных ролей и orchestration
  - Контекст: Форк github.com/alexpoaiagent-sudo/agency-agents содержит 75+ профессиональных ролей агентов (orchestrator, MCP builder, architect и др.). Нужно создать реестр ролей для нашей системы
  - Приоритет: medium
  - Что нужно сделать:
    - Извлечь все роли из agency-agents
    - Определить какие роли нужны для VK-offee и экосистемы
    - Создать реестр ролей в FMT-exocortex-template/roles/
    - Разработать механизм orchestration (как роли взаимодействуют)
    - Интегрировать с существующими ролями (extractor, strategist, author)
  - Артефакт: Реестр ролей + orchestration protocol
  - Репо: FMT-exocortex-template
  - Бюджет: 2-3h

- [pending] 2026-03-25: Подключить opendataloader-pdf: PDF ingestion для документов кофейни и парка
  - Контекст: Форк github.com/alexpoaiagent-sudo/opendataloader-pdf — инструмент для извлечения данных из PDF. Нужен для обработки документов парка (ГПЗУ, договоры, сканы)
  - Приоритет: high
  - Что нужно сделать:
    - Установить и настроить opendataloader-pdf
    - Интегрировать с extractor pipeline
    - Настроить автоматическую обработку PDF из PACK-park-development
    - Конвертировать PDF → MD карточки с метаданными
    - Обновить RAG-бот для индексации извлечённых данных
  - Артефакт: PDF ingestion pipeline + обработанные документы парка
  - Репо: VK-offee / FMT-exocortex-template
  - Бюджет: 2-3h

- [pending] 2026-03-25: Связка Claude + Nana Banana для сайта, Telegram-бот и MCP/БД в изолированной среде
  - Контекст: пользователь хочет собрать рабочую связку Claude + Nana Banana для работы сайта, поднять Telegram-бота, создать MCP-сервер для непрерывной работы и подключить БД; отдельно рассматривается запуск бота в изолированной с��еде через Claude Code
  - Приоритет: high
  - Что нужно сделать:
    - Определить архитектуру связки Claude + Nana Banana для задач сайта
    - Спроектировать и поднять Telegram-бота
    - Спроектировать MCP-сервер для фоновой/непрерывной работы
    - Выбрать и подключить БД
    - Определить изолированную среду для бота Claude Code
  - Артефакт: согласованная архитектура и рабочий контур для сайта/бота/сервера/БД
  - Репо: DS-strategy / целевой system repo по результату


- [done] 2026-03-22: 🔴 Критично — разобрать зависание Claude day-close / strategist day-close
  - Контекст: Ночной приёмочный тест показал реальный runtime-дефект закрытия дня. `strategist.sh day-close` стартует, в логе фиксируется `Manual: running day close` и `Starting scenario: day-close`, но сценарий не даёт финального результата. Ранее в тот же день уже был зафиксирован таймаут `day-close` на 300s. Дополнительно lock выглядит нетипично: `~/logs/strategist/locks/day-close.2026-03-22.lock` является директорией, а не обычным lock-файлом. День пришлось закрыть обходным безопасным маршрутом через `close-task.sh`.
  - Приоритет: critical
  - Что нужно сделать:
    - Проверить, почему `day-close` зависает после старта и не доходит до финального вывода
    - Проверить механику lock для `day-close`: почему `.lock` создаётся как директория и не ломает ли это runner
    - Сопоставить `day-close.md`, `strategist.sh` timeout/locking и реальный runtime в логах `~/logs/strategist/2026-03-22.log`
    - Определить, где именно сценарий зависает: на Claude runtime, git-обходе, backup, чтении WeekPlan/MEMORY или close-flow шаге
    - После диагностики решить: чинить сам `day-close`, упростить его контракт или оставить закрытие дня только через truthfully verified safe-route
    - Обязательно проверить исправление на реальном запуске без ложного success
  - Результат: 2026-04-07 зафиксировано архитектурное решение. `strategist.sh day-close` больше не используется как headless-route, потому что `protocol-close.md` интерактивен и раньше давал ложный `success`. Runner теперь truthfully возвращает `status=unsupported_path`, а canonical day-close остаётся только через интерактивный `protocol-close`.
  - Артефакт: честно работающий `day-close` или зафиксированное архитектурное решение, почему он больше не используется как основной путь закрытия дня
  - Репо: FMT-exocortex-template / DS-strategy / корневой `close-task.sh`

- [pending] 2026-03-21: Исправить автозапись SESSION-CONTEXT, протокол закрытия и вывод close-task.sh
  - Контекст: По итогам закрытия сессии выявлены не формальности, а реальные сбои контура закрытия. В `SESSION-CONTEXT.md` записи в блоке «Что сделано сегодня» местами склеиваются в одну строку, `close-task.sh` иногда печатает дублированный список репозиториев в строке «Запушено», а в `CLAUDE.md` есть ссылка на `memory/protocol-close.md`, при этом сам файл по этому пути сейчас отсутствует. Нужно не гадать, а провести глубокий разбор: был ли файл раньше, когда исчез, почему это произошло и как правильно восстановить рабочий контур закрытия.
  - Приоритет: critical
  - Что нужно сделать:
    - Исправить формат автозаписи в `SESSION-CONTEXT.md`, чтобы новые пункты добавлялись отдельными строками
    - Проверить переносы строк и timestamp в автозаписи
    - Убрать дублирование репозиториев в выводе `close-task.sh`
    - Провести глубокий анализ истории Git/GitHub по `memory/protocol-close.md`: существовал ли файл, когда был создан, изменён или удалён, в каком коммите и по какой причине
    - Проверить, нет ли переименования, переноса или замены протокола закрытия на другой файл или механику
    - Сопоставить реальный runtime закрытия (`close-task.sh`, `SESSION-CONTEXT`, backup memory) с тем, что написано в `CLAUDE.md`
    - После анализа принять решение: восстановить `protocol-close.md`, заменить ссылку в `CLAUDE.md` или перестроить протокол закрытия на новую явную схему
    - Проверить исправление на реальном закрытии задачи
  - Артефакт: корректный формат `SESSION-CONTEXT.md`, чистый вывод `close-task.sh`, восстановленный или осознанно заменённый протокол закрытия, зафиксированное решение по архитектуре закрытия
  - Репо: DS-strategy / корневой скрипт `~/Github/close-task.sh` / корневой `CLAUDE.md`

- [pending] 2026-03-21: Завтра сделать заказ на Submarine Coffee
  - Контекст: Прямая задача от пользователя после закрытия сессии; обязательно выполнить на следующий день
  - Приоритет: critical
  - Дедлайн: 2026-03-22
  - Репо: DS-strategy

- [pending] 2026-03-21: 🔴 Приоритетно — обязательный стартовый экран состояния экзокортекса при открытии рабочей сессии
  - Контекст: Пользователь согласовал, что при фразах вроде «открывай день», «начинаем работу», «открывай рабочую сессию» система должна сначала показывать обязательный статус экзокортекса, а не сразу переходить к задачам. Главная боль: день не должен начинаться вслепую, если strategist/extractor/scheduler сломаны. Новый образ системы: «мозг» — это координирующий слой экзокортекса; если мозг не работает, значит нельзя считать, что рабочая среда готова.
  - Приоритет: critical
  - Что нужно реализовать:
    1. Жёсткий session-open gate: сначала проверка scheduler / health-check / auth helper / strategist / extractor / status-artifacts
    2. Единый стартовый экран в чате с коротким итогом состояния перед любыми задачами дня
    3. Полностью русская терминология: без warning / critical / info в пользовательском тексте
    4. Визуальная индикация статуса: зелёный / жёлтый / красный + заметные символы для интерфейса и терминала
    5. Блокировка обычного старта дня при критическом сбое среды: сначала сообщение о проблеме и требуемом действии
    6. Использование как источников правды AGENTS-STATUS.md, SchedulerReport и status-файлов в ~/.local/state/exocortex/status/
    7. Отдельный верхнеуровневый статус «мозг экзокортекса»: может ли координирующий слой запускать и согласованно отслеживать агентов
    8. Проверка не только агентов, но и критических связок среды: Google Drive sync, творческий конвейер, извлечение заметок из Obsidian, ключевые shell/runtime-скрипты, auth/helper layer, распределение секретов и проектных доступов
    9. Формат как у приборной панели автомобиля: перед началом движения видно, какие подсистемы исправны, какие в деградации, какие требуют немедленного вмешательства
    10. При критическом сбое «мозга» или ключевой связки — запрет на обычное открытие дня до явного сообщения о проблеме и нужном действии
  - Цель: чтобы при старте любой рабочей сессии пользователь сразу видел, готова ли среда к работе, и не продолжал день вслепую
  - Артефакт: обязательный протокол открытия сессии + красивый русский экран статуса + верхнеуровневый индикатор состояния «мозга»
  - Репо: FMT-exocortex-template / DS-strategy

- [pending] 2026-03-21: Регламент проверки бариста по воронке продаж
  - Контекст: Во время доработки SERVICE.METHOD.001-v3 пользователь сформулировал отдельный артефакт для менеджера: как проводить проверку/собеседование по воронке продаж, какие ответы бариста считать правильными, какие нет
  - Приоритет: high
  - Что нужно разработать:
    - Формат проверки менеджером
    - Набор вопросов/кейсов для бариста
    - Критерии правильного/неправильного ответа
    - Признаки уверенного применения воронки на смене
  - Артефакт: отдельный регламент/чек-лист проверки, связанный с SERVICE.METHOD.001-v3
  - Репо: VK-offee

- [pending] 2026-03-21: Отдельный стандарт продажи маркета
  - Контекст: Во время доработки SERVICE.METHOD.001-v3 выяснилось, что маркет нельзя вшивать в базовую простую воронку. Нужен отдельный стандарт: когда предлагать зерно/drip/шоколад, по каким триггерам и как не превращать это в кассовый скрипт
  - Приоритет: high
  - Что нужно разработать:
    - Триггеры для оффера маркета
    - Ограничения: без очереди, при наличии контакта/интереса
    - Формат разговорного оффера
    - Связь с базовой воронкой и обычной допродажей
  - Артефакт: отдельный метод/стандарт продажи маркета
  - Репо: VK-offee

- [pending] 2026-03-15: Дальнейшее улучшение воронки продаж SERVICE.METHOD.001
  - Контекст: РП#19 завершён, создана v2 с базовыми SOTA-улучшениями
  - Приоритет: medium
  - Что улучшать:
    - Персонализация (история гостя, постоянные клиенты)
    - Метрики эффективности (средний чек, конверсия допродаж)
    - A/B тестирование формулировок
    - Обучающие материалы для бариста
  - Артефакт: SERVICE.METHOD.001-v3
  - Репо: VK-offee (PACK-service)

- [done] 2026-03-04: Проверить все файлы PACK-kitchen на соответствие формату с русскими описаниями в скобках
  - Контекст: РП#3, вн��плановая правка во время извлечения методов
  - Приоритет: medium
  - Результат: Обновлены все 6 файлов (2 entities, 3 methods, 1 WP)

- [done] 2026-03-04: Разработать RAG-бота для базы знаний VK-offee
  - Контекст: РП#3, внеплановая задача во время извлечения failure modes
  - Приоритет: high
  - Результат: ✅ RAG-бот создан и работает (VK-offee-rag/). Индексация 27 файлов, поиск + генерация через Claude API

- [pending] 2026-03-05: MCP-сервер для индекса знаний VK-offee
  - Контекст: РП#5, развитие RAG-бота
  - Приоритет: medium
  - Описание: Создать MCP-сервер для стандартного доступа к индексу знаний (как у Цырена в планах)
  - Референс: DS-Knowledge-Index-Tseren (идеи про MCP в постах)
  - Артефакт: MCP-сервер с endpoints для поиска по VK-offee Pack

- [pending] 2026-03-05: 🔴 СРОЧНО: Интеграция RAG-бота с Telegram ботом
  - Контекст: Telegram бот работает, но не находит информацию (ищет в старой knowledge-base/). RAG-бот знает ответы, но не подключен
  - Приоритет: critical
  - Проблема: Пользователь спрашивает "Какая зарплата у повара?" → бот отвечает "нет информации", хотя RAG знает ответ
  - Решение:
    1. Запустить RAG API сервер (python src/api.py)
    2. Модифицировать bot.py → заменить search_knowledge_base() на вызов RAG API
    3. Протестировать те же вопросы
  - Бюджет: ~30-60 мин
  - Telegram бот запущен: процесс 63754, токен обновлён

- [pending] 2026-03-05: Telegram бот интеграция с RAG
  - Контекст: РП#5, интеграция RAG-бота
  - Приоритет: high
  - Требования:
    - Интеграция VK-offee-rag с существующим telegram-bot/
    - Команды: /search <вопрос>, /help
    - Webhook или polling
    - Библиотека: python-telegram-bot
  - Ключи: TELEGRAM_BOT_TOKEN уже есть в .env

- [pending] 2026-03-05: Автообновление индекса RAG при изменении Pack
  - Контекст: РП#5, автоматизация RAG-бота
  - Приоритет: medium
  - Описание: File watcher для автоматической переиндексации при изменении файлов в VK-offee/PACK-*
  - Варианты: watchdog (Python), launchd агент, git hooks

- [pending] 2026-03-05: API документация для RAG-бота (Swagger)
  - Контекст: РП#5, документация
  - Приоритет: low
  - Описание: Добавить Swagger UI для FastAPI endpoints в VK-offee-rag/src/api.py

- [pending] 2026-03-04: Создать архив для необработанных материалов knowledge-base
  - Контекст: РП#3, внеплановая задача во время работы с БАР
  - Приоритет: medium
  - Действия: Создать папку archive/ в VK-offee, переместить туда все необработанные файлы из knowledge-base для последующей обработки экстрактором

- [pending] 2026-03-04: Конвертировать все CSV файлы в MD формат
  - Контекст: RAG-бот не ищет по CSV. Пользователь: "нужна такая структура чтобы все боты легко искали любую информацию"
  - Приоритет: high (обновлено 2026-03-06)
  - Требования:
    - MD-таблицы с заголовками (удобно для людей)
    - Структура для поиска ботами (RAG читает .md)
    - Разделы с подзаголовками (Кофе / Не кофе / Чай / ...)
  - Действи��:
    1. Найти все CSV файлы в knowledge-base и archive
    2. Конвертировать в MD с красивыми таблицами и заголовками разделов
    3. Сохранить оригиналы CSV в archive/original-csv/
    4. Для прайс-листов — разместить в соответствующих PACK (BAR.WP, KITCHEN.WP)
    5. Обновить ссылки в Pack на новые MD файлы

- [pending] 2026-03-04: Привести все названия файлов к стандарту: ENG-id + русское описание
  - Контекст: Обнаружено при проверке PACK-kitchen
  - Приоритет: high
  - Проблема: KITCHEN.ENTITY.001-kitchen-concept.md - нет русского описания
  - Стандарт: ID-english-slug (Русское описание для человека)
  - Пример: KITCHEN.ENTITY.001-kitchen-concept (Концепция нового помещения кухни)
  - Действия:
    1. Проверить ВСЕ файлы во всех Pack (kitchen, bar, service, hr, management)
    2. Переименовать файлы по стандарту: ID-slug (Русское описание)
    3. Обновить все ссылки в файлах
    4. Применить стандарт ко всем будущим файлам

- [pending] 2026-03-04: Запустить и проверить сессию стратегирования через Obsidian
  - Контекст: Проверка связки Obsidian → GitHub → Экстрактор
  - Приоритет: high
  - Действия:
    1. Проверить синхронизацию Obsidian vault → creativ-convector GitHub
    2. Убедиться что экстрактор видит исчезающие заметки и черновики
    3. Запустить полную цепочку: Obsidian → GitHub → Экстрактор → Captures → VK-offee Pack
    4. Протестировать сессию стратегирования end-to-end

- [pending] 2026-03-04: Проработать архитектуру интеграции Obsidian → Экстрактор
  - Контекст: Вопрос от пользователя о правильности текущей архитектуры
  - Приоритет: high
  - Вопросы для проработки:
    1. Видит ли экстрактор все заметки после работы sync_obsidian.sh?
    2. Правильно ли текущая схема: Obsidian → GitHub (creativ-convector) → Экстрактор?
    3. Альтернатива: Экстрактор читает Obsidian напрямую (без GitHub промежутка)?
    4. Интеграция в DS-strategy: встроить Obsidian как источник данных?
  - Действия:
    1. Проанализировать текущий поток: Obsidian → sync → GitHub → session-watcher → Экстрактор
    2. Проверить, все ли заметки доходят до экстрактора
    3. Рассмотреть альтернативы: прямое чтение Obsidian, webhook, file watcher
    4. Предложить оптимальную архитектуру с обоснованием

- [pending] 2026-03-04: Обработка архива и необработанных документов экстрактором
  - Контекст: Архив создан с БАР, Персонал, ДЛЯ ШЕФА + документы на Google Drive
  - Приоритет: high
  - Действия:
    1. Проанализировать все документы в VK-offee/archive/ (БАР, Персонал, ДЛЯ ШЕФА)
    2. Проверить необработанные документы на Google Drive
    3. Запустить Extractor для обработки всех документов
    4. Распределить извлечённые знания по 5 Pack (bar, kitchen, service, hr, management)
    5. Если Extractor не знает куда отправить информацию → разработать новую предметную область
    6. Создать отчёт: что обработано, что распределено, какие новые области нужны

- [pending] 2026-03-06: Tracking CSV → MD конвертации в knowledge-base
  - Контекст: knowledge-base/ = зеркало Google Drive (CSV/DOCX), PACK-* = структурированное знание (MD). Нужен способ понять, какие источники уже формализованы в PACK
  - Приоритет: low
  - Предварительный вывод: архитектура уже правильная — knowledge-base/ для сырых данных, PACK для бот-ридабельных MD. Дублирование CSV/MD — это норма (не баг). Люди могут скачивать CSV с GitHub когда нужно работать с Excel
  - Единственный gap: нет реестра "что из knowledge-base уже есть в PACK"
  - Решение (если понадобится): создать `knowledge-base/CONVERSION-STATUS.md` — простая таблица: source CSV → PACK WP ID. Например: `Калькуляции напитки - Кофе.csv → BAR.WP.006`
  - Статус: не блокирует, в текущей архитектуре не критично

---

## Новые задачи W09 (2026-03-06)

- [pending] 2026-03-06: Интеграция с Saby Presto (Сабы Престо) через API
  - Контекст: Saby Presto — система учёта кофейни, содержит актуальные цены, остатки, продажи
  - Приоритет: high
  - Цель: получать актуальные данные (цены, меню, остатки) напрямую из учётной системы вместо ручного обновления в Pack
  - Что нужно выяснить:
    1. Есть ли у Saby Presto открытый API / документация
    2. Какие данные доступны через API (цены, продажи, остатки, сотрудники)
    3. Как авторизация (OAuth, API-key, токен)
    4. Где хранить credentials (env, secrets)
  - Потенциальные интеграции:
    - RAG-бот: отвечает на вопросы о ценах из актуального источника
    - Автообновление BAR.WP и KITCHEN.WP при изменении цен
    - Аналитика продаж → PACK-management
  - Действия:
    1. Найти документацию Saby Presto API (saby.ru / СБИС API)
    2. Получить API-ключ / настроить доступ
    3. Написать тестовый скрипт — запрос меню/цен
    4. Интегрировать в RAG-бот как источник данных



- [done] 2026-03-06: 🔴 СРОЧНО: Обработать ГПХ документы — ранер, официант, повар
  - Контекст: Все ГПХ обработаны и сохранены
  - Результат: ✅ Все 4 ГПХ формализованы в PACK-hr (HR.WP.001-004) и сохранены в knowledge-base/Разработано в базе данных/ГПХ/
  - Приоритет: critical
  - Домен: PACK-hr (договоры), PACK-service (ранер, официант), PACK-kitchen (повар)
  - Что найдено:
    - archive/Персонал/Документы при трудоустройстве/ГПХ РАННЕР.md ✓
    - archive/Персонал/Документы при трудоустройстве/ГПХ ОФИЦИАНТ.md ✓
    - archive/Персонал/Документы при трудоустройстве/ГПХ Бариста.md ✓ (не повар!)
    - Google Drive: ГПХ РАННЕР.gdoc, ГПХ ОФИЦИАНТ.gdoc, ГПХ Бариста.gdoc
    - ГПХ Повара — НЕ НАЙДЕН (возможно нужно создать)
  - Действия РП:
    1. Прочитать все 3 ГПХ файла (ранер, официант, бариста)
    2. Уточнить: нужен ли ГПХ именно для повара или имелся в виду бариста?
    3. Определить структуру данных для Pack: ГПХ — это WP в PACK-hr
    4. Формализовать каждый ГПХ как HR.WP.00N-gpkh-{role}.md в PACK-hr/04-work-products/
    5. Описание роли из ГПХ → entities в соответствующих Pack (SERVICE.ENTITY для раннера и официанта)
    6. Если ГПХ повара нет → создать по аналогии с ГПХ бариста (с адаптацией под кухню)
  - Репо: VK-offee (PACK-hr, PACK-service, PACK-kitchen)
  - Бюджет: ~1.5h

- [pending] 2026-03-06: Пайплайн "Сессия → Задачи → INBOX-TASKS.md"
  - Контекст: Обнаружен gap: session-import извлекает только знания в Pack, задачи из сессии теряются
  - Приоритет: high
  - Статус реализации: prompt session-tasks.md создан, extractor.sh обновлён
  - Что сделано:
    - FMT-exocortex-template/roles/extractor/prompts/session-tasks.md — новый промпт
    - extractor.sh — добавлен case "session-tasks"
    - Вызов: extractor.sh session-tasks
  - Что осталось:
    1. Интегрировать в session-watcher.sh (чтобы запускался автоматически после session-import)
    2. Протестировать на реальной сессии стратегирования
    3. Проверить что INBOX-TASKS.md не дублирует существующие задачи
  - Анализ системных изменений: см. ниже
  - Репо: FMT-exocortex-template

### Анализ: session-tasks в системе

**Какой агент:** экстрактор (roles/extractor) — расширение существующей роли.
Агент тот же (Claude Code + extractor.sh), новый prompt-файл.

**Плюсы:**
- Закрывает реальный gap: задачи из сессий перестают теряться
- Переиспользует существующую инфрастр��ктуру (launchd, extractor.sh, session-watcher)
- Разделение ответственности: session-import = знания → Pack, session-tasks = действия → inbox

**Минусы и риски:**
- Дублирование обработки одного файла: session-import + session-tasks читают одну сессию → риск что оба запустятся и задачи задублируются
- Нарушает паттерн Human-in-the-Loop: inbox-check генерирует отчёт → человек одобряет. Session-tasks пишет напрямую в INBOX-TASKS.md — без одобрения
- extractor.sh стейджит captures.md + extraction-reports/. Нужно добавить INBOX-TASKS.md — изменение git-логики
- Два промпта нужно поддерживать параллельно при изменении формата сессий

**Противоречия с текущей системой:**
- session-watcher.sh триггерит только session-import. Нужно добавить session-tasks в цепочку
- Метки обработанности: session-import метит `[source: сессия YYYY-MM-DD]` в captures.md. Session-tasks должен иметь свою метку чтобы не запускаться повторно
- run_claude() в extractor.sh коммитит только captures.md и extraction-reports/ — session-tasks нуждается в другом наборе файлов → сделано: добавлен отдельный git add для INBOX-TASKS.md после run_claude

- [pending] 2026-03-06: Обновить реквизиты ИП во всех ГПХ (Подгаевский → Жукова)
  - Контекст: ИП сменился. Данные: ИП Жукова В.С., ИНН 910207662587, ОГРНИП 326911200014188, р/с 40802810952720027078 (ЮГО-ЗАПАДНЫЙ БАНК ПАО СБЕРБАНК, БИК 046015602, корр. 30101810600000000602)
  - Приоритет: critical
  - Файлы: archive/Персонал/ (ГПХ Бариста, Официант, Раннер, Повар) + PACK-hr/HR.WP.001-004 + Google Drive (вручную)

- [pending] 2026-03-06: Создать PACK-legal (Юридические документы и реквизиты компании)
  - Контекст: Нужно место для реквизитов ИП Жукова, шаблонов ГПХ, прочих юридических документов
  - Приоритет: medium
  - Открытый вопрос: ГПХ остаются в PACK-hr или переносятся в PACK-legal?

- [pending] 2026-03-06: Юридическая проверка ГПХ документов
  - Контекст: Заголовок "ТРУДОВОЙ ДОГОВОР НА ОСНОВЕ ГРАЖДАНСКО-ПРАВОВОГО ХАРАКТЕРА" — противоречие в терминах. Риск переквалификации в трудовые отношения (ст. 15 ТК РФ)
  - Приоритет: high
  - Действия: проверить по ГК РФ (гл. 37-39), исправить заголовок, убрать трудовые признаки
  - Рекомендация: проконсультироваться с юристом

---

## Новые задачи W11 (2026-03-14)

- [pending] 2026-03-14: Оптимизация расхода токенов на чтение из кэша
  - Контекст: Статистика показывает огромный расход: 7.4 млн токенов создания кэша, 15.6 млн токенов чтения из кэша за сегодня
  - Приоритет: high
  - Проблема: Чтение из кэша расходует в 2 раза больше токенов чем создание
  - Что исследовать:
    1. Какие файлы попадают в кэш (CLAUDE.md, VK-offee/CLAUDE.md, memory/*, FPF-Spec.md?)
    2. Можно ли уменьшить размер кэшируемых файлов
    3. Можно ли отключить кэширование для редко используемых файлов
    4. Оптимизировать CLAUDE.md и memory/* (убрать дубли, сократить)
    5. Проверить настройки prompt caching в Claude API
  - Цель: Снизить расход токенов на чтение из кэша минимум в 2 раза
  - Репо: ~/Github/CLAUDE.md, memory/, VK-offee/CLAUDE.md
  - Бюджет: ~2-3h (анализ + оптимизация)

## Новые задачи W11 (2026-03-14)

- [pending] 2026-03-14: Организация документов парка — карточки и Google Drive
  - Контекст: РП#13, внеплановая задача во время подготовки ответа архитектору
  - Приоритет: high
  - Что сделать:
    1. Собрать все документы парка в одной папке PACK-park-development/04-work-products/
    2. Создать для каждого файла карточку-описание (метаданные, краткое содержание)
    3. Скопировать все документы на Google Drive (скрипт sync_google_drive.py уже настроен)
    4. В каждой карточке указать ссылку на документ в Google Drive
  - Цель: Упростить поиск документов для бота и людей
  - Репо: VK-offee (PACK-park-development)
  - Бюджет: ~1.5h

- [pending] 2026-03-14: Аудит документов парка — полнота и источники
  - Контекст: РП#13, проверка что все документы собраны
  - Приоритет: high
  - Что сделать:
    1. Тщательно проверить все документы парка из всех доступных источников:
       - PACK-park-development/04-work-products/
       - Google Drive (папка Парк)
       - Telegram переписки
       - Email переписки
       - Локальные папки (Downloads, Desktop)
    2. Составить карточку папки с полным перечнем всех документов
    3. Проанализировать чего не хватает (по списку из RNS_meeting_document_v3.pdf)
    4. Предоставить отчёт: что есть, чего не хватает, где искать
  - Цель: Убедиться что ничего не потеряно перед подачей на РНС
  - Репо: VK-offee (PACK-park-development)
  - Бюджет: ~2h

- [pending] 2026-03-14: Переключить extractor на Haiku когда починится доступ к модели
  - Контекст: Временно переключили на Sonnet из-за API 503 "model_not_found" для claude-haiku-4-5-20251001
  - Приоритет: low
  - Действия:
    1. Дождаться восстановления доступа к Haiku через API
    2. Изменить в FMT-exocortex-template/roles/extractor/scripts/extractor.sh строку 25: `--model claude-haiku-4-5` вместо `--model claude-sonnet-4-6`
    3. Протестировать extractor.sh inbox-check
  - Цель: Снизить расход токенов на фоновые задачи экстрактора
  - Репо: FMT-exocortex-template
  - Бюджет: ~5 мин

- [pending] 2026-03-14: Прокачать Claude Code Skills — добавить Novita AI API
  - Контекст: Интеграция Novita AI для расширения возможностей
  - Приоритет: medium
  - Действия:
    1. Получить API ключ Novita AI
    2. Добавить навык (skill) для работы с Novita AI API
    3. Настроить конфигурацию в Claude Code
    4. Протестировать интеграцию
  - Цель: Расширить возможности Claude Code через Novita AI
  - Бюджет: ~1-2h

- [pending] 2026-03-14: Подключить Claude Code к удалённому серверу
  - Контекст: Настройка удалённого хранилища для рабочей среды
  - Приоритет: medium
  - Действия:
    1. Настроить Claude Code для работы с удалённым сервером
    2. Подключить репозитории рабочей среды к удалённому хранилищу
    3. Настроить синхронизацию
    4. Протестировать доступ и работу
  - Цель: Обеспечить доступ к рабочей среде с удалённого сервера
  - Репо: Все репо в ~/Github/
  - Бюджет: ~2-3h

- [pending] 2026-03-14: Перенести Telegram бот на облачный сервер (VPS)
  - Контекст: Telegram бот VK-offee работает только когда Mac включён. Нужен постоянный хостинг
  - Приоритет: high
  - Проблема: Бот недоступен когда компьютер выключен
  - Действия:
    1. Выбрать провайдера VPS (DigitalOcean $6/мес, Hetzner €4/мес, Timeweb ₽300/мес)
    2. Арендовать сервер (минимальная конфигурация: 1 CPU, 1GB RAM)
    3. Настроить сервер (Ubuntu, Python, зависимости)
    4. Перенести код бота на сервер
    5. Настроить автозапуск (systemd service)
    6. Перенести .env с токенами
    7. Протестировать работу 24/7
  - Цель: Бот работает постоянно, независимо от состояния Mac
  - Репо: VK-offee-rag (telegram-bot/)
  - Бюджет: ~2-3h

## Новые задачи W09 (2026-03-09)

- [pending] 2026-03-09: Проработать решение ведения Instagram с помощью AI
  - Контекст: Автоматизация контента для Instagram кофейни
  - Приоритет: medium
  - Что нужно проработать:
    1. Генерация контента (посты, сторис, описания)
    2. Планирование публикаций
    3. Анализ вовлечённости
    4. Инструменты: ChatGPT API, Midjourney/DALL-E для изображений, Buffer/Later для планирования
  - Артефакт: Концепт системы + инструменты + процесс
  - Репо: VK-offee (PACK-management или новый PACK-marketing)

- [pending] 2026-03-09: Подробно описать регламент работы кухни (открытие смены + все нюансы)
  - Контекст: Есть шаблон регламента, нужно найти и дополнить
  - Приоритет: high
  - Что сделать:
    1. Найти существующий файл регламента кухни (KITCHEN.WP или PROCESSES.md)
    2. Описать полный процесс открытия смены
    3. Добавить все нюансы работы
    4. Проработать вывод информации: распечатка ККТ или экран Saby
    5. Подключить Saby API для автоматизации
  - Цель: Реально работающий регламент на кухне
  - Артефакт: KITCHEN.WP.00N-shift-opening.md + интеграция с Saby
  - Репо: VK-offee (PACK-kitchen)

- [pending] 2026-03-09: Разработать регламент контроля выполнения задач менеджером (Жанна)
  - Контекст: Менеджер может уехать на целый день, не прикоснуться к задачам, никому не сказать. Потом выполняет в запаре, напрягая всех
  - Приоритет: critical
  - Проблема: Нет системы реальной постановки и контроля выполнения задач на неделю
  - Что есть: Записи планёрок в Телеосте (голосовые/видео)
  - Что нужно:
    1. Транскрибация планёрок (Whisper API / Телеост API)
    2. Извлечение задач из транскрипции (Claude API)
    3. Определение бюджета времени на задачу
    4. Система контроля выполнения (чеклисты, дедлайны, напоминания)
    5. Отчётность: что сделано, что в процессе, что просрочено
  - Артефакт:
    - MANAGEMENT.WP.00N-task-control-protocol.md (регламент)
    - Скрипт транскрибации планёрок
    - Дашборд контроля задач (Notion / Telegram бот / веб-интерфейс)
  - Репо: VK-offee (PACK-management), возможно новый DS-instrument для автоматизации
  - Бюджет: ~4-6h (сложная задача, требует интеграций)

- [pending] 2026-03-14: Добавить русские названия ко ВСЕМ папкам в репозиториях
  - Контекст: РП#13, улучшение навигации
  - Приоритет: high
  - Проблема: Папки называются только на английском (01-concepts, 02-domain-entities), сложно искать
  - Стандарт: `NN-english-name (Русское название)`
  - Примеры:
    - `PACK-park-development` → `PACK-park-development (Парк Голубинка)`
    - `01-concepts` → `01-concepts (Концепции)`
    - `02-domain-entities` → `02-domain-entities (Сущности домена)`
    - `03-methods` → `03-methods (Методы)`
    - `04-work-products` → `04-work-products (Рабочие продукты)`
    - `05-failure-modes` → `05-failure-modes (Типовые ошибки)`
  - Что сделать:
    1. Проверить ВСЕ папки во всех Pack (bar, kitchen, service, hr, management, park-development)
    2. Переименовать папки по стандарту с русскими названиями в скобках
    3. Проверить что git корректно отслеживает переименование (git mv)
    4. Обновить все ссылки в документах если нужно
  - Цель: Упростить навигацию по структуре для людей
  - Репо: VK-offee (все Pack)
  - Бюджет: ~2h

- [pending] 2026-03-14: Полный рефакторинг структуры репозиториев и документов
  - Контекст: РП#13, системная задача по наведению порядка
  - Приоритет: high
  - Что сделать:
    1. **Русские названия файлов:** Проверить ВСЕ документы во всех репо, добавить русские названия где их нет (формат: ID-slug (Русское описание).md)
    2. **Удаление дублей:** Найти и удалить дублирующиеся файлы
    3. **Правовые документы парка и ИП Жукова:** Разложить все сканы, договоры, ГПЗУ по папкам в PACK-park-development
    4. **Извлечение из Telegram:** Достать все документы из чата с архитекторами, сохранить в Pack
    5. **Карточки для правовых документов:** Создать entity-карточки для всех правовых документов с метаданными
    6. **Переименование ~/Github/ → ~/РабочаяСреда/:**
       - Проанализировать риски (скрипты, агенты, пути в конфигах)
       - Составить план миграции
       - Обновить все пути в скриптах (.github/scripts/, launchd агенты)
       - Обновить CLAUDE.md, memory/, конфиги MCP
       - Протестировать после переименования
    7. **Финальный отчёт:** Подробный отчёт о проделанной работе + предложения по улучшению
  - Цель: Навести порядок во всей рабочей среде
  - Репо: Все репо в ~/Github/
  - Бюджет: ~6-8h (большая задача)

- [pending] 2026-03-14: Проверить обновления DS-Knowledge-Index-Tseren
  - Контекст: РП#13, проверка изменений в репо Цырена
  - Приоритет: medium
  - Что сделать:
    1. Открыть репо DS-Knowledge-Index-Tseren
    2. Проверить файл Knowledge Index Current (или аналогичный)
    3. Посмотреть что изменилось (git log, git diff)
    4. Проанализировать изменения — что добавлено, что улучшено
    5. Оценить применимость к нашей системе
    6. Доработать наши инструменты если нужно
  - Цель: Не упустить полезные обновления от Цырена
  - Репо: DS-Knowledge-Index-Tseren
  - Бюджет: ~1h

---

## [2026-03-14] Аудит документов PACK-park-development

**Задача:** Тщательно проверить все документы парка — извлечены ли из всех доступных источников (Telegram, Downloads, Google Drive), хранятся ли в одном месте.

**Шаги:**
1. Собрать все документы парка в PACK-park-development/04-work-products/
2. Составить карточку папки с перечнем всех документов (название, тип, статус, источник)
3. Проверить источники: Telegram-переписки, Downloads, Google Drive
4. Проанализировать чего не хватает для РНС
5. Предоставить отчёт с gap-анализом

**Приоритет:** high
**Репо:** VK-offee/PACK-park-development

---

## Новые задачи W12 (2026-03-19)

- [pending] 2026-03-19: Починить post-commit hook в VK-offee — конфликт с git pull --rebase
  - Контекст: Hook автоматически пушит после каждого коммита. При git pull --rebase hook срабатывает в середине rebase → петля конфликтов
  - Приоритет: high
  - Решение: добавить guard в hook — проверять наличие .git/rebase-merge перед push
  - Файл: ~/Github/VK-offee/.git/hooks/post-commit
  - Бюджет: ~15 мин

- [pending] 2026-03-19: Создать карточки-описания для всех фото, скринов и бинарных файлов в PACK-park-development
  - Контекст: Бот не может читать PNG, JPG, XLSX, PDF — нужны MD карточки с описанием содержимого
  - Приоритет: high
  - Что сделать: для каждого файла без MD-карточки создать PARK.DOC.XXX-name (Описание).md с кратким содержимым, датой, источником
  - Репо: VK-offee (PACK-park-development)
  - Бюджет: ~1h

- [pending] 2026-03-19: Система мониторинга агентов — ежедневные алерты + аудит каждые 3 дня
  - Контекст: 10 дней агенты не работали из-за истёкшего OAuth токена (401). Никто не знал. SESSION-CONTEXT устарел, WeekPlan не создался автоматически.
  - Приоритет: critical
  - Что сделать:
    1. **Ежедневная проверка (утром):** скрипт health-check.sh — проверяет exit codes всех агентов в логах за последние 24ч, если есть ошибки → уведомление в Telegram
    2. **Алерт на 401:** отдельный триггер — если любой агент вернул 401 → немедленное уведомление "Токен истёк, нужен claude /login"
    3. **Аудит каждые 3 дня:** скрипт infra-audit.sh — проверяет все plist, скрипты агентов, пути, зависимости, последний успешный запуск каждого агента
    4. **Dashboard статуса:** простой отчёт в DS-strategy/current/AGENTS-STATUS.md — обновляется автоматически каждое утро
    5. **Интеграция в launchd:** зарегистрировать health-check как отдельный агент (ежедневно в 08:00)
  - Артефакт: health-check.sh + infra-audit.sh + AGENTS-STATUS.md + launchd plist
  - Репо: FMT-exocortex-template (roles/synchronizer/scripts/)
  - Бюджет: ~2-3h

## Новые задачи W12 (2026-03-15)

- [pending] 2026-03-15: Проработать учёт хорики (одноразовая посуда, химия)
  - Контекст: Система учёта расходных материалов (одноразовая посуда, бытовая химия, салфетки и т.д.)
  - Приоритет: high
  - Что сделать:
    1. Анализ цен на все виды хорики (поставщики, прайсы)
    2. Анализ текущих трат (промониторить все накладные)
    3. Продумать систему учёта и списания (по дням, по смене, по расходу)
    4. Найти алгоритм оптимизации (снижение затрат без потери качества)
  - Выход: Система учёта хорики + рекомендации по оптимизации
  - Репо: VK-offee (PACK-kitchen)
  - Бюджет: ~3-4h

- [pending] 2026-03-16: Доработать второе письмо архитекторам
  - Контекст: РП#10, письмо о подготовке к строительству
  - Приоритет: high
  - Действие: После получения ответа архитекторов на первое письмо (ожидается 18.03) доработать второе письмо
  - Текущая версия: PARK.WP.024 (черновик)
  - Что изменить:
    1. Тема письма: не "АР и КР", а "пока разрабатывается и согласовывается РНС, прорабатывать смету"
    2. Согласовать содержание на основе ответа архитекторов
    3. Уточнить входимость работ в договор
  - Артефакт: PARK.WP.024 (финальная версия)
  - Репо: VK-offee (PACK-park-development)

- [pending] 2026-03-19: Починить и стабилизировать Telegram бот VK-offee
  - Контекст: Бот сырой — падает с NetworkError (DNS), использует OpenAI вместо Claude, ищет в knowledge-base/ вместо Pack
  - Приоритет: high
  - Проблемы:
    1. NetworkError при старте без сети — нет retry логики
    2. search_knowledge_base() ищет в knowledge-base/ — устарело, нужно искать в PACK-*
    3. Использует OpenAI API — нужно переключить на Claude
    4. Не запущен постоянно — нет launchd агента или VPS
  - Действия:
    1. Добавить retry + reconnect логику при NetworkError
    2. Переключить поиск на PACK-* директории
    3. Заменить OpenAI на Claude API
    4. Настроить автозапуск (launchd или VPS)
  - Репо: VK-offee/telegram-bot/
  - Бюджет: ~3h

- [pending] 2026-03-17: Интеграция Claude Code с Telegram (отправка сообщений)
  - Контекст: Нужна возможность отправлять карточки, напоминания, отчёты из Claude Code в Telegram
  - Приоритет: medium
  - IntegrationGate:
    - Тип: инструмент
    - Контур: L4 Personal
    - Роль: агент-ассистент → пользователь
    - Продукт: сообщения в Telegram
    - Процесс: отправка карточек, напоминаний, отчётов
  - Варианты:
    1. Telegram Bot API (бот VK-offee уже есть, токен в .env)
    2. MCP-сервер для Telegram (инструмент в Claude Code)
  - Бюджет: ~15-30 мин
  - Репо: VK-offee-rag (telegram-bot/) или новый MCP

- [in_progress] 2026-03-24: 📞 Позвонить проектной организации по вывеске Самокиша
  - Контекст: РП#16 завершён, подрядчик выбран, нужно согласовать проектную документацию
  - Статус: Звонок сделан, ждём специалиста 26.03 для замера и оценки возможности согласования конструкции
  - Приоритет: high
  - Контакты:
    - Телефон: +7 (988) 418-50-09
    - Адрес: Симферополь, ул. Балаклавская 68, офис 510
    - ИНН: 910809437123, ОГРН: 323911200101245
  - Что уточнить:
    1. Стоимость разработки эскизного проекта + проектной документации
    2. Сроки выполнения
    3. Портфолио (примеры работ)
    4. Опыт получения разрешений в администрации Симферополя
    5. Что нужно предоставить (фото фасада, размеры, пожелания по дизайну)
  - Карточка подрядчика: VK-offee/vendors/contractors/signage-project-contractor (Проектная организация для вывески).md
  - Связанный документ: CO.WP.002 (Пакет документов для разрешения на вывеску)
  - Репо: VK-offee
  - Бюджет: ~30 мин (звонок + фиксация договорённостей)

- [done] 2026-03-20: Выгрузка документов из Saby в базу знаний VK-offee
  - Контекст: Задача фактически выполнена — выгружены меню, цены, остатки, продажи, накладные
  - Приоритет: high
  - Результат: ✅ Документы из Saby сохранены в VK-offee, разложены по PACK-bar / PACK-kitchen / PACK-management, созданы карточки для бота и аналитики
  - Что сделать:
    1. Созвониться с Жанной — уточнить какие документы из Saby нужны (меню, цены, остатки, продажи, накладные)
    2. Настроить выгрузку из Saby Presto (API или экспорт)
    3. Конвертировать в MD формат (если CSV/XLSX)
    4. Залить в соответствующие Pack (BAR, KITCHEN, MANAGEMENT)
    5. Обновить индекс RAG-бота
  - Связанная задача: Интеграция с Saby Presto API (2026-03-06)
  - Репо: VK-offee (PACK-bar, PACK-kitchen, PACK-management)
  - Бюджет: ~2-3h (после созвона)

## [Задачи из сессии 2026-03-24] [source: сессия 2026-03-24]

- [in_progress] 2026-03-24: Уточнить у Константина последовательность шагов после сдачи архитектурного проекта PARK
  - Контекст: Константин сообщил: «Сегодня передаю в КР чертежи. Добавил ещё ряд изменений в проекте для соответствия определенным требованиям.» Нужно зафиксировать новый этап и уточнить дальнейшую последовательность
  - Приоритет: high
  - Домен: Парк

- [pending] 2026-03-24: Составить список оборудования и инженерных требований для новой кухни и выпечки
  - Контекст: заметка «Кухня на новом месте» — нужно определить оборудование, размещение, вытяжку, мойки, электрику, фритюр, сувид, морозилку и прочую инфраструктуру
  - Приоритет: high
  - Домен: Кухня

- [pending] 2026-03-24: Обсудить с Толиком электрическую нагрузку и требования по подключени�� оборудования для новой кухни
  - Контекст: заметка «Кухня на новом месте» — отдельно выделен вопрос нагрузки и электрики под печь и оборудование
  - Приоритет: high
  - Домен: Кухня

- [pending] 2026-03-24: Описать роли проекта цифровой системы управления кофейней и Pack по каждой роли
  - Контекст: заметка «Разработки По для руководителя кофейни» — нужно выделить все роли проекта и описать под каждую роль конкретный Pack и рабочую станцию
  - Приоритет: medium
  - Домен: Стратегия

- [pending] 2026-03-24: Спроектировать агента оценки знаний сотрудников по модулям обслуживания, кофе и продукции
  - Контекст: заметка «Разработки По для руководителя кофейни» — бот должен опрашивать сотрудников, формировать рейтинг и связывать его с оплатой
  - Приоритет: medium
  - Домен: HR

- [pending] 2026-03-24: Выделить слот и запустить пилот по системе лояльности в Saby
  - Контекст: заметка «Система лояльности» — инструменты уже куплены, нужно изучить доступные механики, выбрать одну и сделать пробный запуск
  - Приоритет: high
  - Домен: VK Coffee

- [pending] 2026-03-24: Съездить с Родионом выбрать новые стулья и диванчики для Тургенева в рамках бюджета ~150 000 руб.
  - Контекст: заметка «Тургенева замена мебели» — договорённость на четверг по обновлению мебели и улучшению интерьера
  - Приоритет: high
  - Домен: VK Coffee

- [pending] 2026-03-24: Дождаться от Сергея стоимости и договора по архитектурному решению вывески Самокиша после отправки фотографий входной группы
  - Контекст: заметка «Рекламная вывеска на Самокиша» — контакт найден, фото должны быть отправлены в конце дня 24 марта
  - Приоритет: high
  - Домен: Парк

- [pending] 2026-03-24: Построить систему аналитики кухни и бара по накладным, продажам, калькуляциям, прайсам и зарплатным данным
  - Контекст: заметка «Кухня и ее развитие» — нужна система флагов по ценам, хозрасходам и остаткам, возможно с ролью Ларисы как завхоза
  - Приоритет: high
  - Домен: Кухня

- [pending] 2026-03-24: Вытянуть точку Самокиша через внешний сигнал для гостя и благоустройство летки
  - Контекст: заметка «Приоритет» — нужны вывеска, зонты, обновление бара, покраска стен, дерево на лавочках и подсветка летки
  - Приоритет: high
  - Домен: Парк
