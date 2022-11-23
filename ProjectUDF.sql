create FUNCTION dbo.FinalAmount(@Total bigint, @DiscountPercentage int)
RETURNS decimal(8,2)
AS
BEGIN
    RETURN ((@Total)-((@Total*@DiscountPercentage)/100))
END

SELECT p.PaymentId,p.BookingId,p.Total,dbo.FinalAmount(p.Total,d.DiscountPercentage) as Final_Amount FROM
Offer o JOIN Discount d ON o.OfferId=d.OfferId JOIN Booking b ON d.CustomerId=b.CustomerId
JOIN Payment p ON b.BookingId=p.BookingId where o.OfferValidity>b.BookingDate; 

CREATE FUNCTION dbo.TypeReview (
	@ReviewDescription varchar(100)
)
RETURNS varchar(12) AS
BEGIN
	DECLARE @return_value varchar(12);
	SET @return_value = 'not detected';
    IF (@ReviewDescription like '%good%' or @ReviewDescription like '%perfect%' or @ReviewDescription like '%excellent%') SET @return_value = 'good review';
    IF (@ReviewDescription like '%bad%' or @ReviewDescription like '%worse%' or @ReviewDescription like '%worst%') SET @return_value = 'bad review';
 
    RETURN @return_value
END;

Select CustomerId,HotelId,ReviewDescription,
dbo.TypeReview(ReviewDescription) as Review_Type From Review;

CREATE FUNCTION dbo.Age(@DOB date)
RETURNS INT AS
BEGIN
    RETURN (year(getDate())-year(@DOB))
END

SELECT CustomerId,CustomerName,Gender,EmailId,Phone,DOB,dbo.Age(DOB) as AGE
FROM Customer;

Create FUNCTION dbo.StarDescriptions (
	@HotelTypeDescriptions varchar(100)
)
RETURNS varchar(14) AS
BEGIN
	DECLARE @return_value varchar(14),@compare_value int;
    SET @compare_value= SUBSTRING(@HotelTypeDescriptions,1,1)
    IF (@compare_value<=3) SET @return_value = 'comfort hotel';
    IF (@compare_value>3 and @compare_value<=5) SET @return_value = 'luxury hotel';
    IF (@compare_value=7) SET @return_value = 'royale hotel';
 
    RETURN @return_value
END;

SELECT h.HotelId,h.HotelName,h.AboutInfo,dbo.StarDescriptions(t.HotelTypeDescriptions) as Star_Description
From HotelType t JOIN Hotel h ON t.HotelTypeId=h.HotelTypeId;