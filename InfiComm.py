from flask import Flask, render_template, request, redirect, url_for, session, g
import mysql.connector
import os

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "supersecretkey")  # Use environment variable

# Database Connection Function
def get_db():
    if 'db' not in g:
        g.db = mysql.connector.connect(
            host=os.getenv("DB_HOST", "localhost"),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASS", "BSHitman@999"),
            database=os.getenv("DB_NAME", "InfiComm")
        )
        g.cursor = g.db.cursor(dictionary=True)
    return g.db, g.cursor

@app.before_request
def before_request():
    get_db()

@app.teardown_appcontext
def close_connection(exception):
    db = g.pop('db', None)
    if db is not None:
        db.close()

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        password = request.form.get("password")
        if password == os.getenv("ADMIN_PASSWORD", "admin123"):
            session["admin"] = True
            return redirect(url_for("dashboard"))
        return render_template("InfiComm.html", error="Incorrect password")
    return render_template("InfiComm.html")

@app.route("/dashboard")
def dashboard():
    if not session.get("admin"):
        return redirect(url_for("login"))
    tables = ["user", "customer", "plan", "enrolled_plan", "amenity", "customer_amenity",
              "bill", "payment", "traffic", "support_ticket", "recharge", "role",
              "user_role", "network_tower", "service_request"]
    return render_template("InfiComm.html", tables=tables)

@app.route("/table/<table_name>")
def manage_table(table_name):
    if not session.get("admin"):
        return redirect(url_for("login"))
    
    db, cursor = get_db()
    try:
        cursor.execute("SELECT * FROM {}".format(table_name))
        records = cursor.fetchall()
    except mysql.connector.Error:
        return "Invalid table name", 400
    
    return render_template("InfiComm.html", table_name=table_name, records=records)

@app.route("/add/<table_name>", methods=["POST"])
def add_record(table_name):
    db, cursor = get_db()
    columns = request.form.keys()
    values = tuple(request.form.values())
    placeholders = ", ".join(["%s"] * len(values))
    query = "INSERT INTO {} ({}) VALUES ({})".format(table_name, ", ".join(columns), placeholders)
    cursor.execute(query, values)
    db.commit()
    return redirect(url_for("manage_table", table_name=table_name))

@app.route("/update/<table_name>/<int:record_id>", methods=["POST"])
def update_record(table_name, record_id):
    db, cursor = get_db()
    updates = ", ".join(["{}=%s".format(key) for key in request.form.keys()])
    values = tuple(request.form.values()) + (record_id,)
    primary_key = table_name + "_id"
    query = "UPDATE {} SET {} WHERE {} = %s".format(table_name, updates, primary_key)
    cursor.execute(query, values)
    db.commit()
    return redirect(url_for("manage_table", table_name=table_name))

@app.route("/delete/<table_name>/<int:record_id>", methods=["POST"])
def delete_record(table_name, record_id):
    db, cursor = get_db()
    primary_key = table_name + "_id"
    query = "DELETE FROM {} WHERE {} = %s".format(table_name, primary_key)
    cursor.execute(query, (record_id,))
    db.commit()
    return redirect(url_for("manage_table", table_name=table_name))

@app.route("/search/<table_name>", methods=["POST"])
def search_records(table_name):
    db, cursor = get_db()
    column = request.form.get("column")
    value = request.form.get("value")
    query = "SELECT * FROM {} WHERE {} LIKE %s".format(table_name, column)
    cursor.execute(query, ("%" + value + "%",))
    results = cursor.fetchall()
    return render_template("InfiComm.html", table_name=table_name, records=results)

if __name__ == "__main__":
    app.run(debug=True)
