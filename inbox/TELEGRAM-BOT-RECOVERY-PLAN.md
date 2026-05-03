---
type: engineering-recovery-plan
rp_id: TBD
title: Восстановление Telegram бота VK-offee — полный план
date: 2026-05-01
status: active
priority: critical
---

# 🤖 TELEGRAM БОТ VK-OFFEE — ПЛАН ВОССТАНОВЛЕНИЯ И РАЗВИТИЯ

## 🔴 ТЕКУЩИЕ ПРОБЛЕМЫ

### 1. **Кнопки не работают**
- **Симптом:** Меню кнопки показываются, но клики на них не дают ответа
- **Причина:** Обработчик кнопок не присоединён к message handler 
- **Файл:** `/VK-offee/telegram-bot/bot.py` строки 118-136 (кнопки определены, но обработка отсутствует)
- **Решение:** Добавить ButtonHandler или доделать message handler с фильтром по тексту кнопок

### 2. **AI слой (RAG) не работает / нестабилен**
- **Симптом:** `/status` показывает 🔴 "RAG API недоступен" или зависает
- **Причина:** 
  - RAG API жёстко заточен под `127.0.0.1:8000` (localhost only)
  - Индексация может быть устаревшей
  - RAG process может упасть или зависнуть
- **Файлы:**
  - `/VK-offee-rag/src/api.py` (API_HOST = "127.0.0.1")
  - `/VK-offee/telegram-bot/rag_client.py` (RAG_API_URL hardcoded)
- **Решение:** Перевести RAG на cloud-ready config, добавить health checks, автоперезапуск

### 3. **Бот работает только когда ноутбук включен**
- **Симптом:** Бот не отвечает ночью или когда ноутбук выключен
- **Причина:** Бот запущен локально в процессе, без systemd сервиса
- **Решение:** Настроить systemd сервис для VPS/always-on режима

---

## ✅ ЧТО УЖЕ ЕСТЬ (ИСПОЛЬЗОВАТЬ КАК БАЗУ)

| Компонент | Статус | Путь | Примечание |
|-----------|--------|------|-----------|
| **Telegram bot code** | ✅ Рабочий | `/VK-offee/telegram-bot/bot.py` | Основная логика, нужны фиксы |
| **RAG API** | ⚠️ Есть, но localhost | `/VK-offee-rag/src/api.py` | Нужна config для cloud |
| **RAG client** | ✅ Готов к `RAG_API_URL` | `/VK-offee/telegram-bot/rag_client.py` | Уже поддерживает env переменную |
| **Health endpoint** | ✅ Есть | `/health` в RAG API | Для проверок работоспособности |
| **systemd skeleton** | ✅ Есть | `/VK-offee/telegram-bot/deploy.sh` | Линии 30-50, нужны обновления |
| **Кнопки UI** | ⚠️ Определены | `/VK-offee/telegram-bot/bot.py:118-136 | Без обработчика |

---

## 🎯 ПЛАН ВОССТАНОВЛЕНИЯ (4 ЭТАПА)

### **ЭТАП 1️⃣: ДИАГНОСТИКА И БЫСТРЫЕ ФИКСЫ (1-2 часа)**

#### 1.1 Запустить бот локально и проверить логи
```bash
cd /Users/alexander/Github/VK-offee/telegram-bot
cat .env  # проверить TELEGRAM_BOT_TOKEN
python3 bot.py  # запустить в debug режиме
```

**Ожидаемый результат:** Логи покажут где падает

#### 1.2 Запустить RAG API локально
```bash
cd /Users/alexander/Github/VK-offee-rag
python3 src/api.py  # должен быть доступен на http://127.0.0.1:8000
curl http://127.0.0.1:8000/health  # проверить здоровье
```

**Ожидаемый результат:** Health endpoint должен вернуть JSON с числом документов

#### 1.3 Тестовый запрос к RAG через Telegram
```
Отправить в бот любой вопрос → проверить ответ
Если пусто → RAG не подключен
```

#### 1.4 Тест кнопок
```
Нажать на кнопку "☕ Напитки" → если нет ответа → обработчик отсутствует
```

---

### **ЭТАП 2️⃣: ФИКСЫ КОДА (2-3 часа)**

#### 2.1 Добавить обработчик кнопок в bot.py

**Найти строку ~457 (функция `start`)** и добавить после неё обработчик:

```python
async def handle_button_press(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик нажатия кнопок меню"""
    message_text = update.message.text.strip()
    
    # Проверить, это ли кнопка из меню
    if message_text in BUTTON_QUERIES:
        query = BUTTON_QUERIES[message_text]
        await rag_reply(update, query)
    # Если сообщение не кнопка, попробовать как вопрос к RAG
    elif message_text and len(message_text) > 2:
        await rag_reply(update, message_text)
    # Иначе показать помощь
    else:
        await help_command(update, context)
```

**Затем найти строку ~850-900 (где добавляются handlers) и добавить:**

```python
# Обработчик сообщений (текст кнопок + вопросы)
app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_button_press))
```

**После этого:** Кнопки будут работать + обычные вопросы тоже

---

#### 2.2 Стабилизировать RAG

**A. Сделать RAG доступным на разных IP (не только localhost)**

В `/VK-offee-rag/src/api.py` найти строку с `API_HOST`:
```python
# Старое:
API_HOST = "127.0.0.1"

# Новое:
API_HOST = os.getenv("RAG_API_HOST", "127.0.0.1")
```

**B. Добавить лучший health check:**

```python
@app.get("/health")
async def health():
    return {
        "status": "ok",
        "documents_indexed": len(vectordb.get()),  # реальное количество
        "collections": list(vectordb.list_collections()),
        "timestamp": datetime.now().isoformat()
    }
```

**C. Добавить автоперезапуск в systemd** (позже в ЭТАПЕ 3)

---

#### 2.3 Добавить режиме переключения (cloud vs local)

В bot.py найти строку ~58:
```python
BOT_RUNTIME_MODE = os.getenv("BOT_RUNTIME_MODE", "local-debug")
```

Это уже есть! Но используется неправильно.

Обновить:
```python
# Если cloud mode, запретить дублирование бота
if BOT_RUNTIME_MODE == "cloud":
    # Только один процесс может быть активен
    LOCK_FILE = Path("/tmp/vk-telegram-bot.lock")
    if LOCK_FILE.exists():
        logger.error("Другой бот процесс уже активен!")
        sys.exit(1)
    LOCK_FILE.touch()
```

---

### **ЭТАП 3️⃣: ДОБАВИТЬ НОВЫЕ КНОПКИ И ФУНКЦИОНАЛ (3-4 часа)**

#### 3.1 Расширить меню кнопок

**Найти MAIN_KEYBOARD ~118 и заменить на:**

```python
MAIN_KEYBOARD = ReplyKeyboardMarkup(
    [
        # Блок 1: Производство
        [KeyboardButton("☕ Напитки"), KeyboardButton("🍽️ Блюда")],
        [KeyboardButton("📋 Стандарты"), KeyboardButton("💰 Меню")],
        
        # Блок 2: Люди и управление
        [KeyboardButton("👤 Персонал"), KeyboardButton("⏰ Графики")],
        
        # Блок 3: Аналитика и поиск
        [KeyboardButton("📊 Отчёты"), KeyboardButton("🔍 Поиск")],
        
        # Блок 4: AI и заметки
        [KeyboardButton("🧠 Вопрос к AI"), KeyboardButton("📝 Заметка")],
        
        # Блок 5: Управление ботом
        [KeyboardButton("⚙️ Статус"), KeyboardButton("❓ Помощь")],
    ],
    resize_keyboard=True,
)

BUTTON_QUERIES = {
    "☕ Напитки": "Рецептуры напитков бара VK-offee: капучино, латте, эспрессо и другие",
    "🍽️ Блюда": "Меню блюд кухни VK-offee, ингредиенты и технология приготовления",
    "📋 Стандарты": "Стандарты обслуживания, чеклисты смены, правила работы",
    "💰 Меню": "Прайс-лист с ценами на напитки и блюда",
    "👤 Персонал": "Ставки оплаты труда бариста, повара, официанта",
    "⏰ Графики": "Графики работы смен, дежурства, выходные",
    "📊 Отчёты": "Последние отчёты от агентов экзокортекса (продажи, финансы, склад)",
    "🔍 Поиск": "Введите что ищете — найду в базе знаний",
    "🧠 Вопрос к AI": "Задайте вопрос AI — ответ через знания VK-offee",
    "📝 Заметка": "Сохранить заметку в DS-strategy/inbox",
    "⚙️ Статус": "Статус RAG API и бота",
    "❓ Помощь": "Справка по использованию бота",
}
```

#### 3.2 Функция для отчётов от агентов

**Добавить новую функцию после `rag_reply`:**

```python
async def send_agent_reports(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Получить последние отчёты агентов из экзокортекса"""
    outbox_dir = CODEX_OUTBOX_DIR
    if not outbox_dir.exists():
        await safe_reply(update.message, "📂 Папка с отчётами не найдена")
        return
    
    reports = sorted(outbox_dir.glob("*.md"), key=lambda x: x.stat().st_mtime, reverse=True)[:3]
    
    if not reports:
        await safe_reply(update.message, "📭 Новых отчётов нет")
        return
    
    message = "📊 *Последние отчёты агентов:*\n\n"
    for report in reports:
        content = report.read_text(encoding="utf-8")[:500]  # первые 500 символов
        title = report.stem
        message += f"📄 *{title}*\n{content}...\n\n"
    
    await safe_reply(update.message, message, parse_mode="Markdown")
```

**И добавить в обработчик кнопок:**
```python
elif message_text == "📊 Отчёты":
    await send_agent_reports(update, context)
```

---

### **ЭТАП 4️⃣: CLOUD DEPLOYMENT (2-3 часа)**

#### 4.1 Обновить deploy.sh

В `/VK-offee/telegram-bot/deploy.sh` обновить:

```bash
# Строка с GitHub - заменить на новый namespace
git clone https://github.com/AlexPoAi/VK-offee.git /opt/vk-offee
git clone https://github.com/AlexPoAi/VK-offee-rag.git /opt/vk-offee-rag

# Добавить env переменные
cat > /opt/vk-offee/telegram-bot/.env.production << 'EOF'
TELEGRAM_BOT_TOKEN=<берется из файла на VPS>
OPENAI_API_KEY=<берется из файла на VPS>
RAG_API_URL=http://127.0.0.1:8000  # локально, или remote если на разных машинах
BOT_RUNTIME_MODE=cloud
EOF

# Добавить systemd сервисы (если их нет)
# vk-rag-api.service
# vk-telegram-bot.service
```

#### 4.2 Создать systemd сервисы (если не существуют)

**`/etc/systemd/system/vk-rag-api.service`:**
```ini
[Unit]
Description=VK-offee RAG API
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/vk-offee-rag
Environment="PATH=/opt/vk-offee-rag/venv/bin"
Environment="RAG_API_HOST=0.0.0.0"
Environment="RAG_API_PORT=8000"
ExecStart=/opt/vk-offee-rag/venv/bin/python src/api.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**`/etc/systemd/system/vk-telegram-bot.service`:**
```ini
[Unit]
Description=VK-offee Telegram Bot
After=network.target vk-rag-api.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/vk-offee/telegram-bot
EnvironmentFile=/opt/vk-offee/telegram-bot/.env.production
Environment="BOT_RUNTIME_MODE=cloud"
ExecStart=/opt/vk-offee/telegram-bot/venv/bin/python bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Включить сервисы:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable vk-rag-api vk-telegram-bot
sudo systemctl start vk-rag-api vk-telegram-bot
sudo systemctl status vk-telegram-bot
```

---

## 📋 ЧЕКЛИСТ ДО ЗАПУСКА

### ДО запуска локально

- [ ] Проверить `.env` содержит `TELEGRAM_BOT_TOKEN`
- [ ] Запустить RAG API локально (`python3 src/api.py`)
- [ ] Проверить `/health` endpoint в RAG
- [ ] Запустить бот локально (`python3 bot.py`)
- [ ] Проверить логи в `bot.log`

### Тестирование

- [ ] Отправить текстовый вопрос → ответ от RAG
- [ ] Нажать на кнопку "☕ Напитки" → должен ответить
- [ ] Команда `/status` → показать статус RAG
- [ ] Команда `/note это заметка` → сохранится в DS-strategy
- [ ] Фото с подписью → сохранится как Codex task

### Cloud deployment (если на VPS)

- [ ] Обновить deploy.sh с новым GitHub namespace
- [ ] Создать systemd сервисы
- [ ] Включить auto-restart в systemd
- [ ] Проверить логи: `journalctl -u vk-telegram-bot -f`
- [ ] Выключить локальный бот (чтобы не было дублирования)

---

## 🔧 ФАЙЛЫ ДЛЯ РЕДАКТИРОВАНИЯ

| Файл | Что менять | Приоритет |
|------|-----------|----------|
| `/VK-offee/telegram-bot/bot.py` | Добавить handle_button_press, добавить MessageHandler | 🔴 КРИТИЧНО |
| `/VK-offee-rag/src/api.py` | API_HOST в env, улучшить health endpoint | 🟡 ВЫСОКИЙ |
| `/VK-offee/telegram-bot/.env` | Проверить все ключи, добавить BOT_RUNTIME_MODE | 🔴 КРИТИЧНО |
| `/VK-offee/telegram-bot/deploy.sh` | Обновить GitHub namespace | 🟡 ВЫСОКИЙ |

---

## 📞 КОНТАКТЫ БЛОКЕРОВ

| Проблема | Решение | Ответ |
|----------|---------|--------|
| OPENAI_API_KEY отсутствует | Добавить в .env | ✅ |
| TELEGRAM_BOT_TOKEN invalid | Обновить токен из BotFather | ✅ |
| RAG API зависает | Увеличить timeout в rag_client.py | ⏳ |
| Кнопки не работают | Добавить MessageHandler | 🔴 |

---

## 🎯 ИТОГОВЫЙ РЕЗУЛЬТАТ

После выполнения всех этапов бот будет:

✅ **24/7 принимать заметки** — кнопка "📝 Заметка" + `/note` команда  
✅ **Искать по базе знания** — все 12 кнопок работают, RAG отвечает  
✅ **Присылать отчёты агентов** — кнопка "📊 Отчёты" показывает последние 3  
✅ **Красивые и понятные кнопки** — структурированы на 5 блоков  
✅ **Работать на VPS 24/7** — systemd сервис с auto-restart  
✅ **Не зависеть от ноутбука** — cloud-first архитектура  

---

**Статус:** 🔴 БЛОКИРУЕТ ИСПОЛЬЗОВАНИЕ  
**Начать:** ЭТАП 1 (диагностика) — 1-2 часа  
**Завершить:** Все 4 этапа — 8-12 часов
