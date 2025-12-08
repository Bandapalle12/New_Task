from flask import Flask
import pymysql

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World from ECS → RDS!"

app.run(host="0.0.0.0", port=5000)
