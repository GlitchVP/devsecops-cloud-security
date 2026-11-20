import os
import sqlite3
from flask import Flask, request

app = Flask(__name__)

# ВРАЗЛИВІСТЬ 1 (для SAST): Жорстко вшитий секрет у коді
API_SECRET_KEY = "super_secret_admin_token_12345"

@app.route("/")
def index():
    return "<h1>Cloud Infrastructure Status: RUNNING</h1><p>DevSecOps Coursework Demo</p>"

@app.route("/user")
def get_user():
    username = request.args.get("name", "guest")
    # ВРАЗЛИВІСТЬ 2 (для SAST): Потенційна SQL-ін'єкція через форматування рядка
    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE users (name TEXT)")
    cursor.execute("INSERT INTO users VALUES ('admin')")
    query = f"SELECT * FROM users WHERE name = '{username}'"
    cursor.execute(query)
    result = cursor.fetchall()
    return {"user": result}

if __name__ == "__main__":
    # ВРАЗЛИВІСТЬ 3 (для SAST/DAST): Debug-режим у продакшені
    app.run(host="0.0.0.0", port=5000, debug=True)
