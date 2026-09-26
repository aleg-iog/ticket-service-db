--Вывести билеты, цена которых выше средней цены всех билетов.
--Вывести:
--- ticket_id
--- price

select
    t.ticket_id,
    t.price
from tickets t
where t.price > (
    select avg(t2.price)
    from tickets t2
);