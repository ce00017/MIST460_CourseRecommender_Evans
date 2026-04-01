from get_db_connection import get_db_connection

def validate_user(
    email: str = None,
    password: str = None
):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{CALL procValidateUser(?, ?)}", (email, password))
    rows = cursor.fetchall()
    conn.close()

    #convert rows to list of dicts
    results = [
        {
            "AppUserID": int(row.AppUserID),
            "Fullname": str(row.Fullname)
        }
        for row in rows
    ]
    return {"data": results}
