from app import db
from datetime import datetime
class Amenity(db.Model):
    amenity_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    @property
    def id(self):
        return self.amenity_id  
class Billing(db.Model):
    billing_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    amount_due = db.Column(db.Numeric(10,2), nullable=False)
    status = db.Column(db.String(20), nullable=False)
    due_date = db.Column(db.DateTime, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    @property
    def id(self):
        return self.billing_id
class Feedback(db.Model):
    feedback_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    comments = db.Column(db.Text, nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    @property
    def id(self):
        return self.feedback_id
class Plan(db.Model):
    plan_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Numeric(10,2), nullable=False)
    validity = db.Column(db.Integer, nullable=False)  
    data_limit = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    subscriptions = db.relationship('SubscriptionHistory', backref='plan', lazy=True)
    @property
    def id(self):
        return self.plan_id
class ServiceRequest(db.Model):
    service_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    service_type = db.Column(db.String(100))
    status = db.Column(db.String(20))
    requested_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    @property
    def id(self):
        return self.service_id
class SubscriptionHistory(db.Model):
    subscription_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    plan_id = db.Column(db.Integer, db.ForeignKey('plan.plan_id'), nullable=False)
    start_date = db.Column(db.DateTime, default=datetime.utcnow)
    end_date = db.Column(db.DateTime, nullable=False)
    @property
    def id(self):
        return self.subscription_id
class SupportTicket(db.Model):
    support_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    subject = db.Column(db.String(255), nullable=False)
    message = db.Column(db.Text, nullable=False)
    status = db.Column(db.String(20), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    @property
    def id(self):
        return self.support_id
class Transactions(db.Model):
    transactions_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    transaction_type = db.Column(db.String(50), nullable=False)
    amount = db.Column(db.Numeric(10,2), nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    @property
    def id(self):
        return self.transactions_id
class UsageHistory(db.Model):
    usage_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    data_used = db.Column(db.String(50), nullable=False)
    usage_date = db.Column(db.DateTime, default=datetime.utcnow)
    @property
    def id(self):
        return self.usage_id
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    user_type = db.Column(db.Enum('customer', 'admin'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    billings = db.relationship('Billing', backref='user', lazy=True)
    feedbacks = db.relationship('Feedback', backref='user', lazy=True)
    service_requests = db.relationship('ServiceRequest', backref='user', lazy=True)
    subscriptions = db.relationship('SubscriptionHistory', backref='user', lazy=True)
    support_tickets = db.relationship('SupportTicket', backref='user', lazy=True)
    transactions = db.relationship('Transactions', backref='user', lazy=True)
    usage_histories = db.relationship('UsageHistory', backref='user', lazy=True)