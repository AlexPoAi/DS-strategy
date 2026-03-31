#!/usr/bin/env python3
# Расчёт стоимости токенов по тарифам Anthropic

import json
import sys
from pathlib import Path

# Тарифы Anthropic (на март 2026)
PRICING = {
    "claude-sonnet-4-6": {
        "input": 3.00 / 1_000_000,      # $3 per MTok
        "output": 15.00 / 1_000_000,    # $15 per MTok
        "cache_write": 3.75 / 1_000_000,
        "cache_read": 0.30 / 1_000_000
    },
    "claude-opus-4-6": {
        "input": 15.00 / 1_000_000,
        "output": 75.00 / 1_000_000,
        "cache_write": 18.75 / 1_000_000,
        "cache_read": 1.50 / 1_000_000
    },
    "claude-haiku-4-5": {
        "input": 0.80 / 1_000_000,
        "output": 4.00 / 1_000_000,
        "cache_write": 1.00 / 1_000_000,
        "cache_read": 0.08 / 1_000_000
    }
}

def calculate_cost(tokens_file):
    """Рассчитать стоимость из JSON файла с токенами"""
    with open(tokens_file) as f:
        data = json.load(f)

    total_tokens = data.get("total_tokens", 0)

    # Упрощённый расчёт: считаем всё как Sonnet input
    # (точный расчёт требует разбивки по типам)
    cost = total_tokens * PRICING["claude-sonnet-4-6"]["input"]

    return {
        "total_tokens": total_tokens,
        "cost_usd": round(cost, 4),
        "sessions": data.get("session_count", 0)
    }

if __name__ == "__main__":
    tokens_file = sys.argv[1] if len(sys.argv) > 1 else None

    if not tokens_file or not Path(tokens_file).exists():
        print("Usage: calculate-cost.py <tokens.json>")
        sys.exit(1)

    result = calculate_cost(tokens_file)
    print(json.dumps(result, indent=2))
