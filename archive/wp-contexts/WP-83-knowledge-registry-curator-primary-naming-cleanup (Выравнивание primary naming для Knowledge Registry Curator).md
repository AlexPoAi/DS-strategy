---
id: WP-83
title: "Knowledge Registry Curator primary naming cleanup"
status: done
priority: medium
owner: "Strategist"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После создания `WP-80` стало видно, что в контуре ролей есть языковая неровность:
- `Extractor`
- `Библиотекарь`
- `Strategist`

Для устойчивого агентного контура основной нейминг ролей лучше держать на английском, а русское имя оставить как вторичное описание.

# Цель

Сделать `Knowledge Registry Curator` основным именем агента во всех ключевых артефактах стратегического и агентского контуров.

# Scope

1. Обновить формулировки в `DS-strategy`.
2. Обновить формулировки в `DS-agent-workspace`.
3. Сохранить русское описание `Библиотекарь` как вторичное, а не основное имя роли.

# Acceptance

1. В ключевых артефактах контур записан как `Extractor -> Knowledge Registry Curator -> Strategist`.
2. В `INBOX` и `SESSION-CONTEXT` основное имя агента — английское.
3. В агентском реестре и карточке агента русское имя осталось только как описание.

# Результат

Primary naming выровнен:
- основное имя роли: `Knowledge Registry Curator`
- русское описание: `Библиотекарь`

# Следующий шаг

1. Открыть отдельный bounded slice на `skill` для `Knowledge Registry Curator`.
2. Отразить capability и его skill в инженерном контуре.
