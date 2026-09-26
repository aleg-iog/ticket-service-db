# Физическая модель базы данных

## 1. Общая информация
СУБД: PostgreSQL

Мы создаём сервис продажи билетов на мероприятия. Одно и то же мероприятие может проходить несколько раз. Мероприятия проходят на площадках. У одной площадки может быть несколько залов. В каждом зале есть фиксированные места: ряд и номер. Один сеанс проходит в одном зале. Пользователь может выбрать несколько билетов и оплатить их одним заказом.


## 2. Диаграмма

![Физическая модель](physical-model.png)

## 3. Таблицы и атрибуты

### 3.1 `users`

Хранит информацию о пользователях сервиса.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `user_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор пользователя |
| `first_name` | `varchar(100)` | `NOT NULL` | Имя  |
| `last_name` | `varchar(100)` | `NOT NULL` | Фамилия  |
| `birth_date` | `date` | - | Дата рождения |
| `created_at` | `timestamp` | `NOT NULL`, `DEFAULT CURRENT_TIMESTAMP` | Дата и время создания записи |

---

### 3.2 `orders`

Хранит заказы пользователей.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `order_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор заказа |
| `user_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `users.user_id` | Пользователь, создавший заказ |
| `created_at` | `timestamp` | `NOT NULL`, `DEFAULT CURRENT_TIMESTAMP` | Дата и время создания заказа |
| `payment_status` | `boolean` | `NOT NULL`, `DEFAULT FALSE` | Статус оплаты: `TRUE` - оплачен, `FALSE` - не оплачен |
| `total_amount` | `decimal(10,2)` | `NOT NULL`, `CHECK (total_amount > 0)` | Итоговая стоимость заказа |

---

### 3.3 `tickets`

Хранит билеты, входящие в заказы.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `ticket_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор билета |
| `order_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `orders.order_id` | Заказ, к которому относится билет |
| `session_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `sessions.session_id` | Сеанс, на который приобретён билет |
| `seat_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `seats.seat_id` | Место в зале |
| `price` | `decimal(10,2)` | `NOT NULL`, `CHECK (price > 0)` | Цена билета на момент покупки |
| `created_at` | `timestamp` | `NOT NULL`, `DEFAULT CURRENT_TIMESTAMP` | Дата и время создания билета |

Дополнительное ограничение:

- `UNIQUE (session_id, seat_id)` - запрещает продажу одного и того же места более одного раза на один сеанс.

---

### 3.4 `seats`

Хранит информацию о местах в залах.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `seat_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор места |
| `hall_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `halls.hall_id` | Зал, в котором находится место |
| `row_number` | `integer` | `NOT NULL`, `CHECK (row_number > 0)` | Номер ряда |
| `seat_number` | `integer` | `NOT NULL`, `CHECK (seat_number > 0)` | Номер места |
| `zone_type` | `varchar(30)` | `NOT NULL` | Тип зоны, например `standard`, `vip` и т. п. |

Дополнительное ограничение:

- `UNIQUE (hall_id, row_number, seat_number)` - не допускает два одинаковых места в одном зале.

---

### 3.5 `sessions`

Хранит информацию о конкретных сеансах мероприятий.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `session_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор сеанса |
| `event_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `events.event_id` | Мероприятие |
| `hall_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `halls.hall_id` | Зал проведения |
| `starts_at` | `timestamp` | `NOT NULL` | Дата и время начала сеанса |

---

### 3.6 `events`

Хранит информацию о мероприятиях.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `event_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор мероприятия |
| `title` | `varchar(50)` | `NOT NULL` | Название мероприятия |
| `short_description` | `varchar(200)` | - | Краткое описание |
| `host_name` | `varchar(100)` | `NOT NULL` | Организатор или ведущий мероприятия |

---

### 3.7 `halls`

Хранит информацию о залах площадок.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `hall_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор зала |
| `venue_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `venues.venue_id` | Площадка, которой принадлежит зал |
| `hall_number` | `integer` | `NOT NULL`, `CHECK (hall_number > 0)` | Номер зала |

Дополнительное ограничение:

- `UNIQUE (venue_id, hall_number)` - номер зала уникален в пределах одной площадки.

---

### 3.8 `venues`

Хранит информацию о площадках проведения мероприятий.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `venue_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор площадки |
| `name` | `varchar(50)` | `NOT NULL` | Название площадки |
| `address` | `varchar(100)` | `NOT NULL` | Адрес площадки |

---

### 3.9 `session_price_history`

Хранит историю изменения стоимости сеансов.

Таблица реализует **SCD Type 2**: при изменении цены старая версия записи не перезаписывается, а закрывается, после чего создаётся новая версия.

| Атрибут | Тип данных | Ограничения | Описание |
|---|---|---|---|
| `price_version_id` | `integer` | `PRIMARY KEY`, auto increment | Уникальный идентификатор версии цены |
| `session_id` | `integer` | `NOT NULL`, `FOREIGN KEY` → `sessions.session_id` | Сеанс |
| `price` | `decimal(10,2)` | `NOT NULL`, `CHECK (price > 0)` | Цена в данной версии |
| `valid_from` | `timestamp` | `NOT NULL` | Начало действия версии |
| `valid_to` | `timestamp` | `NULL` допустим | Конец действия версии |
| `is_current` | `boolean` | `NOT NULL`, `DEFAULT TRUE` | Признак текущей версии |

Ограничения:

- `CHECK (valid_to IS NULL OR valid_to > valid_from)` - дата окончания действия версии должна быть позже даты начала.




