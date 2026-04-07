from get_db_connection import get_db_connection

def enroll_student_in_section(
    registration_id: str,
    section_id: str
):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{CALL procEnrollStudentInSection(?, ?)}", (registration_id, section_id))
    rows = cursor.fetchall()
    conn.close()
    

    #convert rows to list of dicts
    results = [
        {
            "EnrollmentStatus": row.EnrollmentStatus,
            "LastUpdate": row.LastUpdate
        }
        for row in rows
    ]
    return {"data": results}