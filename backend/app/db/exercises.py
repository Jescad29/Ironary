from app.db.connection import get_connection

def get_all_exercises():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT Id, Name, MuscleGroup FROM Exercises ORDER BY Name;")
    rows = cursor.fetchall()
    conn.close()

    return [
        {"id": row.Id, "name": row.Name, "muscleGroup": row.MuscleGroup}
        for row in rows
    ]

def create_exercise(name, muscle_group):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Exercises (Name, MuscleGroup) VALUES (?, ?);",
        name, muscle_group
    )
    conn.commit()
    conn.close()