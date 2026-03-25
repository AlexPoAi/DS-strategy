---
type: work-package-context
id: WP-29
created: 2026-03-25
status: pending
budget: 3h
depends_on: WP-27, WP-28
---

# РП#29: Artifact-gated atomicity для strategist и scheduler

## Проблема

Система разрешает "успешный" статус без физически завершённого артефакта.
Конкретные проявления, зафиксированные 2026-03-25:

1. **Ротация scheduler-report прошла неатомарно**: архивная копия появилась, old
   current-файл удалён из рабочего дерева, но git-cycle не был завершён truthfully.
   Система при этом выглядела как "всё хорошо".

2. **Week/report drift**: отчёты перешли на `week: W13`, физического `WeekPlan W13`
   в `current/` нет. Стартовый экран показал красный именно из-за этого разрыва.

3. **Корневой паттерн**: операции проходят не до конца, но контур не поднимает
   жёсткий сигнал о незавершённости. Пользователь видит зелёный вечером,
   а утром экосистема сломана.

## Цель

Сделать так, чтобы каждая операция scheduler/strategist либо была завершена
**end-to-end** (артефакт существует + git clean + status truthful), либо
**немедленно сигнализировала о незавершённости** жёстким статусом, не давая
системе выглядеть зелёной.

## Что именно нужно исправить

### 1. Artifact verification перед статусом
Запрещено выставлять success/green без проверки:
- required artifact существует физически (WeekPlan, SchedulerReport и т.п.);
- artifact содержит ожидаемые поля (week, date, type);
- git-state чистый после операции;
- upstream синхронизирован.

### 2. Атомарная ротация scheduler-report
Ротация current → archive должна быть одной атомарной операцией:
- `mv current/SchedulerReport YYYY-MM-DD.md → archive/scheduler-reports/`
- `git add -A` оба пути
- `git commit` одним коммитом
- проверка чистоты ПОСЛЕ коммита

Если любой шаг упал — откат и жёсткий fail, не "почти готово".

### 3. WeekPlan existence check
Перед выставлением `week: WXX` в любом отчёте или статусе — проверить,
что файл `current/WeekPlan W{XX} *.md` существует физически.
Если не существует — статус `red`, не `green`.

### 4. Close-flow atomic verification
`close-task.sh` после backup/sync должен:
- проверить наличие всех expected artifacts;
- проверить `git status --short` на чистоту;
- только при обоих условиях — выдавать truthful success banner.
Сейчас баннер может появляться раньше этой проверки.

### 5. Ecosystem impact оценка перед любым изменением
Перед любым изменением в scheduler/strategist/extractor — обязательный анализ:
- что сломается в соседних контурах;
- какие artifacts будут затронуты;
- как изменение повлияет на truthful completion contract.
Без этого анализа изменение не реализуется.

## Границы пакета

### Входит
- artifact verification layer в scheduler/strategist close-flow;
- атомарная ротация scheduler-reports;
- WeekPlan existence gate;
- ecosystem impact check как обязательный pre-change step.

### Не входит
- полный redesign scheduler/nightly pipeline;
- изменения в extractor, не связанные с completion atomicity;
- новые фичи stартового экрана.

## Критерий завершения WP-29

- Ротация SchedulerReport не оставляет незакоммиченных хвостов;
- `week: WXX` в отчёте возможен только если `WeekPlan WXX *.md` существует физически;
- close-task.sh выдаёт success только после проверки artifacts + git clean;
- ни одна автоматическая операция не может дать зелёный статус
  без конкретного доказательства завершённости артефакта;
- утренний стартовый экран отражает реальность, а не вчерашний snapshot.
