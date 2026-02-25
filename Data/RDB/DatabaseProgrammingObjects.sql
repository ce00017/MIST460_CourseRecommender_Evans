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



--Has the student taken the prerequisite courses for a given course?

CREATE OR ALTER PROCEDURE HasStudentTakenPrerequisites
    @StudentID INT,
    @SubjectCode VARCHAR(30) = NULL,
    @CourseNumber VARCHAR(30) = NULL
    AS
    BEGIN
    SELECT 