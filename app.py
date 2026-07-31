from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "¡Hola, mundo! Mi primer servidor Flask."

@app.route("/api/saludo")
def saludo():
    return jsonify({
        "mensaje": "Hola desde la API",
        "autor":"Flask"
    })

if __name__ =="__main__":
    app.run(debug=True)