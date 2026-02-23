SELECT s.SectionNumber, s.InstructorID, s.SectionSemester, s.SectionYear, s.RemainingOpenings, s.SectionAverageRating,
    c.CourseID, c.Title FROM Section s
    JOIN Course c ON s.CourseID = c.CourseID
    WHERE (@SectionSemester IS NULL OR s.SectionSemester = @SectionSemester)
    AND (@SectionYear IS NULL OR s.SectionYear = @SectionYear);

SELECT p.PrerequisiteCourseID, c.Title FROM CoursePrerequisite p
    JOIN Course c ON p.PrerequisiteCourseID = c.CourseID
    WHERE (@CourseID IS NULL OR p.CourseID = @CourseID);