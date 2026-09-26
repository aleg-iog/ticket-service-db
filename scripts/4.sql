--Вывести event_id и title мероприятий, на которые был куплен хотя бы один билет дороже 800.

select ee.event_id, ee.title
from events ee
where ee.event_id in (
	select e.event_id
	from events e
		inner join sessions s on s.event_id = e.event_id 
		inner join tickets t on t.session_id = s.session_id
	where t.price > 800
);