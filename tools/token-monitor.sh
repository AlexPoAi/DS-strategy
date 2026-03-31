#!/bin/bash
# Мониторинг токенов Claude Code за день

DATE=$(date +%Y-%m-%d)
LOG_FILE="$HOME/Github/DS-strategy/.status/token-usage-$DATE.log"

echo "=== Token Usage Report: $DATE ===" > "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Получить статистику из Anthropic API (через curl)
# Примечание: требует ANTHROPIC_API_KEY
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "📊 Запрос статистики из Anthropic API..." >> "$LOG_FILE"
    # API endpoint для usage stats (если доступен)
    # curl -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/usage >> "$LOG_FILE" 2>&1
    echo "⚠️  API endpoint для usage пока не реализован" >> "$LOG_FILE"
fi

echo "" >> "$LOG_FILE"
echo "📁 Локальный кэш статистики:" >> "$LOG_FILE"
if [ -f "$HOME/.claude/stats-cache.json" ]; then
    jq -r '.dailyModelTokens[-5:] | .[] | "\(.date): \(.tokensByModel | to_entries | map("\(.key): \(.value)") | join(", "))"' \
        "$HOME/.claude/stats-cache.json" >> "$LOG_FILE" 2>&1
else
    echo "stats-cache.json не найден" >> "$LOG_FILE"
fi

echo "" >> "$LOG_FILE"
echo "✅ Отчёт сохранён: $LOG_FILE"
cat "$LOG_FILE"
