from flask import Blueprint, jsonify

saludo_bp = Blueprint("saludo", __name__)

@saludo_bp.route("/api/saludo")
def saludo():
    return jsonify({
        "mensaje":"Hola desde la API",
        "autor":"Flask"
    })