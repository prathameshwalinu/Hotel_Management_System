CREATE TABLE CustomerLog(
    LogId INT IDENTITY PRIMARY KEY,
    CustomerId VARCHAR(5),
    CustomerName VARCHAR(255) NOT NULL,
    LastUpdatedOn DATETIME NOT NULL,
    OperationPerformed CHAR(10) NOT NULL,
    CHECK(OperationPerformed = 'INSERT' or OperationPerformed='DELETE')
);


CREATE TRIGGER CustomerAuditLog
ON Customer
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO CustomerLog(
        CustomerId,
        CustomerName,
        LastUpdatedOn,
        OperationPerformed
    )
    SELECT
        i.CustomerId,
        i.CustomerName,
        GETDATE(),
        'INSERT'
    FROM
        inserted i
END


Insert into Customer(
    CustomerId,
    CustomerName,
    Gender,
    EmailId,
    Phone,
    DOB
)
Values
   ('C0012','Vivek','Male','Vivekhana@gmail.com',8529639514,'06/28/1992')


CREATE TRIGGER EncryptionTrigger
ON Customer
AFTER INSERT
AS
BEGIN
    OPEN SYMMETRIC KEY EmailEncryptor DECRYPTION BY CERTIFICATE Certificate_EmailEncrypt;
    UPDATE Customer SET ENCRYPTED_Email = ENCRYPTBYKEY(KEY_GUID('EmailEncryptor'), EmailId) FROM Customer;
    CLOSE SYMMETRIC KEY EmailEncryptor;
END


SELECT * FROM Customer

SELECT * FROM CustomerLog
