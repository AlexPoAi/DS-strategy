---
type: runbook
updated: 2026-04-19
owner: Code Engineer
wp: WP-70
---

# Codex Pro Runbook (VS Code)

## 1) Базовый запуск (рабочий контур)

1. Запускать VS Code из `~/Github`:
   - `/Users/alexander/Github/open-codex-github.sh`
2. Открыть новый агент:
   - hotkey: `Cmd+Shift+N`
   - или `Terminal -> Run Task -> Codex: New Agent (one click)`

## 2) Симптом: "Loading model" и чат не стартует

1. `Cmd+Shift+P` -> `Developer: Reload Window`
2. Проверить, что активен только `openai.chatgpt` (без конфликтных chat-расширений).
3. Открыть новый агент снова (`Cmd+Shift+N`).
4. Если всё ещё висит:
   - полностью перезапустить VS Code;
   - открыть заново workspace `~/Github`;
   - повторить `Cmd+Shift+N`.

## 3) Быстрый техчек (30-60 сек)

1. В боковой панели виден `Codex`.
2. `Cmd+Shift+N` открывает новый чат без ошибок.
3. В новом чате уходит тестовый `ping`.
4. Задачи Exocortex из `tasks.json` запускаются без падения терминала.

## 4) Naming/Storage стандарт для визуалов (Codex Pro)

Папка хранения:
- `DS-strategy/artifacts/visuals/YYYY-MM-DD/`

Именование файла:
- `<contour>-<artifact>-v<NN>.<ext>`
- Пример: `vkcoffee-marketing-card-v01.png`

Сопроводительный `.md` рядом с файлом:
- источник (какой запрос/контур),
- дата,
- где используется (WP/отчёт/Telegram),
- версия и что изменилось.

## 5) Контракт для отчётов

Если в задаче есть визуал, отчёт обязан содержать:
1. ссылку на файл визуала;
2. ссылку на сопроводительный `.md`;
3. краткий итог, где визуал применён.
