from get_db_connection import get_db_connection
import pymssql

def register_student(
    student_id: int,
    registration_semester: str,
    registration_year: int
):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute("EXEC procRegisterStudent %s, %s, %s", (student_id, registration_semester, registration_year))
    rows = cursor.fetchall()
    conn.close()
    

    #convert rows to list of dicts
    results = [
        {
            "Registration ID": row["RegistrationID"],
            "RegistrationDate": row["RegistrationDate"]
        }
        for row in rows
    ]
    return {"data": results}