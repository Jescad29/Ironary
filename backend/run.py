"""
Ruta: backend\app\run.py
Nombre archivo: run.py
Descripción:Este es el único archivo que se ejecuta directamente (python run.py). Importa la función factory, construye la app, y la arranca.
Lenguaje: Python
"""

from app import create_app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)