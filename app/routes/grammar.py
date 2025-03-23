from flask import Blueprint

bp = Blueprint('grammar', __name__)

@bp.route('/grammar')
def grammar():
    return "Grammar Page"
