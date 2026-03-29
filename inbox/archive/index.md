# Archive Index

> Хранилище необработанного материала из сессий стратегирования.
> Обновляется автоматически экстрактором при отклонении captures.
> Агент `archive-review` проверяет этот файл раз в месяц.

---

## Как использовать

```bash
# Посмотреть что в архиве
cat ~/Github/DS-strategy/inbox/archive/index.md

# Запустить переобработку архива (проверить появились ли новые Pack'и)
bash ~/Github/FMT-exocortex-template/roles/extractor/scripts/claude-run.sh archive-review
```

---

## Реестр

| Файл | Тип | Дата | Причина | Теги | Статус |
|------|-----|------|---------|------|--------|
| rejected/CO.reject.001-strategic-shift.md | capture | 2026-02-25 | governance — стратегический приоритет, не доменное знание Pack | #governance #стратегия | rejected |
| rejected/CO.reject.002-kitchen-move.md | capture | 2026-02-25 | governance — переезд помещения, не операционный стандарт | #governance #кухня | rejected |
| rejected/CO.reject.003-chef-umami.md | capture | 2026-02-25 | governance — коллаборация, не доменное знание | #governance #партнёры | rejected |
| rejected/CO.reject.004-saby-presto.md | capture | 2026-02-25 | governance — интеграция инструмента, не операционный стандарт | #governance #инструменты | rejected |
| rejected/CO.reject.005-task-saby-support.md | capture | 2026-03-14 | governance — задача (task), не доменное знание Pack | #task #saby #governance | rejected |
| rejected/CO.reject.006-task-architect-replies.md | capture | 2026-03-14 | governance — задача (task), не доменное знание Pack | #task #архитектор #governance | rejected |
| rejected/CO.reject.007-task-coffee-cards.md | capture | 2026-03-14 | governance — задача (task), не доменное знание Pack | #task #карточки #зерно #governance | rejected |
| rejected/CO.reject.008-google-drive-sync.md | capture | 2026-03-18 | task — задача по настройке среды, не доменное знание; правило извлечено отдельно (accept) | #task #gitignore #google-drive | rejected |

---

## Легенда статусов

| Статус | Значение |
|--------|---------|
| `rejected` | Отклонён экстрактором — не входит в scope Pack |
| `deferred` | Отложен — нет подходящего Pack, переобработать позже |
| `pending` | Сырая сессия — не обработана экстрактором |
| `reprocessed` | Переобработан — перемещён в Pack после archive-review |
