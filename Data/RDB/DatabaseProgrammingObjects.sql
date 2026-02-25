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

CREATE OR ALTER PROCEDURE CheckStudentPrerequisites --This checks if the provided info actually relates to a course, then checks if the student ever took the class with a passing grade.
    @StudentID    INT,
    @SubjectCode  VARCHAR(30),
    @CourseNumber VARCHAR(30)
AS
BEGIN
    IF @StudentID IS NULL OR @SubjectCode IS NULL OR @CourseNumber IS NULL
    BEGIN
        RAISERROR('All parameters must be provided.', 16, 1); --Again AI was used for this edge case.
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Course WHERE SubjectCode = @SubjectCode AND CourseNumber = @CourseNumber)
    BEGIN
        RAISERROR('Course not found.', 16, 1); --Again AI was used for this edge case.
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
    BEGIN
        RAISERROR('Student not found.', 16, 1);
        RETURN;
    END;

    SELECT
        prereq.SubjectCode,
        prereq.CourseNumber,
        prereq.Title,
        cp.MinGradeRequired,
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM Section s
                JOIN RegistrationSection rs ON rs.SectionID     = s.SectionID
                JOIN Registration r         ON r.RegistrationID = rs.RegistrationID
                WHERE s.CourseID              = prereq.CourseID
                  AND r.StudentID             = @StudentID
                  AND rs.EnrollmentStatus     = 'Completed'
                  AND rs.LetterGrade          IS NOT NULL
                  AND rs.LetterGrade          NOT IN ('F', 'W')
                  AND rs.LetterGrade          <= cp.MinGradeRequired
            ) THEN 'Met'
            ELSE 'Not Met'
        END AS PrerequisiteStatus
    FROM CoursePrerequisite cp
        JOIN Course c      ON cp.CourseID       = c.CourseID
        JOIN Course prereq ON cp.PrerequisiteID = prereq.CourseID
    WHERE c.SubjectCode  = @SubjectCode
      AND c.CourseNumber = @CourseNumber;
END;
GO

--EXEC CheckStudentPrerequisites @StudentID = 1, @SubjectCode = 'MIST', @CourseNumber = '450';