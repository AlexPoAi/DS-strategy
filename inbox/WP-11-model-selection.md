---
type: wp-context
wp_id: W09-11
status: in_progress
created: 2026-03-09
budget: 0.5h
---

# РП#11: Настройка автоматического выбора модели Claude

## Цель

Настроить инфраструктуру для быстрого переключения между моделями Claude (Haiku/Sonnet/Opus) через алиасы и VSCode настройки.

## Артефакт

1. `~/Library/Application Support/Code/User/settings.json` — добавлена настройка `claudeCode.selectedModel: "sonnet"`
2. `~/.zshrc` — добавлены алиасы:
   - `claude-haiku` → `claude --model haiku`
   - `claude-sonnet` → `claude --model sonnet`
   - `claude-opus` → `claude --model opus`
3. `FMT-exocortex-template/memory/protocol-open.md` — обновлён раздел "Рекомендация модели" с инструкциями по переключению

## Контекст

- Модель задаётся при запуске Claude и не может быть изменена внутри сессии
- Протокол требует рекомендации модели в Ритуале согласования
- Пользователь должен иметь быстрый способ перезапуска с нужной моделью

## Чек-лист

- [ ] Добавить `claudeCode.selectedModel` в VSCode settings.json
- [ ] Создать алиасы в ~/.zshrc
- [ ] Обновить protocol-open.md с инструкциями
- [ ] Протестировать переключение модели
- [ ] Коммит + push в FMT-exocortex-template

## Распределение моделей (справка)

| Тип задачи | Модель | Критерии |
|-----------|--------|----------|
| Архитектурные | Opus | Проектирование BC, Context Map, ADR, сложный код, multi-system изменения |
| Средняя сложность | Sonnet | Типовые задачи, одно-файловые правки, написание контента, методы, WP |
| Простые | Haiku | Поиск файлов (Glob/Grep), чтение логов, тривиальные фиксы |
