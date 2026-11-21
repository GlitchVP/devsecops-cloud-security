import os
import sqlite3
from flask import Flask, request

app = Flask(__name__)

# ВИПРАВЛЕНО: Секрет не зберігається в коді, а отримується динамічно зі змінних середовища (від Vault)
API_SECRET_KEY = os.environ.get("API_SECRET_KEY")

@app.route("/")
def index():
    return "<h1>Cloud Infrastructure Status: SECURE & RUNNING</h1><p>DevSecOps Coursework Demo</p>"

@app.route("/user")
def get_user():
    username = request.args.get("name", "guest")
    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE users (name TEXT)")
    cursor.execute("INSERT INTO users VALUES ('admin')")

    # ВИПРАВЛЕНО: Параметризований запит захищає від SQL-ін'єкцій
    cursor.execute("SELECT * FROM users WHERE name = ?", (username,))
    result = cursor.fetchall()
    return {"user": result}

if __name__ == "__main__":
    # ВИПРАВЛЕНО: Debug-режим вимкнено для безпеки продакшену
    app.run(host="0.0.0.0", port=5000, debug=False)
