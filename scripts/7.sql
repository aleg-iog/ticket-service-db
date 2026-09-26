--Вывести всех пользователей, даже если у них нет заказов:
--- user_id
--- first_name
--- last_name
--- количество заказов

select u.user_id, u.first_name, u.last_name, count(o.order_id) as number_of_orders
from users u left join orders o on o.user_id = u.user_id 
group by u.user_id;