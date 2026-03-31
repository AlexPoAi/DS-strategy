---
type: work-product
id: WP-47
title: Редизайн workflow Extractor — captures → inbox → Pack
status: pending
priority: high
created: 2026-03-31
deadline: 2026-04-01
budget: 3h
---

# WP-47: Редизайн workflow Extractor

## Проблема

**Текущий workflow:**
```
Telegram → captures.md → Extractor → файлы в Pack (автоматом)
                                   ↓
                              Нигде не видно как задачи
```

**Что не так:**
1. Extractor создаёт файлы в Pack сразу
2. Мы не видим эти файлы как задачи
3. Нет возможности проверить/доработать перед записью в Pack
4. Файлы лежат, но не попадают в работу

## Целевой workflow

```
Telegram → captures.md → Extractor → extraction-report (pending-review)
                                   ↓
                              inbox/INBOX-TASKS.md (задачи)
                                   ↓
                         Пользователь выполняет задачу
                                   ↓
                              Файл в Pack (финальный)
```

## Сравнение с Extractor Церена

| Аспект | Текущий | Церен | Целевой |
|--------|---------|-------|---------|
| Создание файлов | Автоматом в Pack | Только отчёт | Только отчёт |
| Статус | Нет | pending-review | pending-review |
| Метки captures | [processed] сразу | [analyzed] → [processed] | [analyzed] → [processed] |
| Лимит | Нет | 5 captures | 5 captures |
| Создание задач | ❌ НЕ создаёт | ❌ НЕ создаёт | ✅ Создаёт в inbox |
| Применение | Автоматом | Интерактивно | Интерактивно |

## Ключевое отличие от Церена

**Церен:** extraction-report → человек проверяет → apply → файлы в Pack

**Мы:** extraction-report → **автоматически создать задачи в inbox** → человек выполняет → файлы в Pack

## Задачи

### 1. Изучить Extractor Церена (1h)

**Файлы для анализа:**
- `~/Github/FMT-exocortex-template/roles/extractor/prompts/inbox-check.md` ✅ про��итан
- `~/Github/FMT-exocortex-template/roles/extractor/scripts/` — скрипты запуска
- `~/Github/FMT-exocortex-template/roles/extractor/config/` — конфигурация

**Что выяснить:**
- Как генерируется extraction-report
- Формат отчёта (структура файла)
- Как применяется отчёт (apply workflow)
- Где хранятся отчёты
- Как работает метка [analyzed] vs [processed]

### 2. Спроектировать новый workflow (1h)

**Компоненты:**

1. **Extractor (модифицированный)**
   - Читает captures.md (макс 5 за раз)
   - Генерирует extraction-report в `DS-strategy/inbox/extraction-reports/`
   - Ставит метку [analyzed] в captures.md
   - **НОВОЕ:** Создаёт задачи в `DS-strategy/inbox/INBOX-TASKS.md`

2. **Формат задачи в inbox:**
   ```markdown
   ## [YYYY-MM-DD] Записать знание: {краткое описание}

   **Источник:** capture от {дата}
   **Целевой Pack:** {путь}
   **Целевой файл:** {путь}
   **Тип:** {METHOD/DISTINCTION/FM/WP}
   **Статус:** pending
   **Бюджет:** 15-30 мин

   **Контент для записи:**
   {готовый текст из extraction-report}

   **Действие:** создать файл / добавить секцию
   ```

3. **Применение (интерактивно)**
   - Пользователь открывает задачу из inbox
   - Проверяет контент
   - Применяет → файл создаётся в Pack
   - Ставит метку [processed] в captures.md
   - Удаляет задачу из inbox

### 3. Реализовать (1h)

**Изменения в Extractor:**

1. Модифицировать `roles/extractor/prompts/inbox-check.md`:
   - Добавить шаг "Создать задачи в inbox"
   - Формат задачи (см. выше)

2. Создать helper-функцию в скриптах:
   - `create_inbox_task(capture, extraction_candidate)`
   - Добавляет задачу в INBOX-TASKS.md

3. Обновить launchd/systemd конфиг:
   - Убедиться что Extractor имеет доступ к DS-strategy/inbox/

## Критерии готовности

- [ ] Изучен Extractor Церена (структура, workflow, apply)
- [ ] Спроектирован новый workflow (схема, компоненты, формат задач)
- [ ] Модифицирован inbox-check.md (добавлен шаг создания задач)
- [ ] Создан helper для записи в INBOX-TASKS.md
- [ ] Протестирован на 1-2 captures
- [ ] Задачи появляются в inbox и видны как TODO
- [ ] После применения задачи — файл в Pack, метка [processed]

## Связанные РП

- **WP-46:** Проверить существующие файлы Extractor и создать РП на доработку
- **WP-5:** RAG-бот (интеграция с новым workflow)

## Заметки

**Преимущества нового подхода:**
1. Видимость — все extraction-кандидаты как задачи в inbox
2. Контроль — проверка перед записью в Pack
3. Приоритизация — можно выбрать что записать первым
4. Трекинг — видно сколько задач в очереди

**Риски:**
- Может накопиться очередь задач в inbox
- Нужна дисциплина применения (не откладывать)

**Решение:** Лимит 5 captures за цикл (как у Церена) + регулярный review inbox
