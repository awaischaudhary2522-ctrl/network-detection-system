import os
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = int(os.getenv('DB_PORT', '5433'))
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'admin123')
DB_NAME = os.getenv('DB_NAME', 'network_monitor')
FLASK_DEBUG = os.getenv('FLASK_DEBUG', '1') == '1'
FLASK_PORT = int(os.getenv('FLASK_PORT', '5000'))
