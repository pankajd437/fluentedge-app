from flask import Flask
from config import Config
from .database import db  # ✅ Import db correctly
from flask_migrate import Migrate

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize database
    db.init_app(app)
    
    # Initialize Flask-Migrate
    migrate = Migrate(app, db)

    # Import and register blueprints
    from app.routes import auth, grammar, pronunciation, ai_chat
    
    app.register_blueprint(auth.bp)
    app.register_blueprint(grammar.bp)
    app.register_blueprint(pronunciation.bp)
    app.register_blueprint(ai_chat.bp)

    return app

app = create_app()  # ✅ Ensure app is created properly
