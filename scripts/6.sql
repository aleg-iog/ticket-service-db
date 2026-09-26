--Для каждого билета вывести:
--- ticket_id
--- session_id
--- price
--- место этого билета по цене внутри своего сеанса
--То есть ранжирование должно начинаться заново для каждого session_id.


select
    t.ticket_id,
    t.session_id,
    t.price,
    dense_rank() over (
        partition by t.session_id
        order by t.price desc
    ) as price_rank
from tickets t;