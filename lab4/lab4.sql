use booking

-- 1. Добавить внешние ключи.

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

-- 2. Выдать информацию о клиентах гостиницы "Космос", проживающих в номерах категории "Люкс" на 1 апреля 2019г. 

SELECT client.id_client, client.name, client.phone 
FROM client
	INNER JOIN booking ON client.id_client = booking.id_client
	INNER JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
	INNER JOIN room ON room_in_booking.id_room = room.id_room
	INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
	INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE 
	hotel.name = 'Космос' AND 
	room_category.name = 'Люкс' AND 
	('2020-04-01' >= room_in_booking.checkin_date AND '2020-04-01' <= room_in_booking.checkout_date);

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля. 
	SELECT * FROM room WHERE id_room NOT IN (
		SELECT room.id_room FROM room_in_booking 
		RIGHT JOIN room ON room.id_room = room_in_booking.id_room
		WHERE '2019-04-22' >= room_in_booking.checkin_date AND '2019-04-22' <= room_in_booking.checkout_date)
	ORDER BY id_room, id_hotel

-- 4. Дать количество проживающих в гостинице "Космос" на 23 марта по каждой категории номеров	
SELECT COUNT(room_in_booking.id_room) AS guests_number, 
	room_category.id_room_category,
	(SELECT name FROM room_category AS category_name WHERE category_name.id_room_category = room_category.id_room_category) 
FROM room_category
	INNER JOIN room ON room_category.id_room_category = room.id_room_category
	INNER JOIN room_in_booking ON room.id_room = room_in_booking.id_room
	INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Космос' AND ('2019-03-23' >= room_in_booking.checkin_date AND '2019-03-23' < room_in_booking.checkout_date)
GROUP BY room_category.id_room_category;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы "Космос", выехавшим в апреле с указанием даты выезда. 
-- доработать вывод записи room_in_booking по наименьшему id

SELECT client.id_client, client.name, room.id_room, room_in_booking.checkout_date 
FROM room_in_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN client ON client.id_client = booking.id_client
INNER JOIN (SELECT * FROM hotel WHERE hotel.name = 'Космос') AS hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN (SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS check_max
	FROM  (SELECT * FROM room_in_booking 
		WHERE room_in_booking.checkout_date BETWEEN '2019-04-01' AND '2019-04-30') AS room_in_booking 
		GROUP BY room_in_booking.id_room) AS checkout_in_april ON checkout_in_april.id_room =  room_in_booking.id_room
	WHERE room_in_booking.id_room = checkout_in_april.id_room AND checkout_in_april.check_max = room_in_booking.checkout_date
	ORDER BY room.id_room;

-- 6. Продлить на 2 дня дату проживания в гостинице "Космос" всем клиентам комнат категории "Бизнес", которые заселились 10 мая.

UPDATE room_in_booking
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM room
	INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
	INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Космос' AND room_category.name = 'Бизнес' AND room_in_booking.checkin_date = '2019-05-10'

--7. Найти все "пересекающиеся" варианты проживания.
SELECT * FROM room_in_booking
INNER JOIN room_in_booking AS room_in_booking_2 ON room_in_booking.id_room = room_in_booking_2.id_room 
WHERE 
	room_in_booking.id_room_in_booking != room_in_booking_2.id_room_in_booking AND 
	(room_in_booking.checkin_date <= room_in_booking_2.checkin_date AND room_in_booking_2.checkin_date < room_in_booking.checkout_date)
ORDER BY room_in_booking.id_room_in_booking


-- 8. Создать бронирование в транзакции
BEGIN TRANSACTION
	INSERT INTO client VALUES ('Волков Волк Волкович', '8(800)000000')
	INSERT INTO booking VALUES (SCOPE_IDENTITY(), '2020-06-23')
	INSERT INTO room_in_booking VALUES(SCOPE_IDENTITY(), 100, '2020-06-23', '2020-06-30')
COMMIT;

-- 9. Добавить необходимые индексы для всех таблиц

CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON booking 
(
	[id_client] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_id_hotel-id_room_category] ON room
(
	[id_hotel] ASC,
	[id_room_category] ASC
)
CREATE NONCLUSTERED INDEX [IX_hotel_name] ON hotel
(
	[name] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_category_name] ON room_category
(
	[name] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room] ON room_in_booking 
(
	[id_room] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_booking] ON room_in_booking 
(
	[id_booking] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_id_booking_checkinout_date] ON room_in_booking 
(
	[checkin_date] ASC, 
	[checkout_date] ASC
)
CREATE UNIQUE NONCLUSTERED INDEX [IU_client_phone] ON client
(
	[phone] ASC
)
	



