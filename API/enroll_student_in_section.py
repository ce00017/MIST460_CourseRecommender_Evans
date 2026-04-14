from get_db_connection import get_db_connection
import pymssql

def enroll_student_in_section(
    registration_id: str,
    section_id: str
):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute("EXEC procEnrollStudentInSection %s, %s", (registration_id, section_id))
    rows = cursor.fetchall()
    conn.close()
    

    #convert rows to list of dicts
    results = [
        {
            "EnrollmentStatus": row["EnrollmentStatus"],
            "LastUpdate": row["LastUpdate"]
        }
        for row in rows
    ]
    return {"data": results}