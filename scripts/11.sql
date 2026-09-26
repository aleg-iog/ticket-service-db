--Найти пары пользователей с одинаковой фамилией.
--Вывести:
--- user_id первого пользователя
--- user_id второго пользователя
--- общую фамилию

select
    u1.user_id as first_user_id,
    u2.user_id as second_user_id,
    u1.last_name
from users u1
inner join users u2
    on u1.last_name = u2.last_name
   and u1.user_id < u2.user_id;