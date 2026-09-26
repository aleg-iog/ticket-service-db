--Вывести все площадки и их залы, включая площадки, у которых пока нет ни одного зала:
--- venue_id
--- name
--- hall_id
--- hall_number

select v.venue_id, v.name, h.hall_id, h.hall_number
from halls h
	right join venues v on v.venue_id = h.venue_id;