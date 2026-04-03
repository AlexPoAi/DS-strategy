---
wp: 49
title: Оптимизация кэша Claude Code — устранение бага resume
status: in_progress
created: 2026-04-03
budget: 30min
repo: FMT-exocortex-template + локальная среда
---

# WP-49: Оптимизация кэша Claude Code (Оптимизация кэша)

## Контекст
Статья с Reddit: два бага в Claude Code ломают prompt cache, увеличивая расходы в 10-20x.
- Баг 1 (standalone binary): НЕ касается нас (у нас npm)
- Баг 2 (--resume с v2.1.69): КАСАЕТСЯ — каждый resume = полный cache miss (~$0.15)

## Анализ влияния на экосистему
- Агенты (extractor, strategist, scheduler): НЕ используют --resume → не затронуты
- Ручные сессии: ЗАТРОНУТЫ — каждый resume ломает кэш
- Downgrade до 2.1.68: потеря 23 версий функций — РИСК

## План
1. Оценить: downgrade vs workaround
2. Если downgrade — проверить что агенты работают на 2.1.68
3. Альтернатива: просто не использовать --resume (новая сессия каждый раз)
