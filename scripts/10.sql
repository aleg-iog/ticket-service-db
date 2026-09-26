--Вывести билеты, цена которых больше хотя бы одной цены из session_price_history.
--Вывести:
--- ticket_id
--- price

select t.ticket_id, t.price
from tickets t 
where t.price > any(select sph.price from session_price_history sph);