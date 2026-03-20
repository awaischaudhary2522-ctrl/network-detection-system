import subprocess
import os

# start flask
flask_process = subprocess.Popen(['sudo', 'python3', 'backend/api.py'])

# start avalonia
subprocess.run(
    ['./frontend/NetworkDetectionUI/bin/Debug/net8.0/NetworkDetectionUI'])

# when avalonia closes, kill flask
flask_process.terminate()
