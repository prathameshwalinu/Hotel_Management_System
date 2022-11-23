Create Proc Subscription_reminder @months int
as
begin

	select count(*) as NoOfCustomersWhoNeedReminders from (
	select c.CustomerId,s.SubscriptionId,s.SubscriptionEndDate,c.EmailId,
	(select case when DATEDIFF(MONTH,GETDATE(),s.SubscriptionEndDate)>@months
	then 'No Need for Reminder' else 'Need Reminder' End) as Reminder
	from Subscription s right join Customer c
	on s.CustomerId=c.CustomerId where 
	(select case when DATEDIFF(MONTH,GETDATE(),s.SubscriptionEndDate)>@months
	then 'No Need for Reminder' else 'Need Reminder' End) = 'Need Reminder') s

	select c.CustomerId,s.SubscriptionId,s.SubscriptionEndDate,c.EmailId,
	(select case when DATEDIFF(MONTH,GETDATE(),s.SubscriptionEndDate)>6
	then 'No Need for Reminder' else 'Need Reminder' End) as Reminder
	from Subscription s right join Customer c
	on s.CustomerId=c.CustomerId order by s.SubscriptionEndDate

end

exec Subscription_reminder 6


Create Proc getBooking @customer varchar(5)
as
begin

	select b.BookingId,c.CustomerName,c.EmailId,h.HotelName,h.AboutInfo,
	r.RoomId,hl.ZipCode from Booking b join 
	RoomBookingConfirmation rb on b.BookingId=rb.BookingId
	join Hotel h on h.HotelId=b.HotelId
	join Room r on r.HotelId=b.HotelId
	join HotelLocation hl on hl.ZipCode=h.ZipCode 
	join Customer c on c.CustomerId=b.CustomerId 
	where b.BookingId=@customer

end

exec getBooking 'B0002'


Create Proc UpdateRoomTariff @hotel varchar(5),@room varchar(5) ,@tariff int
as
begin

	declare @hid varchar(5),@rid varchar(5),@p int
	set @hid=@hotel
	set @rid=@room
	set @p=@tariff
	update Room Set Tariff=@tariff where HotelId=@hid and RoomId=@room
	Print('Updated Successfully')
	Select * from Room r where RoomId=@rid and HotelId=@hid 

end

exec UpdateRoomTariff 'H0005','R0005',90