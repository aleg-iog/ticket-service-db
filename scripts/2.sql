--Для каждого мероприятия вывести:
--- event_id
--- название мероприятия
--- количество проданных билетов
--- общую выручку по билетам
--Показать только мероприятия, для которых продано больше одного билета. 
--Отсортировать по выручке по убыванию.

SELECT e.event_id, e.title, count(*), sum(t.price) as revenue
from events e 
	inner join sessions s on e.event_id = s.event_id 
	inner join tickets t on t.session_id = s.session_id 
group by e.event_id, e.title 
having count(*) > 1
order by revenue desc;