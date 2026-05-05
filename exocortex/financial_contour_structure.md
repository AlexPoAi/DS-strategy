---
name: Структура финансового контура DS-finance-private
description: Где находится финансовый контур, как он устроен, какие слои и агенты
type: reference
valid_from: 2026-05-03
originSessionId: fe20340e-d040-4df3-88e0-89831654d8e2
---
# Финансовый контур (DS-finance-private)

**Локация:** `/Users/alexander/Github/DS-finance-private/`

**Режим хранения:** ТОЛЬКО локально. Не пушить в GitHub реальные финансовые данные.

## Структура контура

### 1. Business-finance (рабочий контур)

**Путь:** `/Users/alexander/Github/DS-finance-private/business-finance/`

#### Слои:
- **data-layer/** — исходные данные (incomes, expenses, cash, assets)
- **transformation-layer/** — расчеты метрик (cashflow, profit, unit_profit, dynamics)
- **decision-layer/** — решения (spend, investment, new_unit, cost_optimization)
- **views/** — Finance View по точкам (где сохраняются отчеты VK Coffee за периоды)

### 2. Агенты DS-finance

**Файл карты:** `DS-finance-private/agents/agents-map-v2.0.md`

#### Основные агенты:
1. **vk_finance_analyst** — ingestion агент
   - Читает отчеты из папки отчетов бота (Drive)
   - Нормализует данные (выручка, маржа, продажи по точкам)
   - Строит Finance View
   - Сохраняет в `business-finance/views/finance-view-YYYY-MM-DD.md`
   - **Не принимает решения**, только data layer

2. **financial_consultant** — координатор
   - Читает Finance View от vk_finance_analyst
   - Анализирует тренды, риски
   - Выпускает verdict: freeze/keep/invest по точкам
   - Координирует с другими агентами

3. **warehouse-demand-analyst** — аналитик склада (ОТДЕЛЬНЫЙ процесс)
   - Читает ТЕ ЖЕ отчеты из папки отчетов бота
   - Анализирует остатки, продажи, ABC, маржу
   - Дает рекомендации по закупке
   - Обновляет PACK-warehouse артефактами

## Данные VK Coffee

**Папка отчетов бота в Drive:** `https://drive.google.com/drive/folders/167ojs-dghvBEO-tmQDUshvP9wAKqFIse`

**Папка продаж в Drive:** `https://drive.google.com/drive/folders/1g2Pq-cYVT2cSkd9DwBCV-EJBHYDvzHw9` (для исторических данных)

## Процесс обновления при инвентаризации

Когда пришли данные за 2 недели:

1. **warehouse-demand-analyst обрабатывает:**
   - Остатки → что заканчивается / в избытке
   - Продажи → топ SKU, выручка
   - ABC-анализ → приоритеты закупки
   - Маржа → риски, аномалии
   - **Выход:** рекомендации по закупке → PACK-warehouse карточки

2. **vk_finance_analyst обрабатывает ТЕ ЖЕ данные:**
   - Считает выручку по точкам
   - Считает среднюю выручку в день
   - Считает маржу %
   - Строит динамику vs предыдущий период
   - Выявляет аномалии в продажах
   - **Выход:** Finance View → `business-finance/views/finance-view-YYYY-MM-DD.md`

3. **financial_consultant читает Finance View:**
   - Анализирует тренды точек
   - Выпускает verdict: freeze/keep/invest по каждой точке
   - Передает в стратегический слой

## Стандарт именования в DS-finance

Формат: `english_slug (русское пояснение)`

Примеры:
- `samokisha (Самокиша)`
- `turgeneva (Тургенева)`
- `lugovaya (Луговая)`
- `deposit_account (депозитный счёт)`

Запрещено писать голые английские ключи.
