# ENG.WP.034 — Реализация полного цикла экстрактора (РП 47)

**Дата:** 2026-04-11
**Статус:** in_progress
**Связан с:** ENG.WP.031 (target capability extractor)
**Цель:** замкнуть цикл Telegram → captures → INBOX [KE] → работа с агентом → Pack

---

## Что делаем

Три изменения в экосистеме экстрактора:

1. **routing.md** — добавить PACK-park-development, PACK-cafe-operations, POINT-samokisha
2. **Telegram-уведомление** — при наличии pack_candidates после inbox-check
3. **Промпт apply-ke-report** — интерактивная команда «сохрани в Pack»

---

## Анализ рисков (проведён до начала)

| Компонент | Риск | Обоснование |
|-----------|------|-------------|
| routing.md | ✅ Нет | Конфиг-файл, читается только промптом, не скриптами |
| Telegram notify | ✅ Нет | Аддитивно, использует существующий notify.sh |
| apply-ke-report | ✅ Нет | Новый промпт, не трогает существующие скрипты |
| Второй агент (параллельное окно) | ✅ Нет | Работает в PACK-exocortex-engineering, не в extractor |

**Вывод:** все три изменения безопасны для экосистемы.

---

## Шаг 1: routing.md — добавление Pack'ов VK-offee

**Файл:** `~/Github/FMT-exocortex-template/roles/extractor/config/routing.md`

Добавить строки в таблицу §1:

| Домен | Pack | Префикс | Путь |
|-------|------|---------|------|
| PARK: парк, архитектура, вывеска, дизайн, архитектурный проект, благоустройство, смета, подрядчик, заказ | PACK-park-development | PARK | {{WORKSPACE_DIR}}/VK-offee/PACK-park-development/ |
| CO: кафе-операции, операционный учёт, аналитика, Saby, выручка, оборот, P&L, зал, меню, маркетинг | PACK-cafe-operations | CO | {{WORKSPACE_DIR}}/VK-offee/PACK-cafe-operations/ |
| POINT-samokisha: точка Самокиша, объект, строительство, отделка, конкретная точка | POINT-samokisha | POINT | {{WORKSPACE_DIR}}/VK-offee/POINT-samokisha/ |

**Статус:** ✅ выполнено

---

## Шаг 2: Telegram-уведомление

**Файл:** `~/Github/FMT-exocortex-template/roles/extractor/scripts/inbox-check-notify.sh`

Добавить вызов уведомления в конец inbox-check после формирования отчёта:
- Условие: если в отчёте есть `pack_candidates` (count > 0)
- Сообщение: «📦 Экстрактор: {N} кандидатов в Pack. Проверь INBOX-TASKS.md»
- Использует: `notify.sh` из инфраструктуры экзокортекса

**Статус:** ✅ выполнено

---

## Шаг 3: Промпт apply-ke-report

**Файл:** `~/Github/FMT-exocortex-template/roles/extractor/prompts/apply-ke-report.md`

Промпт для интерактивной команды «сохрани в Pack»:
- Читает последний extraction-report из DS-strategy/inbox/
- Для каждого pack_candidate: подтверждение пользователя → создание файла в Pack
- Формат файла: по шаблону из routing.md §2 + именование из §3
- После каждого сохранения: анонсирует «Capture: {ID} → {Pack}/{type}/»

**Статус:** ✅ выполнено

---

## Проверка успеха

```bash
# routing.md обновлён
grep "PARK\|POINT\|CO" ~/Github/FMT-exocortex-template/roles/extractor/config/routing.md

# уведомление создано
ls ~/Github/FMT-exocortex-template/roles/extractor/scripts/inbox-check-notify.sh

# промпт создан
ls ~/Github/FMT-exocortex-template/roles/extractor/prompts/apply-ke-report.md
```

---

## Связанные артефакты
- [ENG.WP.031](ENG.WP.031-extractor-target-capability.md) — целевая capability экстрактора
- [ENG.WP.032](ENG.WP.032-exocortex-modernization-upstream-audit%20(Аудит%20обновлений%20upstream%20—%20модернизация%20экзокортекса).md) — аудит upstream
