--Для session_price_history вывести:
--- session_id
--- price
--- предыдущую цену этого же сеанса
--- valid_from
--Для каждого session_id версии должны идти по valid_from.

select
    sph.session_id,
    sph.price,
    lag(sph.price) over (
        partition by sph.session_id
        order by sph.valid_from
    ) as previous_price,
    sph.valid_from
from session_price_history sph
order by sph.session_id, sph.valid_from;