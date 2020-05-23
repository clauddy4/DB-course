use booking

-- 1. Äîáàâèòü âíåøíèå êëþ÷è

ALTER TABLE booking
	ADD FOREIGN KEY (id_client) 
	REFERENCES client (id_client);

ALTER TABLE room 
	ADD FOREIGN KEY (id_room_category) 
	REFERENCES room_category (id_room_category)

ALTER TABLE room 
	ADD FOREIGN KEY (id_hotel) 
	REFERENCES hotel (id_hotel);

ALTER TABLE room_in_booking
	ADD FOREIGN KEY (id_room) 
	REFERENCES room (id_room);

ALTER TABLE room_in_booking
	ADD FOREIGN KEY (id_booking) 
	REFERENCES booking (id_booking);

-- 2. Âûäàòü èíôîðìàöèþ î êëèåíòàõ ãîñòèíèöû "Êîñìîñ", ïðîæèâàþùèõ â íîìåðàõ êàòåãîðèè "Ëþêñ" íà 1 àïðåëÿ 2019ã

SELECT client.id_client, client.name, client.phone 
FROM client
	INNER JOIN booking ON client.id_client = booking.id_client
	INNER JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
	INNER JOIN room ON room_in_booking.id_room = room.id_room
	INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
	INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE 
	hotel.name = 'Êîñìîñ' AND 
	room_category.name = 'Ëþêñ' AND 
	('2019-04-01' >= room_in_booking.checkin_date AND '2019-04-01' <= room_in_booking.checkout_date);

-- 3. Äàòü ñïèñîê ñâîáîäíûõ íîìåðîâ âñåõ ãîñòèíèö íà 22 àïðåëÿ.
	SELECT * FROM room WHERE id_room NOT IN (
		SELECT room.id_room FROM room_in_booking 
		LEFT JOIN room ON room.id_room = room_in_booking.id_room
		WHERE '2019-04-22' >= room_in_booking.checkin_date AND '2019-04-22' <= room_in_booking.checkout_date)
	ORDER BY id_room, id_hotel

--4  Äàòü êîëè÷åñòâî ïðîæèâàþùèõ â ãîñòèíèöå “Êîñìîñ” íà 23 ìàðòà ïî êàæäîé êàòåãîðèè íîìåðîâ
SELECT 
	COUNT(room_in_booking.id_room) AS guests_number, 
	room_category.name 
FROM room_category
	INNER JOIN room ON room_category.id_room_category = room.id_room_category
	INNER JOIN room_in_booking ON room.id_room = room_in_booking.id_room
	INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Êîñìîñ' AND ('2019-03-23' >= room_in_booking.checkin_date AND '2019-03-23' < room_in_booking.checkout_date)
GROUP BY room_category.name;

-- 5. Äàòü ñïèñîê ïîñëåäíèõ ïðîæèâàâøèõ êëèåíòîâ ïî âñåì êîìíàòàì ãîñòèíèöû "Êîñìîñ", âûåõàâøèì â àïðåëå ñ óêàçàíèåì äàòû âûåçäà. 
-- äîðàáîòàòü âûâîä çàïèñè room_in_booking ïî íàèìåíüøåìó id

SELECT client.id_client, client.name, room.id_room,	room_in_booking.checkout_date 
FROM room_in_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN client ON client.id_client = booking.id_client
INNER JOIN (SELECT * FROM hotel WHERE hotel.name = 'Êîñìîñ') AS hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN (SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS check_max
	FROM  (SELECT * FROM room_in_booking 
		WHERE room_in_booking.checkout_date BETWEEN '2019-04-01' AND '2019-04-30') AS room_in_booking 
		GROUP BY room_in_booking.id_room) AS checkout_in_april ON checkout_in_april.id_room =  room_in_booking.id_room
	WHERE room_in_booking.id_room = checkout_in_april.id_room AND checkout_in_april.check_max = room_in_booking.checkout_date
	ORDER BY client.name;

-- 6. Ïðîäëèòü íà 2 äíÿ äàòó ïðîæèâàíèÿ â ãîñòèíèöå "Êîñìîñ" âñåì êëèåíòàì êîìíàò êàòåãîðèè "Áèçíåñ", êîòîðûå çàñåëèëèñü 10 ìàÿ.

UPDATE room_in_booking
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM room
	INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
	INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Êîñìîñ' AND room_category.name = 'Áèçíåñ' AND room_in_booking.checkin_date = '2019-05-10'

--7. Íàéòè âñå "ïåðåñåêàþùèåñÿ" âàðèàíòû ïðîæèâàíèÿ.
SELECT * FROM room_in_booking t1, room_in_booking t2
	WHERE 
		t1.id_room = t2.id_room AND t1.id_room_in_booking != t2.id_room_in_booking AND 
		(t1.checkin_date <= t2.checkin_date AND t2.checkin_date < t1.checkout_date)
	ORDER BY t1.id_room_in_booking


--8  Ñîçäàòü áðîíèðîâàíèå â òðàíçàêöèè
BEGIN TRANSACTION
	INSERT INTO client VALUES ('Ìèõàëêîâ Íèêèòà Ñåðãååâè', '8(800)000000')
	INSERT INTO booking VALUES (SCOPE_IDENTITY(), '2020-06-23')
	INSERT INTO room_in_booking VALUES(SCOPE_IDENTITY(), 100, '2020-06-23', '2020-06-30')
COMMIT;

-- 9. Äîáàâèòü íåîáõîäèìûå èíäåêñû äëÿ âñåõ òàáëèö

CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON booking (id_client)
CREATE NONCLUSTERED INDEX [IX_client_name] ON client (name)
CREATE NONCLUSTERED INDEX [IX_hotel_name] ON hotel (name)
CREATE NONCLUSTERED INDEX [IX_room_id_room_category] ON room (id_room_category)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room] ON room_in_booking (id_room)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_booking] ON room_in_booking (id_booking)
CREATE NONCLUSTERED INDEX [IX_room_id_booking_checkinout_date] ON room_in_booking (checkin_date ASC, checkout_date ASC)
	



