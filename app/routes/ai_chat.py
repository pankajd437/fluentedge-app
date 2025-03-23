from flask import Blueprint

bp = Blueprint('ai_chat', __name__)

@bp.route('/chat')
def chat():
    return "AI Chat Page"
