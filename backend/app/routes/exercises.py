from flask import Blueprint, jsonify, request
from app.db.exercises import get_all_exercises, create_exercise

exercises_bp = Blueprint("exercises", __name__)

@exercises_bp.route("/api/exercises", methods=["GET"])
def list_exercises():
    exercises = get_all_exercises()
    return jsonify(exercises)

@exercises_bp.route("/api/exercises", methods=["POST"])
def add_exercise():
    data = request.get_json()
    create_exercise(data["name"], data.get("muscleGroup"))
    return jsonify({"message": "Ejercicio creado"}), 201

