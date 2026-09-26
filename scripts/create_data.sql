-- 02_inserts.sql
-- Генерация тестовых данных для сервиса продажи билетов.
-- PostgreSQL.
-- ВНИМАНИЕ: скрипт очищает таблицы перед повторной генерацией данных.

TRUNCATE TABLE
    tickets,
    session_price_history,
    orders,
    sessions,
    seats,
    halls,
    events,
    venues,
    users
RESTART IDENTITY CASCADE;

-- USERS: 15 строк
INSERT INTO users (user_id, first_name, last_name, birth_date)
SELECT
    g,
    'User_' || g,
    'Surname_' || g,
    DATE '1985-01-01' + g * 180
FROM generate_series(1, 15) AS g;

-- VENUES: 15 строк
INSERT INTO venues (venue_id, name, address)
SELECT
    g,
    'Venue_' || g,
    'Address_' || g
FROM generate_series(1, 15) AS g;

-- EVENTS: 15 строк
INSERT INTO events (event_id, title, short_description, host_name)
SELECT
    g,
    'Event_' || g,
    'Description for event ' || g,
    'Host_' || g
FROM generate_series(1, 15) AS g;

-- HALLS: 15 строк
INSERT INTO halls (hall_id, venue_id, hall_number)
SELECT
    g,
    g,
    1
FROM generate_series(1, 15) AS g;

-- SEATS: 30 строк (по 2 места в каждом зале)
INSERT INTO seats (seat_id, hall_id, row_number, seat_number, zone_type)
SELECT
    g,
    ((g - 1) / 2) + 1,
    1,
    ((g - 1) % 2) + 1,
    CASE
        WHEN g % 2 = 0 THEN 'vip'
        ELSE 'standard'
    END
FROM generate_series(1, 30) AS g;

-- SESSIONS: 15 строк
INSERT INTO sessions (session_id, event_id, hall_id, starts_at)
SELECT
    g,
    g,
    g,
    TIMESTAMP '2026-10-01 18:00:00' + g * INTERVAL '1 day'
FROM generate_series(1, 15) AS g;

-- ORDERS: 15 строк
-- В каждом заказе далее будет по 2 билета.
INSERT INTO orders (order_id, user_id, payment_status, total_amount)
SELECT
    g,
    g,
    (g % 3 <> 0),
    2 * (600 + 20 * g)
FROM generate_series(1, 15) AS g;

-- SESSION_PRICE_HISTORY: 30 строк
-- По 2 версии цены на каждый из 15 сеансов.
INSERT INTO session_price_history
    (price_version_id, session_id, price, valid_from, valid_to, is_current)
SELECT
    2 * g - 1,
    g,
    500 + 20 * g,
    TIMESTAMP '2026-08-01 00:00:00',
    TIMESTAMP '2026-09-01 00:00:00',
    false
FROM generate_series(1, 15) AS g
UNION ALL
SELECT
    2 * g,
    g,
    600 + 20 * g,
    TIMESTAMP '2026-09-01 00:00:00',
    NULL,
    true
FROM generate_series(1, 15) AS g;

-- TICKETS: 30 строк
-- По 2 билета на каждый заказ и сеанс.
-- Места подобраны из того же зала, где проходит сеанс.
INSERT INTO tickets
    (ticket_id, order_id, session_id, seat_id, price)
SELECT
    g,
    ((g - 1) / 2) + 1,
    ((g - 1) / 2) + 1,
    g,
    600 + 20 * (((g - 1) / 2) + 1)
FROM generate_series(1, 30) AS g;

-- Синхронизация identity-последовательностей после явной вставки id.
SELECT setval(pg_get_serial_sequence('users', 'user_id'), (SELECT MAX(user_id) FROM users));
SELECT setval(pg_get_serial_sequence('venues', 'venue_id'), (SELECT MAX(venue_id) FROM venues));
SELECT setval(pg_get_serial_sequence('events', 'event_id'), (SELECT MAX(event_id) FROM events));
SELECT setval(pg_get_serial_sequence('halls', 'hall_id'), (SELECT MAX(hall_id) FROM halls));
SELECT setval(pg_get_serial_sequence('seats', 'seat_id'), (SELECT MAX(seat_id) FROM seats));
SELECT setval(pg_get_serial_sequence('sessions', 'session_id'), (SELECT MAX(session_id) FROM sessions));
SELECT setval(pg_get_serial_sequence('orders', 'order_id'), (SELECT MAX(order_id) FROM orders));
SELECT setval(pg_get_serial_sequence('session_price_history', 'price_version_id'), (SELECT MAX(price_version_id) FROM session_price_history));
SELECT setval(pg_get_serial_sequence('tickets', 'ticket_id'), (SELECT MAX(ticket_id) FROM tickets));

-- Проверка количества строк.
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL SELECT 'venues', COUNT(*) FROM venues
UNION ALL SELECT 'events', COUNT(*) FROM events
UNION ALL SELECT 'halls', COUNT(*) FROM halls
UNION ALL SELECT 'seats', COUNT(*) FROM seats
UNION ALL SELECT 'sessions', COUNT(*) FROM sessions
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'session_price_history', COUNT(*) FROM session_price_history
UNION ALL SELECT 'tickets', COUNT(*) FROM tickets
ORDER BY table_name;
