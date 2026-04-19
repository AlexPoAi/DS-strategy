---
id: WP-92
title: "Day-close auth-independent standardization"
status: done
priority: high
owner: "Environment Engineer"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

Повторяющийся блокер `Not logged in · Please run /login` ломал прохождение day-close в части агентных запусков.
Нужно было не косметически обходить, а выровнять стандартный протокол закрытия дня так, чтобы он проходил независимо от cloud-auth состояния Claude route.

# Цель

1. Дать стабильный auth-independent entrypoint для day-close.
2. Сохранить совместимость со стандартным протоколом day-close.
3. Зафиксировать truthful anti-loop контракт в зеркалах экзокортекса.

# Что сделано

1. Добавлен auth-independent вход:
   - `FMT-exocortex-template/scripts/day-close-safe.sh`
2. Выровнен `day-close.sh` под актуальный workspace-контур `~/Github`:
   - auto-resolve `WORKSPACE_DIR` через `resolve-workspace.sh`;
   - auto-resolve `MEMORY_SRC` через реальные `.claude/projects/.../memory` пути;
   - fallback-резолв путей для `selective-reindex.sh` и `linear-sync.sh`;
   - более понятная диагностика отсутствующих внешних скриптов.
3. Обновлён protocol-close контракт в `DS-strategy/exocortex` зеркалах:
   - anti-loop guard на `Not logged in`;
   - явный канонический manual route без обязательности slash-route.

# Truthful результат

- Day-close механика проходит стабильно с `backup=ok`.
- `reindex` и `linear` остаются `skip`, если внешняя инфраструктура не доукомплектована в текущем контуре (ожидаемое поведение).
- Блокер cloud-auth больше не является стоп-фактором для прохождения ритуала закрытия дня.

# Артефакты

- `FMT-exocortex-template/scripts/day-close-safe.sh`
- `FMT-exocortex-template/scripts/day-close.sh`
- `DS-strategy/exocortex/protocol-close.md`
- `DS-strategy/exocortex/memory/protocol-close.md`

# Следующий шаг

Доукомплектовать внешние контуры для полного `ok/ok/ok`:
- `knowledge-mcp selective-reindex`;
- `linear-sync` путь через `params.yaml` или локальный бинарь.
