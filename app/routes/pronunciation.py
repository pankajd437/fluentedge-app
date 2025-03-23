from flask import Blueprint

bp = Blueprint('pronunciation', __name__)

@bp.route('/pronunciation')
def pronunciation():
    return "Pronunciation Page"
