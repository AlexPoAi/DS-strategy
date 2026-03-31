#!/bin/bash
# Отправка отчёта о токенах в Telegram

DATE=$(date +%Y-%m-%d)
TOKENS_JSON="$HOME/Github/DS-strategy/.status/daily-tokens-$DATE.json"
COST_SCRIPT="$HOME/Github/DS-strategy/tools/calculate-cost.py"
TELEGRAM_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"

# Собрать токены
bash "$HOME/Github/DS-strategy/tools/collect-tokens.sh" > /dev/null

# Рассчитать стоимость
if [ -f "$TOKENS_JSON" ]; then
    COST_DATA=$(python3 "$COST_SCRIPT" "$TOKENS_JSON")
    TOTAL_TOKENS=$(echo "$COST_DATA" | jq -r '.total_tokens')
    COST_USD=$(echo "$COST_DATA" | jq -r '.cost_usd')
    SESSIONS=$(echo "$COST_DATA" | jq -r '.sessions')
else
    TOTAL_TOKENS=0
    COST_USD=0
    SESSIONS=0
fi

# Форматировать сообщение
MESSAGE="📊 *Отчёт по токенам за $DATE*

🔢 Всего токенов: $(printf "%'d" $TOTAL_TOKENS)
💰 Стоимость: \$$COST_USD
📱 Сессий: $SESSIONS

_Автоматический отчёт экзокортекса_"

# Отправить в Telegram
if [ -n "$TELEGRAM_TOKEN" ] && [ -n "$CHAT_ID" ]; then
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE" \
        -d parse_mode="Markdown" > /dev/null
    echo "✅ Отчёт отправлен в Telegram"
else
    echo "⚠️  TELEGRAM_BOT_TOKEN или TELEGRAM_CHAT_ID не установлены"
    echo "$MESSAGE"
fi
