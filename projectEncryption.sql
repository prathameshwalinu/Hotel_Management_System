ALTER TABLE Customer ADD ENCRYPTED_Email VarBINARY(100);

Create Master Key Encryption by PASSWORD = 'Th!sHereIs7ust$@nd0m5tu33'

SELECT name KeyName,
    symmetric_key_id KeyID,
    key_length KeyLength,
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

CREATE CERTIFICATE Certificate_EmailEncrypt WITH SUBJECT = 'Protect my Email';

CREATE SYMMETRIC KEY EmailEncryptor 
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE Certificate_EmailEncrypt;

SELECT name CertName,
    certificate_id CertID,
    pvt_key_encryption_type_desc EncryptType,
    issuer_name Issuer
FROM sys.certificates;

SELECT name KeyName,
    symmetric_key_id KeyID,
    key_length KeyLength,
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

OPEN SYMMETRIC KEY EmailEncryptor DECRYPTION BY CERTIFICATE Certificate_EmailEncrypt;

UPDATE Customer SET ENCRYPTED_Email = ENCRYPTBYKEY(KEY_GUID('EmailEncryptor'), EmailId) FROM Customer;
GO

CLOSE SYMMETRIC KEY EmailEncryptor

SELECT * FROM Customer;