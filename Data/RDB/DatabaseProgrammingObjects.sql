CREATE PROCEDURE GetSectionsInSemesterAndYear
    @SectionSemester NVARCHAR(10) = NULL,
    @SectionYear INT = NULL,
    @CourseID VARCHAR(10) = NULL
    AS
    BEGIN
SELECT s.SectionNumber, s.InstructorID, s.SectionSemester, s.SectionYear, s.RemainingOpenings, s.SectionAverageRating,
    c.CourseID, c.Title FROM Section s
    JOIN Course c ON s.CourseID = c.CourseID
    WHERE (@SectionSemester IS NULL OR s.SectionSemester = @SectionSemester)
    AND (@SectionYear IS NULL OR s.SectionYear = @SectionYear);

END;
GO

CREATE PROCEDURE GetCoursePrerequisites
    @CourseID INT = NULL
    AS
    BEGIN
SELECT p.PrerequisiteID, c.Title FROM CoursePrerequisite p
    JOIN Course c ON p.PrerequisiteID = c.CourseID
    WHERE (@CourseID IS NULL OR p.CourseID = @CourseID);
END;
GO