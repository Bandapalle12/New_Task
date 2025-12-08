from flask import Flask
import mysql.connector
import os

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST")
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_NAME = os.environ.get("DB_NAME")

@app.route("/")
def hello():
    return "Hello World from ECS!"

@app.route("/db")
def db_test():
    try:
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME
        )
        cursor = conn.cursor()
        cursor.execute("SELECT NOW();")
        result = cursor.fetchone()
        return f"Database Connected! Time: {result}"
    except Exception as e:
        return str(e)

app.run(host='0.0.0.0', port=5000)
