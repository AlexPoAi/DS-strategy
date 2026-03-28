#!/bin/bash
# fpf-consult.sh v2 — FPF Консультант с памятью треда
#
# Использование:
#   fpf-consult.sh "вопрос"          — одиночный запрос (помнит контекст)
#   fpf-consult.sh -i                — интерактивный режим (диалог без перезапуска)
#   fpf-consult.sh --reset           — сбросить тред (начать новый разговор)
#   fpf-consult.sh --reset "вопрос" — сбросить и сразу задать вопрос
#   fpf-consult.sh --status          — показать ID текущего треда

THREAD_FILE="$HOME/.fpf-thread-id"
ASSISTANT_ID="asst_Paf2mQ4Qu4PI3eUG0bQI68vY"

# Загрузка ключа
if [ -f ~/Github/VK-offee-rag/.env ]; then
  set -a; source ~/Github/VK-offee-rag/.env; set +a
fi

if [ -z "$OPENAI_API_KEY" ]; then
  echo "❌ OPENAI_API_KEY не найден в ~/Github/VK-offee-rag/.env"
  exit 1
fi

# Обработка флагов
RESET=false
INTERACTIVE=false
QUESTION=""

for arg in "$@"; do
  case "$arg" in
    --reset) RESET=true ;;
    -i)      INTERACTIVE=true ;;
    --status)
      if [ -f "$THREAD_FILE" ]; then
        echo "💬 Текущий тред: $(cat $THREAD_FILE)"
      else
        echo "🆕 Тред не создан — будет создан при первом вопросе"
      fi
      exit 0
      ;;
    *) QUESTION="$QUESTION $arg" ;;
  esac
done
QUESTION="${QUESTION# }"

# Сброс треда
if [ "$RESET" = true ]; then
  rm -f "$THREAD_FILE"
  echo "🔄 Тред сброшен — следующий вопрос создаст новый"
  [ -z "$QUESTION" ] && exit 0
fi

# Собираем контекст домена для первого сообщения
build_domain_context() {
  local ctx=""

  # PACK-SCHEMA если есть
  local schema_file
  schema_file=$(find ~/Github/VK-offee -name "*domain-schema*" -o -name "*PACK-SCHEMA*" 2>/dev/null | head -1)
  if [ -n "$schema_file" ] && [ -f "$schema_file" ]; then
    ctx="$ctx\n\n=== PACK-SCHEMA (домен VK-offee) ===\n$(cat "$schema_file" | head -80)"
  fi

  # DOMAIN-CONTRACTS-ALL если есть
  local contracts_file
  contracts_file=$(find ~/Github/VK-offee -name "*DOMAIN-CONTRACTS-ALL*" 2>/dev/null | head -1)
  if [ -n "$contracts_file" ] && [ -f "$contracts_file" ]; then
    ctx="$ctx\n\n=== DOMAIN-CONTRACTS-ALL (краткий реестр) ===\n$(cat "$contracts_file" | head -100)"
  fi

  echo -e "$ctx"
}

# Основная функция запроса
ask_question() {
  local question="$1"
  local is_new_thread="$2"

  python3 - "$question" "$THREAD_FILE" "$ASSISTANT_ID" "$is_new_thread" << 'PYTHON'
import sys, json, urllib.request, os, time, re

question      = sys.argv[1]
thread_file   = sys.argv[2]
assistant_id  = sys.argv[3]
is_new_thread = sys.argv[4] == "true"
api_key       = os.environ["OPENAI_API_KEY"]

headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}",
    "OpenAI-Beta": "assistants=v2"
}

def api(method, path, data=None):
    url = f"https://api.openai.com/v1{path}"
    body = json.dumps(data).encode() if data else None
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as r:
            return json.loads(r.read())
    except urllib.error.HTTPError as e:
        print(f"❌ HTTP {e.code}: {e.read().decode()}")
        sys.exit(1)

# Загрузить или создать тред
if os.path.exists(thread_file) and not is_new_thread:
    with open(thread_file) as f:
        thread_id = f.read().strip()
    print(f"💬 Продолжаем диалог...", flush=True)
else:
    thread = api("POST", "/threads")
    thread_id = thread["id"]
    with open(thread_file, "w") as f:
        f.write(thread_id)
    print(f"🆕 Новый тред создан", flush=True)

# Отправить вопрос
api("POST", f"/threads/{thread_id}/messages", {
    "role": "user",
    "content": question
})

# Запустить Run
run = api("POST", f"/threads/{thread_id}/runs", {
    "assistant_id": assistant_id
})
run_id = run["id"]

# Ждём завершения
print("⏳ FPF Консультант думает...", flush=True)
for _ in range(90):
    time.sleep(2)
    run = api("GET", f"/threads/{thread_id}/runs/{run_id}")
    status = run["status"]
    if status == "completed":
        break
    elif status in ("failed", "cancelled", "expired"):
        err = run.get("last_error", {})
        print(f"❌ Ошибка run: {status} — {err}")
        sys.exit(1)

# Получить ответ
messages = api("GET", f"/threads/{thread_id}/messages")
answer = messages["data"][0]["content"][0]["text"]["value"]
answer = re.sub(r'【\d+:\d+†[^\】]*】', '', answer)

print("\n" + "─" * 60)
print(answer)
print("─" * 60)
PYTHON
}

# Определяем — новый тред или нет
IS_NEW_THREAD="false"
if [ ! -f "$THREAD_FILE" ]; then
  IS_NEW_THREAD="true"
fi

# Если новый тред — подгружаем контекст домена в первый вопрос
inject_context_if_new() {
  local question="$1"
  if [ "$IS_NEW_THREAD" = "true" ]; then
    local ctx
    ctx=$(build_domain_context)
    if [ -n "$ctx" ]; then
      echo "📎 Загружаю контекст домена VK-offee в новый тред..."
      question="Контекст проекта (прочитай перед ответом):${ctx}

---

Мой вопрос: ${question}"
    fi
  fi
  echo "$question"
}

# Интерактивный режим
if [ "$INTERACTIVE" = true ]; then
  echo "🤖 FPF Консультант — интерактивный режим"
  echo "   Введи вопрос и нажми Enter. Для выхода: 'exit' или Ctrl+C"
  echo "   Тред сохраняется между сессиями."
  echo "─────────────────────────────────────────────────────────"

  while true; do
    printf "\n💬 Ты: "
    read -r input
    [ -z "$input" ] && continue
    [ "$input" = "exit" ] || [ "$input" = "выход" ] && echo "👋 До свидания" && break

    enriched=$(inject_context_if_new "$input")
    IS_NEW_THREAD="false"  # После первого — уже не новый
    ask_question "$enriched" "false"
  done

# Одиночный вопрос
elif [ -n "$QUESTION" ]; then
  enriched=$(inject_context_if_new "$QUESTION")
  ask_question "$enriched" "$IS_NEW_THREAD"

else
  echo "Использование:"
  echo "  fpf-consult.sh \"вопрос\"     — спросить (помнит контекст)"
  echo "  fpf-consult.sh -i            — интерактивный режим"
  echo "  fpf-consult.sh --reset       — сбросить тред"
  echo "  fpf-consult.sh --status      — показать текущий тред"
  exit 1
fi
