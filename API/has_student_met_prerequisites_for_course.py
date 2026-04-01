from get_db_connection import get_db_connection

def has_student_met_prerequisites_for_course(
    student_id: int = None,
    subject_code: str = None,
    course_number: str = None
):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{CALL procHasStudentMetPrerequisitesForCourse(?, ?, ?)}", (student_id, subject_code, course_number))
    rows = cursor.fetchall()
    conn.close()

    #convert rows to list of dicts
    results = [
        {
            "SubjectCode": row.SubjectCode,
            "CourseNumber": row.CourseNumber,
            "MinimumGradeRequired": row.MinimumGradeRequired,
            "StudentGrade": row.StudentGrade
        }
        for row in rows
    ]
    return {"data": results}
