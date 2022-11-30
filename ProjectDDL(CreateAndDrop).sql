CREATE TABLE HotelLocation(
    ZipCode INT NOT NULL PRIMARY KEY,
    City VARCHAR(25),
    Area VARCHAR(25),
);


CREATE TABLE HotelType(
    HotelTypeId VARCHAR(5) NOT NULL PRIMARY KEY,
    HotelTypeDescriptions VARCHAR(100)
);


CREATE TABLE RoomType(
    RoomTypeId VARCHAR(5) NOT NULL PRIMARY KEY,
    RoomTypeDescriptions VARCHAR(100),
    PriceRange INT
);

CREATE TABLE Hotel(
    HotelId VARCHAR(5) NOT NULL PRIMARY KEY,
    HotelName VARCHAR(100),
    AboutInfo VARCHAR(100),
    HotelTypeId VARCHAR(5) NOT NULL,
    ZipCode INT NOT NULL,
    CONSTRAINT HotelTypeId_Fk  FOREIGN KEY (HotelTypeId) REFERENCES HotelType(HotelTypeId),
    CONSTRAINT ZipCode_Fk  FOREIGN KEY (ZipCode) REFERENCES HotelLocation(ZipCode)
);

CREATE TABLE Room(
    RoomId VARCHAR(5) NOT NULL PRIMARY KEY,
    NumberOfPersons INT,
    Availablity VARCHAR(10)
    CONSTRAINT Availibity_Chk CHECK (Availablity IN ('Available', 'Unavilable')), --CHECK
    Beds INT,
    Tariff INT,
    RoomTypeId VARCHAR(5) NOT NULL,
    HotelId VARCHAR(5) NOT NULL,
    CONSTRAINT HotelId_Fk  FOREIGN KEY (HotelId) REFERENCES Hotel(HotelId),
    CONSTRAINT RoomTypeId_Fk  FOREIGN KEY (RoomTypeId) REFERENCES RoomType(RoomTypeId)
);

--ALTER TABLE Room ALTER COLUMN Availablity VARCHAR(10)

CREATE TABLE Customer(
    CustomerId VARCHAR(5) NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10) CONSTRAINT Gender_Chk CHECK (Gender IN ('Male', 'Female', 'Other')),
    EmailId VARCHAR(25) CONSTRAINT email_ck CHECK (Emailid LIKE '[a-z,0-9,_,-]%@[a-z]%.[a-z][a-z]%'),
    Phone BIGINT NOT NULL CONSTRAINT Phone_ck CHECK  (len([Phone])=10),
    DOB DATE
);


CREATE TABLE Subscription(
    SubscriptionId VARCHAR(5) NOT NULL PRIMARY KEY,
    SubscriptionStartDate DATE,
    SubscriptionEndDate DATE,
    CustomerId VARCHAR(5) NOT NULL
    CONSTRAINT CustomerId_Fk FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);


CREATE TABLE Offer(
    OfferId VARCHAR(5) NOT NULL PRIMARY KEY,
    OfferDescription VARCHAR(100),
    OfferTermsandConditions VARCHAR(100),
    OfferValidity DATE
);


CREATE TABLE Booking(
    BookingId VARCHAR(5) NOT NULL PRIMARY KEY,
    CustomerId VARCHAR(5) NOT NULL,
    HotelId VARCHAR(5) NOT NULL,
	RoomId VARCHAR(5) Not null,
    BookingDate DATE,
    BookingDetails VARCHAR(100),
	CONSTRAINT BRoomId_Fk FOREIGN KEY (RoomId) REFERENCES Room(RoomId),
    CONSTRAINT BookingCustomerId_Fk FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
    CONSTRAINT BookingHotel_Fk FOREIGN KEY (HotelId) REFERENCES Hotel(HotelId),
);


CREATE TABLE Payment(
    PaymentId VARCHAR(5) NOT NULL,
    Total BIGINT,
    DateOfTransaction DATE Default GETDATE(),
    TimeofTransaction TIME Default GETDATE(),
    BookingId VARCHAR(5) NOT NULL,
    Constraint PaymentBookingId_pk PRIMARY KEY (PaymentId),
    CONSTRAINT PaymentBookingId_Fk FOREIGN KEY (BookingId) REFERENCES Booking(BookingId)
);


CREATE TABLE Discount(
    DiscountPercentage INT,
    CustomerId VARCHAR(5) NOT NULL,
    OfferId VARCHAR(5) NOT NULL,
    CONSTRAINT Discount_Pk PRIMARY KEY (CustomerId, OfferId),
    CONSTRAINT DiscountCustomerId_Fk FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
    CONSTRAINT DiscountOfferId_Fk FOREIGN KEY (OfferId) REFERENCES Offer(OfferId)
);


CREATE TABLE BookingHistory(
    BookingHistoryId VARCHAR(5) NOT NULL PRIMARY KEY,
    BookingId VARCHAR(5) NOT NULL,
    CONSTRAINT BHBookingId_Fk FOREIGN KEY (BookingId) REFERENCES Booking(BookingId)
);


CREATE TABLE Review(
    CustomerId VARCHAR(5) NOT NULL,
    HotelId VARCHAR(5) NOT NULL,
    ReviewDescription VARCHAR(100),
    CONSTRAINT Review_Pk PRIMARY KEY (CustomerId, HotelId),
    CONSTRAINT ReviewCustomerId_Fk FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
    CONSTRAINT ReviewHotelId_Fk FOREIGN KEY (HotelId) REFERENCES Hotel(HotelId)
);


CREATE TABLE RoomBookingConfirmation(
    BookingId VARCHAR(5) NOT NULL,
    RoomId VARCHAR(5) NOT NULL,
    CheckInDate DATE,
    CheckOutDate DATE,
    CONSTRAINT Date_check CHECK (CheckInDate<CheckOutDate),
    CONSTRAINT RBCRoomBookingConfirmation_Pk PRIMARY KEY (BookingId,RoomId),
    CONSTRAINT RBCBookingId_Fk FOREIGN KEY (BookingId) REFERENCES Booking(BookingId),
    CONSTRAINT RBCRoomId_Fk FOREIGN KEY (RoomId) REFERENCES Room(RoomId)
);


CREATE TABLE LocationType(
    CustomerId VARCHAR(5) NOT NULL,
    ZipCode INT NOT NULL,
    LocationName VARCHAR(100),
    CONSTRAINT LocationType_Pk PRIMARY KEY (CustomerId, ZipCode),
    CONSTRAINT LTCustomerId_Fk FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
    CONSTRAINT LTZipCode_Fk FOREIGN KEY (ZipCode) REFERENCES HotelLocation(ZipCode)
);




drop table LocationType
drop table RoomBookingConfirmation
drop table Review
drop table Discount
drop table Payment
drop table BookingHistory
drop table Booking
drop table Offer
drop table Subscription
drop table Customer
drop table Room
drop table Hotel
drop table RoomType
drop table HotelType
drop table HotelLocation
