from get_db_connection import get_db_connection

def get_all_jobs():
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute("EXEC procGetAllJobs")
    rows = cursor.fetchall()
    conn.close()

    results = [
        {
            "JobID": row["JobID"],
            "JobTitle": row["JobTitle"],
            "Industry": row["Industry"],
            "JobDescription": row["JobDescription"],
        }
        for row in rows
    ]
    return {"data": results}
