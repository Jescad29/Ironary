from flask import Blueprint, jsonify
from app.db.connection import get_connection

db_test_bp = Blueprint("db_test", __name__)

@db_test_bp.route("/api/db-test")
def db_test():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sys.tables ORDER BY name;")
    tablas = [fila[0] for fila in cursor.fetchall()]
    conn.close()
    return jsonify({"tablas": tablas})

