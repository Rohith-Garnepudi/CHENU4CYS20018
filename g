from flask import Flask, jsonify
import sqlite3
from datetime import datetime, timedelta

app = Flask(__name__)

# Connect to the SQLite database
db_connection = sqlite3.connect('trains.db')
db_cursor = db_connection.cursor()

@app.route('/trains', methods=['GET'])
def get_trains():
    current_time = datetime.now()
    twelve_hours_later = current_time + timedelta(hours=12)

    query = "SELECT * FROM trains WHERE departure_time BETWEEN ? AND ?"
    db_cursor.execute(query, (current_time, twelve_hours_later))
    trains = db_cursor.fetchall()

    train_list = []
    for train in trains:
        train_dict = {
            'departure_time': train[0],
            'destination': train[1],
            # Add other train attributes here
        }
        train_list.append(train_dict)

    return jsonify(train_list)

if __name__ == '__main__':
    app.run(debug=True)
