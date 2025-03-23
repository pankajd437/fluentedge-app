from flask import Blueprint

bp = Blueprint('auth', __name__)  # ✅ Define Blueprint properly

@bp.route('/login')
def login():
    return "Login Page"
