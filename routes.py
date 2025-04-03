from flask import render_template, request, redirect, url_for, flash, session
from app import app, db
from models import User, Plan, Billing, Feedback, ServiceRequest, SubscriptionHistory, SupportTicket, Transactions, UsageHistory, Amenity

# Secret key for session management
app.secret_key = "your_secret_key_here"  # Change this to a secure value

# Hardcoded admin credentials
VALID_USERNAME = "admin"
VALID_PASSWORD = "password"

# ---------------- LOGIN ROUTES ----------------
@app.route("/", methods=["GET"])
def index():
    """Render the login page"""
    return render_template("index.html")


@app.route("/login", methods=["POST"])
def login():
    """Process the login form submission"""
    username = request.form.get("username")
    password = request.form.get("password")

    if username == VALID_USERNAME and password == VALID_PASSWORD:
        session["logged_in"] = True
        return redirect(url_for("dashboard"))
    else:
        flash("Invalid credentials", "danger")
        return redirect(url_for("index"))


@app.route("/logout")
def logout():
    """Logout user and clear session"""
    session.pop("logged_in", None)
    return redirect(url_for("index"))


# ---------------- DASHBOARD ----------------
@app.route("/dashboard")
def dashboard():
    """Render the dashboard after login"""
    if not session.get("logged_in"):
        return redirect(url_for("index"))

    tables = {
        "user": "Users",
        "plan": "Plans",
        "billing": "Billing",
        "feedback": "Feedback",
        "service_request": "Service Requests",
        "subscription_history": "Subscription History",
        "support_ticket": "Support Tickets",
        "transactions": "Transactions",
        "usage_history": "Usage History",
        "amenity": "Amenities",
    }

    return render_template("dashboard.html", tables=tables)


# ---------------- GENERIC CRUD ROUTES ----------------
def generate_crud_routes(table_name, Model):
    """Dynamically generates CRUD routes for models."""

    def unique_route(endpoint_name, route_path, methods, view_func):
        """Ensure unique function names for Flask routes."""
        view_func.__name__ = endpoint_name
        app.route(route_path, methods=methods)(view_func)

    # List Route
    def list_records():
        return render_template(
            "generic_list.html",
            records=Model.query.all(),
            columns=Model.__table__.columns.keys(),
            entity=table_name,
            getattr=getattr,
        )

    unique_route(f"list_{table_name}", f"/{table_name}", ["GET"], list_records)

    # Create Route
    def create():
        columns = Model.__table__.columns.keys()
        if request.method == "POST":
            try:
                new_record = Model(
                    **{col: request.form[col] for col in columns if col in request.form}
                )
                db.session.add(new_record)
                db.session.commit()
                return redirect(url_for(f"list_{table_name}"))
            except Exception as e:
                db.session.rollback()
                flash(f"Error: {str(e)}", "danger")

        return render_template(
            "generic_form.html", columns=columns, entity=table_name, getattr=getattr
        )

    unique_route(f"create_{table_name}", f"/{table_name}/create", ["GET", "POST"], create)

    # Edit Route
    def edit(id):
        record = Model.query.get(id)
        columns = Model.__table__.columns.keys()
        if request.method == "POST":
            for col in columns:
                if col in request.form:
                    setattr(record, col, request.form[col])
            db.session.commit()
            return redirect(url_for(f"list_{table_name}"))

        return render_template(
            "generic_form.html", record=record, columns=columns, entity=table_name, getattr=getattr
        )

    unique_route(f"edit_{table_name}", f"/{table_name}/edit/<int:id>", ["GET", "POST"], edit)

    # Delete Route
    def delete(id):
        record = Model.query.get(id)
        db.session.delete(record)
        db.session.commit()
        return redirect(url_for(f"list_{table_name}"))

    unique_route(f"delete_{table_name}", f"/{table_name}/delete/<int:id>", ["POST"], delete)


# Generate routes dynamically for all tables
tables = {
    "user": User,
    "plan": Plan,
    "billing": Billing,
    "feedback": Feedback,
    "service_request": ServiceRequest,
    "subscription_history": SubscriptionHistory,
    "support_ticket": SupportTicket,
    "transactions": Transactions,
    "usage_history": UsageHistory,
    "amenity": Amenity,
}

for table_name, Model in tables.items():
    generate_crud_routes(table_name, Model)
