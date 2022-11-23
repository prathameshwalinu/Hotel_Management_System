Create View Customer_Total_spend as
	select b.CustomerId,Sum(p.Total) as Total_spend from BookingHistory
	bh left join Payment p on bh.BookingId=p.BookingId
	join Booking b on b.BookingId=bh.BookingId
	group by b.CustomerId

select * from Customer_Total_spend


Create View Active_Subscriptions as
	Select s.CustomerId,s.SubscriptionEndDate,s.SubscriptionId,c.EmailId
	from Subscription s join Customer c on 
	c.CustomerId=s.CustomerId where s.SubscriptionEndDate>getdate()

select * from Active_Subscriptions


Create View getRoomsInBoston as
	Select r.RoomId,h.HotelId,h.HotelName,h.ZipCode,hl.Area,h.AboutInfo,ht.HotelTypeDescriptions
	,min(rt.PriceRange) as Minimum_Price,min(r.Tariff) as Minimum_Tariff
	from Hotel h join HotelLocation hl on h.ZipCode=hl.ZipCode 
	join HotelType ht on h.HotelTypeId=ht.HotelTypeId
	join Room r on r.HotelId=h.HotelId 
	join RoomType rt on rt.RoomTypeId=r.RoomTypeId
	where hl.City='Boston' group by r.RoomId,h.HotelId,h.HotelName,h.ZipCode,hl.Area,
	h.AboutInfo,ht.HotelTypeDescriptions

select * from getRoomsInBoston