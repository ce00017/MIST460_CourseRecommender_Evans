use MIST460_RDB_Evans

CREATE table AppUser 

(
    AppUserID int IDENTITY(1,1) 
        constraint PK_AppUser primary key,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email nvarchar(100) NOT NULL
        CONSTRAINT UK_AppUser_Email UNIQUE,
    PhoneNumber nvarchar(20) NULL,
    PasswordHash varbinary(255) NOT NULL,
    UserRole nvarchar(20) NOT NULL
        CONSTRAINT CK_AppUser_UserRole CHECK (UserRole IN ('Student', 'Advisor', 'Alumni'))
        );