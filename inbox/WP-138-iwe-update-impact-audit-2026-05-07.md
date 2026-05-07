# WP-138 — Проверка влияния обновления IWE на Exocortex (2026-05-07)

## Церен / upstream

После `update.sh` рабочий контур должен подтверждаться не по ощущениям, а через канонические проверки runtime и статус-артефактов (`agents`, `health`, `report`, `extractor`).

## Наш идеал

Обновление IWE не ломает рабочий цикл: протоколы открываются, агенты запускаются, status-артефакты свежие, критичных красных блокеров нет.

## Наш факт

- `IWE 0.29.32` применён (`update.sh --yes`), runtime пересобран, platform-space обновлён.
- В первичной проверке после апдейта поймали регрессии:
  - legacy wording в `memory/protocol-open.md` и `memory/checklists.md` (ломал opening-contract gate);
  - `notify`-контракт `strategist/week-review` ломался из-за placeholder-шаблона;
  - из runtime выпали `session-watcher` и `obsidian-fleeting-intake` контуры экстрактора;
  - `extractor-inbox-check` не обновлял status-файл.
- Все найденные регрессии по текущему scope исправлены и перепроверены.

## Разрыв / Gap

Остался только operational warning human-layer: `selection board stale`; это не критичный runtime-блокер.

## Решение по текущему фиксу

1. Выполнен `update.sh --yes` и пересборка runtime.
2. Восстановлены extractor контуры (`session-watcher`, `obsidian-fleeting-intake`) в template + overlay + install.
3. Починен `notify.sh` и health-check для placeholder-шаблонов.
4. Добавлена запись status-артефакта в `extractor.sh inbox-check`.
5. Финальный `health-check`: критичных ошибок нет; `extractor-inbox-check=success`; остаётся 1 предупреждение + 1 stale-норма.
