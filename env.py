import logging
from logging.config import fileConfig

from flask import current_app
from alembic import context

# Load Alembic config object
config = context.config

# Set up logging from the config file
fileConfig(config.config_file_name)
logger = logging.getLogger('alembic.env')


def get_engine():
    """
    Get the correct SQLAlchemy engine from Flask-Migrate.
    Supports both Flask-SQLAlchemy <3 and Flask-SQLAlchemy >=3.
    """
    try:
        return current_app.extensions['migrate'].db.get_engine()
    except (TypeError, AttributeError):
        return current_app.extensions['migrate'].db.engine


def get_engine_url():
    """
    Get the correct database connection URL.
    Ensures PostgreSQL connection is used instead of SQLite.
    """
    try:
        return get_engine().url.render_as_string(hide_password=False).replace('%', '%%')
    except AttributeError:
        return str(get_engine().url).replace('%', '%%')


# Set SQLAlchemy database URL dynamically
config.set_main_option('sqlalchemy.url', get_engine_url())

# Get metadata from the Flask app's database
target_db = current_app.extensions['migrate'].db


def get_metadata():
    """Retrieve metadata for migration autogeneration."""
    if hasattr(target_db, 'metadatas'):
        return target_db.metadatas[None]
    return target_db.metadata


def run_migrations_offline():
    """Run migrations in offline mode (without a live database connection)."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url, target_metadata=get_metadata(), literal_binds=True
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    """Run migrations in online mode (with a live database connection)."""

    def process_revision_directives(context, revision, directives):
        """
        Prevents empty migrations from being generated.
        """
        if getattr(config.cmd_opts, 'autogenerate', False):
            script = directives[0]
            if script.upgrade_ops.is_empty():
                directives[:] = []
                logger.info('No changes in schema detected.')

    conf_args = current_app.extensions['migrate'].configure_args
    if conf_args.get("process_revision_directives") is None:
        conf_args["process_revision_directives"] = process_revision_directives

    connectable = get_engine()

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=get_metadata(),
            **conf_args
        )

        with context.begin_transaction():
            context.run_migrations()


# Determine migration mode (Offline or Online)
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
