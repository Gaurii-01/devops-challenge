from flask import Flask, jsonify


app = Flask(__name__)


@app.route("/")
def root():
    return jsonify(message="Hello, Candidate", version="1.0.0")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
