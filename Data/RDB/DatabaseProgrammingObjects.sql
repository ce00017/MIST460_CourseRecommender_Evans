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
    @CourseID INT = NULL
    AS
    BEGIN
SELECT p.PrerequisiteID, c.Title FROM CoursePrerequisite p
    JOIN Course c ON p.PrerequisiteID = c.CourseID
    WHERE (@CourseID IS NULL OR p.CourseID = @CourseID);
END;
GO

--EXEC GetCoursePrerequisites @CourseID = 1;