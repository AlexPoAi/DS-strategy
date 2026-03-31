#!/bin/bash
# Сбор токенов из всех активных сессий Claude Code

DATE=$(date +%Y-%m-%d)
CLAUDE_DIR="$HOME/.claude/projects"
OUTPUT_FILE="$HOME/Github/DS-strategy/.status/daily-tokens-$DATE.json"

# Найти все .jsonl файлы за сегодня
JSONL_FILES=$(find "$CLAUDE_DIR" -name "*.jsonl" -type f -newermt "$DATE" 2>/dev/null)

TOTAL_TOKENS=0
SESSION_COUNT=0

echo "{" > "$OUTPUT_FILE"
echo "  \"date\": \"$DATE\"," >> "$OUTPUT_FILE"
echo "  \"sessions\": [" >> "$OUTPUT_FILE"

FIRST=true
for jsonl in $JSONL_FILES; do
    # Подсчитать токены из usage в каждой строке
    TOKENS=$(grep -o '"total_tokens":[0-9]*' "$jsonl" 2>/dev/null | cut -d: -f2 | awk '{s+=$1} END {print s}')

    if [ -n "$TOKENS" ] && [ "$TOKENS" -gt 0 ]; then
        SESSION_COUNT=$((SESSION_COUNT + 1))
        TOTAL_TOKENS=$((TOTAL_TOKENS + TOKENS))

        if [ "$FIRST" = false ]; then
            echo "," >> "$OUTPUT_FILE"
        fi
        FIRST=false

        SESSION_NAME=$(basename $(dirname "$jsonl"))
        echo "    {" >> "$OUTPUT_FILE"
        echo "      \"session\": \"$SESSION_NAME\"," >> "$OUTPUT_FILE"
        echo "      \"tokens\": $TOKENS" >> "$OUTPUT_FILE"
        echo -n "    }" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "  ]," >> "$OUTPUT_FILE"
echo "  \"total_tokens\": $TOTAL_TOKENS," >> "$OUTPUT_FILE"
echo "  \"session_count\": $SESSION_COUNT" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo "$TOTAL_TOKENS"
