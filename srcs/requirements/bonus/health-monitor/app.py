from flask import Flask, jsonify, send_from_directory
import time
import socket

app = Flask(__name__)
start_time = time.time()

def check_port(host, port, timeout=1):
    try:
        with socket.create_connection((host, port), timeout):
            return True
    except Exception:
        return False

@app.route("/health")
def health():
    uptime = time.time() - start_time
    with open("/proc/uptime") as f:
        sys_uptime = float(f.readline().split()[0])

    services = {
        "wordpress": ("wordpress", 9000),
        "redis": ("redis", 6379),
        "mariadb": ("mariadb", 3306)
    }

    status = {name: check_port(host, port) for name, (host, port) in services.items()}

    return jsonify({
        "service": "health-monitor",
        "app_uptime_seconds": int(uptime),
        "system_uptime_seconds": int(sys_uptime),
        "services_status": status
    })

@app.route("/")
def dashboard():
    return send_from_directory('.', 'dashboard.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
