---
type: work-product
pack: PACK-exocortex-engineering
id: ENG.WP.044
title: Единый источник ежедневного Telegram-отчёта экзокортекса
created: 2026-04-22
status: active
---

# ENG.WP.044 — Единый источник ежедневного Telegram-отчёта экзокортекса

## Инцидент

В один и тот же Telegram-чат пришли два ежедневных отчёта из двух runtime-контуров:
- local `launchctl/codex`
- VPS `systemd/claude`

Они противоречат друг другу по provider, health-state и количеству активных РП/агентов.

## Root cause hypothesis

Не закреплён канонический sender `daily-telegram-report`.
В результате локальный и VPS scheduler оба считают себя легитимным источником daily status.

## Сначала сделать

1. Карта current-state:
- local sender
- VPS sender
- chat routing
- runtime policy

2. Сверка с эталоном:
- один sender vs split-channels

3. Risk assessment:
- product runtime на VPS
- notify transport
- local daily-report

## Не делать до решения

- Не отключать сразу VPS scheduler целиком.
- Не трогать product-bot/runtime на VPS.
- Не менять transport secrets без доказанного конфликта.

## Target

Один канонический sender daily-status в основной Telegram-чат.

## Решение

- `daily-report` и `daily-telegram-report` остаются `local-primary`.
- VPS не должен быть вторым truth-producing sender для экзокортекса.
- На VPS фикс применяется через `SCHEDULER-RUNTIME.env`:
  - `EXOCORTEX_RUNTIME_TARGET=vps`
  - `EXOCORTEX_DISABLE_LOCAL_DISPATCH=1`

Это даёт безопасный режим `standby`:
- unit и cloud host сохраняются;
- product runtimes на VPS не затрагиваются;
- duplicate daily-status в основной чат больше не должен возникать.
