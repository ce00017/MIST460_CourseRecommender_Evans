from get_db_connection import get_db_connection
import pymssql

def validate_user(
    email: str = None,
    password: str = None
):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute("EXEC procValidateUser %s, %s", (email, password))
    rows = cursor.fetchall()
    conn.close()

    #convert rows to list of dicts
    results = [
        {
            "AppUserID": int(row["AppUserID"]),
            "Fullname": str(row["Fullname"])
        }
        for row in rows
    ]
    return {"data": results}
