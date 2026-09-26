--Вывести 5 заказов с наибольшей стоимостью, пропустив первые 3.
--Вывести:
--- order_id
--- total_amount
--- created_at

select
    order_id,
    total_amount,
    created_at
from orders
order by total_amount desc
limit 5
offset 3;