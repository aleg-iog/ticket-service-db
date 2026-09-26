-- Найти пользователей, которые хотя бы раз покупали билет в зоне vip

select  u.user_id, u.first_name, u.last_name
from users u
where exists (
	select 	1 from orders
	inner join tickets on orders.order_id = tickets.order_id
	inner join seats on tickets.seat_id = seats.seat_id
	where seats.zone_type = 'vip' and orders.user_id = u.user_id 
);