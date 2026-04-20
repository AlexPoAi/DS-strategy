# Инструкция: Подключение к VPS и починка embeddings

## Шаг 1: SSH подключение

```bash
ssh root@72.56.4.61
# Введи пароль
```

## Шаг 2: Найти .env файл

```bash
cd ~
find . -name ".env" -type f 2>/dev/null
```

## Шаг 3: Обновить .env

```bash
# Открой .env в nano
nano ~/VK-offee-rag/.env

# Добавь строку:
OPENAI_BASE_URL=https://dev.aiprime.store/v1

# Сохрани: Ctrl+O, Enter, Ctrl+X
```

## Шаг 4: Переиндексация

```bash
cd ~/VK-offee-rag
python3 src/indexer.py
```

## Шаг 5: Перезапуск сервисов

```bash
sudo systemctl restart vk-rag-api
sudo systemctl restart vk-telegram-bot
```

## Шаг 6: Тест

Напиши боту в Telegram: "Какая зарплата у повара?"

---

**Скопируй эти команды и выполни на VPS.**
