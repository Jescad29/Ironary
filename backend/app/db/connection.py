import os 
import pyodbc
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    connection_string = (
        f"DRIVER={os.environ['DB_DRIVER']};"
        f"SERVER={os.environ['DB_SERVER']};"
        f"DATABASE={os.environ['DB_DATABASE']};"
        "Trusted_Connection=yes;"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
    )
    return pyodbc.connect(connection_string)