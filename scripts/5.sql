--Найти билеты, цена которых не меньше цены любого билета в базе.

select t.ticket_id, t.price
from tickets t
where t.price >= all(select t2.price from tickets t2);