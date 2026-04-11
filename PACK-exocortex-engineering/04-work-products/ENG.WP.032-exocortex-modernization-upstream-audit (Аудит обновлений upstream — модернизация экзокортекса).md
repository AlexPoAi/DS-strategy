# ENG.WP.032 — Аудит обновлений upstream: модернизация экзокортекса

**Дата:** 2026-04-11
**Статус:** отчёт собран, решение о merge не принято
**Upstream:** TserenTserenov/FMT-exocortex-template
**Версия Церена:** v0.23.1
**Наша версия:** ~v0.16.2

---

## Масштаб отставания

| Параметр | Значение |
|----------|----------|
| Коммитов позади | 370 |
| Файлов изменено | 142 |
| Новых файлов (у нас нет) | `extensions/`, `params.yaml`, `.claude/rules/`, новые скиллы, `.mcp.json` |
| Риск при merge | 🔴 Высокий — сильные кастомизации наших скриптов |

---

## 🔴 Критичные новинки (у нас нет)

### 1. `extensions/` — система расширений протоколов (v0.18)
Пользователь добавляет `extensions/<protocol>.<hook>.md` — блок вставляется в протокол при исполнении. 12 точек расширения: `day-open.before/after`, `day-close.checks`, `week-close.before/after` и др.
**У нас:** нет совсем.

### 2. `params.yaml` — персистентные параметры протоколов (v0.18)
8 параметров управляют условными шагами: `video_check`, `reflection_enabled`, `telegram_notifications`, `extensions_dir` и др. Протоколы читают params.yaml вместо захардкоженной логики.
**У нас:** нет.

### 3. `.claude/rules/` — distinctions.md + formatting.md (v0.19)
Два постоянных файла правил, которые Claude читает в каждой сессии автоматически. Вместо захламления CLAUDE.md.
**У нас:** нет этой директории.

### 4. `protocol-artifact-validate.sh` — PreToolUse hook (v0.23)
Блокирует `git commit` если DayPlan невалиден: 11 секций, обязательные поля, бюджет в формате. Кодовый enforcement вместо промпт-инструкций.
**У нас:** нет.

### 5. `$IWE_SCRIPTS` lookup-слой (v0.23, WP-219)
Устраняет хардкод путей в скриптах — все скрипты ищут зависимости через lookup, не через `/Users/...`. Это прямо наша проблема с path drift.
**У нас:** хардкод путей, чиним руками при каждом дрейфе.

---

## 🟡 Важные изменения в существующих файлах

### 6. CLAUDE.md сжат до ~90 строк (v0.15, Context Compression)
Было ~280 строк → стало ~90. Детали вынесены в `memory/`, `.claude/rules/`, `.claude/skills/`.
Входной overhead: с ~27K до ~13K токенов (2x сжатие).
**У нас:** CLAUDE.md большой, детали прямо в файле — платим лишними токенами каждую сессию.

### 7. `skill /day-open` — lazy loading шаблонов (v0.15)
DayPlan/WeekPlan шаблоны загружаются только при Day Open, не в каждой сессии. Экономия ~8K токенов в обычных сессиях.
**У нас:** нет skills.

### 8. WeekReport deprecated → итоги в WeekPlan (v0.16)
Отдельный файл WeekReport больше не создаётся. Итоги пишутся в секцию WeekPlan.
**У нас:** создаём отдельный WeekReport (устаревший паттерн).

### 9. `verify SKILL` — chain + adversarial верификация (v0.22)
Два новых типа: `chain` (data flow check) и `adversarial` (scope & bias, pre-mortem). Context isolation через sub-agent.
**У нас:** нет.

### 10. 3-way merge для CLAUDE.md в `update.sh` (v0.18)
При обновлении пользовательские правки в §1-7 сохраняются. Раньше мёрж был ручным.
**У нас:** `update.sh` без 3-way merge, кастомные правки рискуют потеряться.

---

## 🟢 Новые роли и скиллы

| Что | Где | Суть |
|-----|-----|------|
| `/day-close`, `/week-close` алиас-скиллы | `.claude/skills/` | Запускают правильный протокол по короткой команде |
| R27 Навигатор, R28 Диагност | `roles/` каталог | Новые агентные роли |
| QA-agent skeleton | `seed/DS-autonomous-agents` | Заготовка автономного QA-агента |
| `/archgate v3` | `.claude/skills/archgate/` | Профиль вместо числа, 7 доменных характеристик (L2.1 Переносимость данных) |
| `/extend` skill | `.claude/skills/extend/` | Показывает все extension points и params.yaml |
| MCP Gateway | `.mcp.json` | Новый способ подключения MCP через gateway |

---

## Фиксы, которые нас касаются напрямую

| Фикс | Версия | Наш статус |
|------|--------|------------|
| hooks падали на многострочных промптах (jq parse error) | — | возможно воспроизводим |
| canary variables visible outside subshell | — | похожий баг был в нашем scheduler |
| staging isolation в daily-report.sh (git stash перед pull) | — | у нас не реализовано |
| remove redundant `|| exit 1` из strategist.sh | — | чинили вручную (ENG.WP.020) |
| protocol-close: правильный путь к day-close.sh | — | ловили как path drift |

---

## Рекомендации по merge

### Что взять в первую очередь (низкий конфликт)

1. `.claude/rules/distinctions.md` + `formatting.md` — просто скопировать, нет конфликта
2. `extensions/` + `params.yaml` — новые файлы, конфликта нет
3. Новые скиллы: `/day-open`, `/day-close`, `/week-close`, `/verify`, `/extend`
4. Фиксы hooks (jq, canary, staging isolation)

### Что требует ручного merge (высокий конфликт)

1. `roles/strategist/scripts/strategist.sh` — сильно модифицирован нами (Codex provider, fallback, auth)
2. `roles/extractor/` — кастомный outcome-loop (ENG.WP.031)
3. `memory/protocol-open.md` + `protocol-close.md` — расширены нашими правилами
4. `CLAUDE.md` — полностью кастомный, нужен 3-way merge вручную

### Что НЕ брать

- `$IWE_SCRIPTS` lookup-слой — требует рефакторинга всех наших скриптов, отдельный РП
- WeekReport → WeekPlan migration — потребует работы со всей историей DS-strategy

---

## Следующий шаг

Создать РП «Модернизация экзокортекса» с двумя фазами:
- **Фаза 1 (безопасная):** `.claude/rules/`, `extensions/`, `params.yaml`, новые скиллы, фиксы hooks
- **Фаза 2 (с merge):** обновление strategist/extractor через 3-way merge с нашими кастомизациями

**Оценка:** Фаза 1 ~2h, Фаза 2 ~4h.
