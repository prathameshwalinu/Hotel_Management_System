Alter Proc Subscription_reminder @months int
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



Alter Proc getBooking @customer varchar(5)
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



Alter Proc UpdateRoomTariff @hotel varchar(5),@room varchar(5) ,@tariff int
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




Alter View Customer_Total_spend as
	select b.CustomerId,Sum(p.Total) as Total_spend from BookingHistory
	bh left join Payment p on bh.BookingId=p.BookingId
	join Booking b on b.BookingId=bh.BookingId
	group by b.CustomerId


Alter View Active_Subscriptions as
	Select s.CustomerId,s.SubscriptionEndDate,s.SubscriptionId,c.EmailId
	from Subscription s join Customer c on 
	c.CustomerId=s.CustomerId where s.SubscriptionEndDate>getdate()


Alter View getRoomsInBoston as
	Select r.RoomId,h.HotelId,h.HotelName,h.ZipCode,hl.Area,h.AboutInfo,ht.HotelTypeDescriptions
	,min(rt.PriceRange) as Minimum_Price,min(r.Tariff) as Minimum_Tariff
	from Hotel h join HotelLocation hl on h.ZipCode=hl.ZipCode 
	join HotelType ht on h.HotelTypeId=ht.HotelTypeId
	join Room r on r.HotelId=h.HotelId 
	join RoomType rt on rt.RoomTypeId=r.RoomTypeId
	where hl.City='Boston' group by r.RoomId,h.HotelId,h.HotelName,h.ZipCode,hl.Area,
	h.AboutInfo,ht.HotelTypeDescriptions