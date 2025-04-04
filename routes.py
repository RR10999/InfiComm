from flask import render_template, request, redirect, url_for, flash, session
from app import app, db
from models import Amenity, Billing, Feedback, Plan, SubscriptionHistory, ServiceRequest, SupportTicket, Transactions, UsageHistory, User
from sqlalchemy import or_, desc
app.secret_key = "your_secret_key_here" 
VALID_USERNAME = "admin"
VALID_PASSWORD = "password"
@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")
@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username")
    password = request.form.get("password")
    if username == VALID_USERNAME and password == VALID_PASSWORD:
        session["logged_in"] = True
        return redirect(url_for("dashboard"))
    else:
        flash("Invalid username or password", "error")
        return redirect(url_for("index"))
@app.route("/logout")
def logout():
    session.pop("logged_in", None)
    return redirect(url_for("index"))
@app.route("/dashboard")
def dashboard():
    if not session.get("logged_in"):
        return redirect(url_for("index"))
    tables = {
        "amenity": "Amenities",
        "billing": "Billing",
        "feedback": "Feedback",
        "plan": "Plans",
        "subscription_history": "Subscription History",
        "service_request": "Service Requests",
        "support_ticket": "Support Tickets",
        "transactions": "Transactions",
        "usage_history": "Usage History",
        "user": "Users"
    }
    return render_template("dashboard.html", tables=tables)
def generate_crud_routes(table_name, Model):
    def unique_route(endpoint_name, route_path, methods, view_func):
        view_func.__name__ = endpoint_name
        app.route(route_path, methods=methods)(view_func)
    def list_records():
        search_query = request.args.get('search', '').strip()
        sort_by = request.args.get('sort_by', 'id')
        sort_order = request.args.get('sort_order', 'asc')
        column_names = Model.__table__.columns.keys()
        query = Model.query
        if search_query:
            search_filters = [
                getattr(Model, col).ilike(f"%{search_query}%")
                for col in column_names
            ]
            query = query.filter(or_(*search_filters))
        if sort_by in column_names:
            sort_column = getattr(Model, sort_by)
            if sort_order == 'desc':
                sort_column = desc(sort_column)
            query = query.order_by(sort_column)
        records = query.all()
        return render_template(
            "generic_list.html",
            records=records,
            columns=column_names,
            entity=table_name,
            search_query=search_query,
            sort_by=sort_by,
            sort_order=sort_order,
            getattr=getattr
        )
    unique_route(f"list_{table_name}", f"/{table_name}", ["GET"], list_records)
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
        return render_template("generic_form.html", columns=columns, entity=table_name, getattr=getattr)
    unique_route(f"create_{table_name}", f"/{table_name}/create", ["GET", "POST"], create)
    def edit(id):
        record = Model.query.get(id)
        columns = Model.__table__.columns.keys()
        if request.method == "POST":
            for col in columns:
                if col in request.form:
                    setattr(record, col, request.form[col])
            db.session.commit()
            return redirect(url_for(f"list_{table_name}"))
        return render_template("generic_form.html", record=record, columns=columns, entity=table_name, getattr=getattr)
    unique_route(f"edit_{table_name}", f"/{table_name}/edit/<int:id>", ["GET", "POST"], edit)
    def delete(id):
        record = Model.query.get(id)
        db.session.delete(record)
        db.session.commit()
        return redirect(url_for(f"list_{table_name}"))
    unique_route(f"delete_{table_name}", f"/{table_name}/delete/<int:id>", ["POST"], delete)
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