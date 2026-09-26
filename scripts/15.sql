--С помощью with recursive сгенерировать числа от 1 до 15, а затем соединить их с sessions по session_id.
--Вывести:
--- сгенерированный номер
--- session_id
--- starts_at

with recursive numbers as (
    select 1 as n

    union all

    select n + 1
    from numbers
    where n < 15
)
select
    numbers.n,
    s.session_id,
    s.starts_at
from numbers
left join sessions s
    on s.session_id = numbers.n;