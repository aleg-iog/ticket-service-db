--Вывести все оплаченные заказы.
--Оставить только заказы дороже 1000 и отсортировать по стоимости от большей к меньшей.


SELECT
    orders.order_id, users.first_name, users.last_name, orders.total_amount, orders.created_at
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id
WHERE orders.payment_status
  AND orders.total_amount > 1000
ORDER BY orders.total_amount DESC;