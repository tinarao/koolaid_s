# Kool-Aid Server

<p align="center">
    <img src="https://skillicons.dev/icons?i=elixir" />
</p>

Серверная часть [koolaid](https://github.com/tinarao/koolaid). Используется для управления сессиями.

# Технологии

- Elixir Phoenix

# Управление сессиями

Для хранения сессий используется [ets](https://hexdocs.pm/elixir/main/ets.html).
При создании сессии генерируется уникальный ключ, который живёт три часа (вдобавок каждые 10 минут производится полная очистка сохранённых сессий). Сессии общедоступны, подключиться к сессии можно по ключу.
Удалить сессию может только создатель.

# Авторизация

Для аутентификации пользователей используется уникальный `device_id` (`userAgent + ip`).

# Запуск

```sh
git clone https://github.com/tinarao/koolaid_s.git

docker build . -t koolaid-api

docker run -e SECRET_KEY_BASE=<your secret key> -p 4000:4000 koolaid-api
```
