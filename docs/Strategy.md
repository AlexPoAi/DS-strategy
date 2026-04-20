---
type: doc
status: active
created: 2026-02-22
updated: 2026-04-20
---

# Стратегия

## Текущий фокус

- ПАРК: снять регуляторную и инженерную неопределённость по трубе и следующему шагу по РНС.
- VK Coffee: довести управленческий контур отчётности и перейти от разрозненных автоматизаций к управляемому портфелю.
- Governance: вернуть стратегическому слою truthful source-of-truth для backlog, recovery и документных реестров.

## Текущие фазы (MAPSTRATEGIC)

> На `2026-04-20` файлов `MAPSTRATEGIC.md` в `/Users/alexander/Github/*` не найдено. Фазовый слой не материализован и требует восстановления как отдельный governance-gap.

| Контур | Текущая фаза | Источник | Статус |
|---|---|---|---|
| Парк | Верификация внешнего блокера перед следующим проектным шагом | `WP-73` | active |
| VK Coffee | Управленческий продуктовый slice + shortlist автоматизаций | `WP-59`, `WP-77` | active |
| Склад | Production hardening и переход к бизнес-аналитике | `WP-63`, `WP-80`, `WP-81` | partial |
| Экзокортекс | Stabilize bootstrap и cleanup governance drift | `WP-56`, `WP-74`, `WP-76`, `WP-89` | active |

## Приоритеты месяца

| # | Приоритет | Бюджет | Статус |
|---|-----------|--------|--------|
| 1 | `WP-73` — Парк: официальный статус трубы и decision tree | 1.5-2h | active |
| 2 | `WP-59` — Telegram-бот: роль управляющего и отчёты | 1.5-2h | carry-over |
| 3 | `WP-74` — Карта backlog по доменам | 1.5-3h | active |
| 4 | `WP-56` — Truthful rebase backlog и recovery | 1-1.5h | partial |
| 5 | `WP-63` — Warehouse governance hardening до честного verdict | 1-2h | partial |
| 6 | `WP-89` — Master document registry | 2-4h | pending |

## Ключевые решения

- Для weekly-слоя действует правило `1 домен = 1 главный активный РП`.
- Recovery-элементы без ясного scope не затаскиваются в неделю автоматически; сначала получают явный verdict `WeekPlan / INBOX backlog / keep in recovery`.
- Пустые или шаблонные governance-артефакты (`Strategy.md`, `WORKPLAN.md`, отсутствующие `MAPSTRATEGIC.md`) считаются не «нормой по умолчанию», а отдельным управленческим разрывом.

## РП → Результаты

| РП | Результат |
|----|-----------|
| 56 | Truthful картина backlog и recovery вместо шумного списка |
| 59 | Управляющий получает быстрый доступ к day/week report из Telegram |
| 63 | Складской контур получает честный production verdict |
| 73 | По трубе появляется официальный next step и decision tree |
| 74 | Backlog виден как портфель доменов, а не как плоский хвост |
| 89 | Появляется master-слой документных реестров |
