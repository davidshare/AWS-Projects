#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install -y python3 python3-pip postgresql-client

# Create Python virtual environment
python3 -m venv phonebook-env
source phonebook-env/bin/activate

# Install Python dependencies
pip install flask psycopg2

# Create the Python file
cat > phonebook_api.py <<EOF
from flask import Flask, jsonify, request
import psycopg2

app = Flask(__name__)

# Database connection details
DB_HOST = "localhost"
DB_NAME = "phonebook"
DB_USER = "your_username"
DB_PASSWORD = "your_password"

# Create the database table if it doesn't exist
conn = psycopg2.connect(
    host=DB_HOST,
    database=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD
)
cur = conn.cursor()
cur.execute("""
    CREATE TABLE IF NOT EXISTS phonebook (
        id SERIAL PRIMARY KEY,
        firstname TEXT,
        lastname TEXT,
        email TEXT,
        phone TEXT,
        address TEXT,
        city TEXT,
        country TEXT
    )
""")
conn.commit()
conn.close()

# API endpoints
@app.route('/phonebook', methods=['POST'])
def create_entry():
    data = request.get_json()
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cur = conn.cursor()
    cur.execute("INSERT INTO phonebook (firstname, lastname, email, phone, address, city, country) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (data['firstname'], data['lastname'], data['email'], data['phone'], data['address'], data['city'], data['country']))
    conn.commit()
    conn.close()
    return jsonify(data), 201

@app.route('/phonebook', methods=['GET'])
def get_all_entries():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cur = conn.cursor()
    cur.execute("SELECT * FROM phonebook")
    entries = [{'id': row[0], 'firstname': row[1], 'lastname': row[2], 'email': row[3], 'phone': row[4], 'address': row[5], 'city': row[6], 'country': row[7]} for row in cur.fetchall()]
    conn.close()
    return jsonify(entries)

@app.route('/phonebook/<int:entry_id>', methods=['GET'])
def get_entry(entry_id):
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cur = conn.cursor()
    cur.execute("SELECT * FROM phonebook WHERE id = %s", (entry_id,))
    row = cur.fetchone()
    if row:
        entry = {'id': row[0], 'firstname': row[1], 'lastname': row[2], 'email': row[3], 'phone': row[4], 'address': row[5], 'city': row[6], 'country': row[7]}
        conn.close()
        return jsonify(entry)
    else:
        conn.close()
        return jsonify({'error': 'Entry not found'}), 404

@app.route('/phonebook/<int:entry_id>', methods=['PUT'])
def update_entry(entry_id):
    data = request.get_json()
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cur = conn.cursor()
    cur.execute("UPDATE phonebook SET firstname = %s, lastname = %s, email = %s, phone = %s, address = %s, city = %s, country = %s WHERE id = %s",
                (data['firstname'], data['lastname'], data['email'], data['phone'], data['address'], data['city'], data['country'], entry_id))
    conn.commit()
    conn.close()
    return jsonify(data)

@app.route('/phonebook/<int:entry_id>', methods=['DELETE'])
def delete_entry(entry_id):
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cur = conn.cursor()
    cur.execute("DELETE FROM phonebook WHERE id = %s", (entry_id,))
    conn.commit()
    conn.close()
    return jsonify({'message': 'Entry deleted'}), 204

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Start the API
flask run --host=0.0.0.0