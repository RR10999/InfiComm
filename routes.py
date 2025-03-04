from flask import render_template, request, redirect, url_for, flash
from app import app, db
from models import User, Plan, Billing, Feedback, ServiceRequest, SubscriptionHistory, SupportTicket, Transactions, UsageHistory, Amenity

# ---------------- HOME PAGE ----------------
@app.route('/')
def index():
    return render_template('index.html')

# ---------------- USER CRUD ----------------
@app.route('/user')
def list_users():
    users = User.query.all()
    return render_template('user.html', records=users)

@app.route('/user/create', methods=['GET', 'POST'])
def create_user():
    if request.method == 'POST':
        new_user = User(
            name=request.form['name'],
            email=request.form['email'],
            phone=request.form['phone'],
            user_type=request.form['user_type']
        )
        db.session.add(new_user)
        db.session.commit()
        return redirect('/user')
    return render_template('user_form.html')

@app.route('/user/edit/<int:id>', methods=['GET', 'POST'])
def edit_user(id):
    user = User.query.get(id)
    if request.method == 'POST':
        user.name = request.form['name']
        user.email = request.form['email']
        user.phone = request.form['phone']
        user.user_type = request.form['user_type']
        db.session.commit()
        return redirect('/user')
    return render_template('user_form.html', record=user)

@app.route('/user/delete/<int:id>', methods=['POST'])
def delete_user(id):
    user = User.query.get(id)
    db.session.delete(user)
    db.session.commit()
    return redirect('/user')

# ---------------- PLAN CRUD ----------------
@app.route('/plan')
def list_plans():
    plans = Plan.query.all()
    return render_template('plan.html', records=plans)

@app.route('/plan/create', methods=['GET', 'POST'])
def create_plan():
    if request.method == 'POST':
        new_plan = Plan(
            name=request.form['name'],
            price=request.form['price'],
            validity=request.form['validity'],
            data_limit=request.form['data_limit']
        )
        db.session.add(new_plan)
        db.session.commit()
        return redirect('/plan')
    return render_template('plan_form.html')

@app.route('/plan/edit/<int:id>', methods=['GET', 'POST'])
def edit_plan(id):
    plan = Plan.query.get(id)
    if request.method == 'POST':
        plan.name = request.form['name']
        plan.price = request.form['price']
        plan.validity = request.form['validity']
        plan.data_limit = request.form['data_limit']
        db.session.commit()
        return redirect('/plan')
    return render_template('plan_form.html', record=plan)

@app.route('/plan/delete/<int:id>', methods=['POST'])
def delete_plan(id):
    plan = Plan.query.get(id)
    db.session.delete(plan)
    db.session.commit()
    return redirect('/plan')

# ---------------- CRUD FOR OTHER TABLES ----------------
def generate_crud_routes(table_name, Model):
    list_func_name = f'list_{table_name}'
    create_func_name = f'create_{table_name}'
    edit_func_name = f'edit_{table_name}'
    delete_func_name = f'delete_{table_name}'

    # Define list route
    def list_func():
        records = Model.query.all()
        return render_template(f'{table_name}.html', records=records)

    # Define create route
    def create_func():
        if request.method == 'POST':
            new_record = Model(**{col: request.form[col] for col in request.form})
            db.session.add(new_record)
            db.session.commit()
            return redirect(f'/{table_name}')
        return render_template(f'{table_name}_form.html')

    # Define edit route
    def edit_func(id):
        record = Model.query.get(id)
        if request.method == 'POST':
            for col in request.form:
                setattr(record, col, request.form[col])
            db.session.commit()
            return redirect(f'/{table_name}')
        return render_template(f'{table_name}_form.html', record=record)

    # Define delete route
    def delete_func(id):
        record = Model.query.get(id)
        db.session.delete(record)
        db.session.commit()
        return redirect(f'/{table_name}')

    # Register routes dynamically
    app.add_url_rule(f'/{table_name}', list_func_name, list_func, methods=['GET'])
    app.add_url_rule(f'/{table_name}/create', create_func_name, create_func, methods=['GET', 'POST'])
    app.add_url_rule(f'/{table_name}/edit/<int:id>', edit_func_name, edit_func, methods=['GET', 'POST'])
    app.add_url_rule(f'/{table_name}/delete/<int:id>', delete_func_name, delete_func, methods=['POST'])

# Generate routes for remaining tables
tables = {
    "billing": Billing, "feedback": Feedback, "service_request": ServiceRequest,
    "subscription_history": SubscriptionHistory, "support_ticket": SupportTicket,
    "transactions": Transactions, "usage_history": UsageHistory, "amenity": Amenity
}

for table_name, Model in tables.items():
    generate_crud_routes(table_name, Model)
