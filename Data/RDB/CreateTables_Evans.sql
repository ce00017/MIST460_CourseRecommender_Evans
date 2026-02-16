use MIST460_RDB_Evans
GO

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

GO

/*
alter table AppUser
    NOCHECK constraint CK_AppUser_UserRole;

ALTER TABLE AppUser
    CHECK CONSTRAINT CK_AppUser_UserRole;
*/

create table Student

(
    StudentID int
        constraint PK_Student primary key
        constraint FK_Student_AppUserID foreign key references AppUser(AppUserID),
    TotalCreditsCompleted int NOT NULL
        CONSTRAINT DF_Student_TotalCreditsCompleted DEFAULT 0, --Credtis completed += SemesterCredits
    GraduationSemesterYear NVARCHAR(25) NOT NULL,
    OverallGPA decimal(3,2) NOT NULL
        CONSTRAINT DF_Student_OverallGPA DEFAULT 0.00,
    MajorGPA decimal(3,2) NOT NULL
        CONSTRAINT DF_Student_MajorGPA DEFAULT 0.00
);
GO