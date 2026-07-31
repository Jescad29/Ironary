from flask import Flask
from app.routes.saludo import saludo_bp

def create_app():
    """
    create_app() es una función que construye y devuelve una instancia de Flask 
    ya configurada, en vez de crearla directamente al importar el 
    módulo (como hacíamos antes con app = Flask(__name__) 
    suelto en app.py). register_blueprint() conecta las rutas del 
    blueprint a esta instancia.
    """
    app = Flask(__name__)
    app.register_blueprint(saludo_bp)
    return app