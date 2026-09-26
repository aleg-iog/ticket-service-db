--Вывести все мероприятия и все связанные с ними сеансы:
--- event_id
--- title
--- session_id
--- starts_at

SELECT e.event_id, e.title, s.session_id, s.starts_at
FROM events e full join sessions s on e.event_id  = s.event_id;