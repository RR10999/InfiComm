from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector

app = Flask(__name__)
app.secret_key = "supersecretkey"

# Database Connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="BSHitman@999",
    database="InfiComm"
)
cursor = db.cursor(dictionary=True)

# Admin Login Page
@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        password = request.form["password"]
        if password == "admin123":  # Change this to your actual password
            session["admin"] = True
            return redirect(url_for("dashboard"))
        else:
            return render_template("InfiComm.html", error="Incorrect password")
    return render_template("InfiComm.html")

# Dashboard Listing All Tables
@app.route("/dashboard")
def dashboard():
    if not session.get("admin"):
        return redirect(url_for("login"))
    tables = ["user", "customer", "plan", "enrolled_plan", "amenity", "customer_amenity",
              "bill", "payment", "traffic", "support_ticket", "recharge", "role",
              "user_role", "network_tower", "service_request"]
    return render_template("InfiComm.html", tables=tables)

# CRUD Operations for All Tables
@app.route("/table/<table_name>")
def manage_table(table_name):
    if not session.get("admin"):
        return redirect(url_for("login"))
    cursor.execute(f"SELECT * FROM {table_name}")
    records = cursor.fetchall()
    return render_template("InfiComm.html", table_name=table_name, records=records)

# Add Record
@app.route("/add/<table_name>", methods=["POST"])
def add_record(table_name):
    columns = request.form.keys()
    values = tuple(request.form.values())
    placeholders = ", ".join(["%s"] * len(values))
    cursor.execute(f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({placeholders})", values)
    db.commit()
    return redirect(url_for("manage_table", table_name=table_name))

# Update Record
@app.route("/update/<table_name>/<int:record_id>", methods=["POST"])
def update_record(table_name, record_id):
    updates = ", ".join([f"{key}=%s" for key in request.form.keys()])
    values = tuple(request.form.values()) + (record_id,)
    primary_key = table_name + "_id"
    cursor.execute(f"UPDATE {table_name} SET {updates} WHERE {primary_key} = %s", values)
    db.commit()
    return redirect(url_for("manage_table", table_name=table_name))

# Delete Record
@app.route("/delete/<table_name>/<int:record_id>", methods=["POST"])
def delete_record(table_name, record_id):
    primary_key = table_name + "_id"
    cursor.execute(f"DELETE FROM {table_name} WHERE {primary_key} = %s", (record_id,))
    db.commit()
    return redirect(url_for("manage_table", table_name=table_name))

# Search Records
@app.route("/search/<table_name>", methods=["POST"])
def search_records(table_name):
    column = request.form["column"]
    value = request.form["value"]
    cursor.execute(f"SELECT * FROM {table_name} WHERE {column} LIKE %s", (f"%{value}%",))
    results = cursor.fetchall()
    return render_template("InfiComm.html", table_name=table_name, records=results)

if __name__ == "__main__":
    app.run(debug=True)
