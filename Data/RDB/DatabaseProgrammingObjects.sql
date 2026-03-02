USE MIST460_RDB_Evans;
GO

CREATE OR ALTER PROCEDURE GetSectionsInSemesterAndYear
    @SubjectCode VARCHAR(30) = NULL,
    @CourseNumber VARCHAR(30) = NULL
    AS
    BEGIN
SELECT s.SectionNumber, s.InstructorID, s.SectionSemester, s.SectionYear, s.RemainingOpenings, s.SectionAverageRating,
    c.CourseID, c.Title FROM Section s
    JOIN Course c ON s.CourseID = c.CourseID
    WHERE (@SubjectCode IS NULL OR c.SubjectCode = @SubjectCode)
    AND (@CourseNumber IS NULL OR c.CourseNumber = @CourseNumber)
    AND SectionYear >= YEAR(GETDATE());
END;
GO

--EXEC GetSectionsInSemesterAndYear @SubjectCode = 'MIST', @CourseNumber = '460';







CREATE OR ALTER PROCEDURE GetCoursePrerequisites
    @SubjectCode  VARCHAR(30) = NULL,
    @CourseNumber VARCHAR(30) = NULL
AS
BEGIN
    IF (@SubjectCode IS NULL AND @CourseNumber IS NOT NULL)
        OR (@SubjectCode IS NOT NULL AND @CourseNumber IS NULL)
    BEGIN
        RAISERROR('Both @SubjectCode and @CourseNumber must be provided together, or both left NULL.', 16, 1); --I used AI to help me solve this edge case. 
        RETURN;
    END;

    SELECT
        prereq.Title, prereq.SubjectCode, prereq.CourseNumber
    FROM CoursePrerequisite p
        JOIN Course c ON p.CourseID = c.CourseID
        JOIN Course prereq ON p.PrerequisiteID = prereq.CourseID
    WHERE
        (@SubjectCode IS NULL OR c.SubjectCode = @SubjectCode)
        AND (@CourseNumber IS NULL OR c.CourseNumber = @CourseNumber);
END;
GO

--EXEC GetCoursePrerequisites @SubjectCode = 'MIST', @CourseNumber = '450';








Create or alter function fnGetCoursePrerequisites
(
    @SubjectCode VARCHAR(30) = NULL,
    @CourseNumber VARCHAR(30)
)
returns @Prerequisites TABLE
(
    Title nvarchar(100),
    SubjectCode nvarchar(10),
    CourseNumber nvarchar(10),
    MinGradeRequired nchar(2)
)
AS
BEGIN
INSERT into @Prerequisites
(Title, SubjectCode, CourseNumber, MinGradeRequired)
SELECT prereq.Title, prereq.SubjectCode, prereq.CourseNumber, cp.MinGradeRequired
FROM CoursePrerequisite CP
JOIN Course MainCourse ON CP.CourseID = MainCourse.CourseID
JOIN Course prereq ON CP.PrerequisiteID = prereq.CourseID
WHERE MainCourse.SubjectCode = IsNull(@SubjectCode, MainCourse.SubjectCode)
  AND MainCourse.CourseNumber = @CourseNumber;

return;
END;
GO

-- select * from fnGetCoursePrerequisites('MIST', '460');








Create or alter function fnGetStudentCourseHistory
(
    @StudentID INT
)
returns @CourseHistory TABLE
(
    SubjectCode nvarchar(10),
    CourseNumber nvarchar(10),
    Grade nchar(2)
)
AS
BEGIN
INSERT into @CourseHistory
(SubjectCode, CourseNumber, Grade)
SELECT c.SubjectCode, c.CourseNumber, rs.LetterGrade
FROM Registration r
JOIN RegistrationSection rs ON r.RegistrationID = rs.RegistrationID
JOIN Section s ON rs.SectionID = s.SectionID
JOIN Course c ON s.CourseID = c.CourseID
WHERE r.StudentID = @StudentID

return;
END;
GO
-- select * from fnGetStudentCourseHistory(1);


create or alter function fnGradePointsFromLetterGrade
(
    @LetterGrade nchar(2)
)
RETURNS int
as 
BEGIN
    declare @GradePoints int;
    set @GradePoints = case @LetterGrade
        when 'A' then 4
        when 'B' then 3
        when 'C' then 2
        when 'D' then 1
        else 0
    end

RETURN @GradePoints;
END;

go





--Has the student taken the prerequisite courses for a given course?

CREATE OR ALTER PROCEDURE CheckStudentPrerequisites
    @StudentID    INT,
    @SubjectCode  VARCHAR(30),
    @CourseNumber VARCHAR(30)
AS
BEGIN
    SELECT * FROM fnGetCoursePrerequisites(@SubjectCode, @CourseNumber) AS Prerequisites
    left join fnGetStudentCourseHistory(@StudentID) AS History
    ON Prerequisites.SubjectCode = History.SubjectCode
    AND Prerequisites.CourseNumber = History.CourseNumber
    AND dbo.fnGradePointsFromLetterGrade(History.Grade) 
            >= dbo.fnGradePointsFromLetterGrade(Prerequisites.MinGradeRequired);
END;
GO

--EXEC CheckStudentPrerequisites @StudentID = 1, @SubjectCode = 'MIST', @CourseNumber = '450';
