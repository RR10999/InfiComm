from flask import Flask, render_template, request, redirect, url_for, session, g, jsonify
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

# 🔹 LOGIN PAGE
@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        password = request.form.get("password")
        if password == os.getenv("ADMIN_PASSWORD", "admin123"):
            session["admin"] = True
            return redirect(url_for("dashboard"))
    return render_template("login.html", error="Incorrect password" if request.method == "POST" else None)

# 🔹 LOGOUT ROUTE (Fix for BuildError)
@app.route("/logout")
def logout():
    session.pop("admin", None)  # Log out the user
    return redirect(url_for("login"))

# 🔹 DASHBOARD (Shows Users)
@app.route("/dashboard")
def dashboard():
    if not session.get("admin"):
        return redirect(url_for("login"))

    db, cursor = get_db()
    cursor.execute("""
        SELECT user.user_id, user.name, user.phone, plan.name AS enrolled_plan, plan.price
        FROM user
        LEFT JOIN enrolled_plan ON user.user_id = enrolled_plan.user_id
        LEFT JOIN plan ON enrolled_plan.plan_id = plan.plan_id
    """)
    users_with_plans = cursor.fetchall()
    return render_template("InfiComm.html", users_with_plans=users_with_plans)

# 🔹 ADD USER
@app.route("/add_user", methods=["POST"])
def add_user():
    db, cursor = get_db()
    data = request.json
    cursor.execute("INSERT INTO user (name, phone) VALUES (%s, %s)", (data["name"], data["phone"]))
    db.commit()
    return jsonify({"success": True})

# 🔹 UPDATE USER
@app.route("/update_user/<int:user_id>", methods=["POST"])
def update_user(user_id):
    db, cursor = get_db()
    data = request.json
    cursor.execute("""
        UPDATE user
        SET phone = %s
        WHERE user_id = %s
    """, (data["phone"], user_id))

    cursor.execute("""
        UPDATE plan
        SET name = %s, price = %s
        WHERE plan_id = (SELECT plan_id FROM enrolled_plan WHERE user_id = %s)
    """, (data["plan"], data["price"], user_id))

    db.commit()
    return jsonify({"success": True})

# 🔹 FETCH FULL USER DETAILS
@app.route("/user/<int:user_id>")
def user_details(user_id):
    db, cursor = get_db()
    cursor.execute("""
        SELECT user.*, plan.name AS enrolled_plan, plan.price 
        FROM user
        LEFT JOIN enrolled_plan ON user.user_id = enrolled_plan.user_id
        LEFT JOIN plan ON enrolled_plan.plan_id = plan.plan_id
        WHERE user.user_id = %s
    """, (user_id,))
    user_data = cursor.fetchone()
    
    return jsonify(user_data)

# 🔹 DELETE USER
@app.route("/delete_user/<int:user_id>", methods=["POST"])
def delete_user(user_id):
    db, cursor = get_db()
    cursor.execute("DELETE FROM user WHERE user_id = %s", (user_id,))
    db.commit()
    return jsonify({"success": True})

if __name__ == "__main__":
    app.run(debug=True)
