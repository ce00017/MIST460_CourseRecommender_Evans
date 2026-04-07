from get_db_connection import get_db_connection

def register_student(
    student_id: int,
    registration_semester: str,
    registration_year: int
):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{CALL procRegisterStudent(?, ?, ?)}", (student_id, registration_semester, registration_year))
    rows = cursor.fetchall()
    conn.close()
    

    #convert rows to list of dicts
    results = [
        {
            "Registration ID": row.RegistrationID,
            "RegistrationDate": row.RegistrationDate
        }
        for row in rows
    ]
    return {"data": results}