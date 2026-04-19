---
id: WP-80
title: "Knowledge librarian agent creation"
status: done
priority: high
owner: "Strategist + Supreme HR"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После `WP-79` стало ясно, что capability `Notes Registry` нельзя встраивать целиком ни в `Extractor`, ни в `Strategist`.

Нужен отдельный внутренний DS-native агент, который будет:
- вести реестр заметок;
- строить доменную карту;
- держать pack coverage;
- передавать чистый handoff в стратегический слой.

Русское описание агента согласовано с пользователем: `Библиотекарь`.

# Цель

Создать в агентстве нового внутреннего агента `Knowledge Registry Curator` и встроить его в реестр агентства как штатную роль.

# Scope

1. Описать контракт агента.
2. Зафиксировать его место в контуре:
   - `Extractor -> Knowledge Registry Curator -> Strategist`
3. Добавить карточку агента в `agency/agents/`.
4. Добавить запись в `agency/REGISTRY.md`.
5. Зафиксировать следующий отдельный шаг: skill для Библиотекаря.

# Acceptance

1. В агентстве есть карточка нового агента.
2. В `REGISTRY.md` агент включён в основной реестр и матрицу выбора.
3. Ясно прописана граница между `Extractor`, `Библиотекарем` и `Strategist`.
4. Следующий bounded slice на skill определён явно.

# Результат

Создан новый внутренний агент `Knowledge Registry Curator`.

Зафиксировано:
- его место в контуре `Extractor -> Knowledge Registry Curator -> Strategist`;
- его контракт как держателя `Notes Registry`, `Domain Map` и `pack coverage`;
- его отличие от `Extractor` и `Strategist`;
- его внешний benchmark: `ZK Steward`.

# Следующий шаг

1. Закрыть создание агента.
2. Открыть отдельный slice на `skill` для `Knowledge Registry Curator`.
