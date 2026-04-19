---
id: WP-81
title: "Warehouse SOTA benchmark and advanced automation methods"
status: active
priority: high
owner: "Warehouse Demand Analyst + Strategist + Code Engineer"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

Нужно усилить складской контур не только базовой автоматизацией, но и лучшими практиками (SOTA/industry methods), чтобы решения по остаткам и закупке были более точными и прибыльными.

# Цель

Сравнить текущий складской контур VK Coffee с лучшими рабочими подходами других бизнесов и внедрить полезные методы в наш pipeline.

# Scope

1. Бенчмарк 5-10 практик управления остатками в HoReCa/retail.
2. Выбор методов, применимых к VK Coffee.
3. План внедрения в текущий автоконтур.

# Базовый shortlist методов для оценки

1. ABC/XYZ матрица (ценность vs стабильность спроса).
2. Min-Max policy + Safety Stock.
3. Reorder Point (ROP) с учётом lead time поставщиков.
4. FEFO/FIFO для скоропортящихся позиций.
5. Dead-stock/slow-movers aging report.
6. Service-level target (уровень доступности топ-SKU).
7. Exception-based alerts (только отклонения, без шума).

# Acceptance

1. Есть документ сравнения `as-is vs target` по каждому методу.
2. Выбраны минимум 3 метода с высоким ROI для внедрения.
3. Методы привязаны к конкретным шагам pipeline и KPI.

# Next slice (today)

1. Сформировать первую сравнительную таблицу методов.
2. Выбрать top-3 для Wave 1 (интеграция в складской pipeline).
3. Зафиксировать владельцев и сроки внедрения.
