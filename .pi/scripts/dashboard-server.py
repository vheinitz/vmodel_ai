#!/usr/bin/env python3
"""
V-Model XT — Bidirectional Dashboard Server
Serves the dashboard and accepts prompts to launch pi coding agent.

Usage:
    python3 .pi/scripts/dashboard-server.py          # Start server on :8080
    python3 .pi/scripts/dashboard-server.py --port 9000
    python3 .pi/scripts/dashboard-server.py --no-exec  # Dry run (show commands)
"""

import http.server
import json
import os
import subprocess
import sys
import urllib.parse
import webbrowser
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
DASHBOARD_DIR = PROJECT_ROOT / "dashboard"
DATA_DIR = DASHBOARD_DIR / "data"
HISTORY_FILE = DATA_DIR / "history.json"
PORT = 8080
DRY_RUN = False


def log_activity(agent, action, details=""):
    """Log a prompt/activity to history."""
    history_file = str(HISTORY_FILE)
    import datetime
    timestamp = datetime.datetime.now().isoformat()

    if os.path.exists(history_file):
        with open(history_file) as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                data = {"activities": [], "last_activity_id": 0}
    else:
        data = {"activities": [], "last_activity_id": 0}

    activity_id = data["last_activity_id"] + 1
    data["last_activity_id"] = activity_id
    data["activities"].append({
        "id": activity_id,
        "timestamp": timestamp,
        "agent": agent,
        "action": action,
        "details": details
    })
    if len(data["activities"]) > 500:
        data["activities"] = data["activities"][-500:]

    os.makedirs(os.path.dirname(history_file), exist_ok=True)
    with open(history_file, "w") as f:
        json.dump(data, f, indent=2)


class DashboardHandler(http.server.SimpleHTTPRequestHandler):
    """Serves dashboard files and handles pi prompt submissions."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(PROJECT_ROOT), **kwargs)

    def do_POST(self):
        if self.path == "/api/prompt":
            content_length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(content_length)
            try:
                data = json.loads(body)
            except json.JSONDecodeError:
                self.send_json(400, {"error": "Invalid JSON"})
                return

            prompt = data.get("prompt", "").strip()
            if not prompt:
                self.send_json(400, {"error": "Empty prompt"})
                return

            log_activity("user", "prompt-submitted", prompt[:200])

            if DRY_RUN:
                cmd = f"cd {PROJECT_ROOT} && pi '{prompt}'"
                self.send_json(200, {
                    "status": "dry-run",
                    "command": cmd,
                    "prompt": prompt
                })
                return

            try:
                # Launch pi in background with the prompt
                process = subprocess.Popen(
                    ["pi", prompt],
                    cwd=str(PROJECT_ROOT),
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    start_new_session=True
                )
                self.send_json(200, {
                    "status": "launched",
                    "pid": process.pid,
                    "prompt": prompt[:100] + ("..." if len(prompt) > 100 else "")
                })
            except FileNotFoundError:
                # pi not found — return the command for the user
                cmd = f"cd {PROJECT_ROOT} && pi '{prompt}'"
                self.send_json(200, {
                    "status": "command-only",
                    "command": cmd,
                    "note": "pi binary not found in PATH. Run this command manually."
                })
        else:
            self.send_json(404, {"error": "Not found"})

    def do_GET(self):
        if self.path == "/api/status":
            # Return combined project + status data
            result = {"project": {}, "status": {}}
            for key, filename in [("project", "project.json"), ("status", "status.json")]:
                fpath = DATA_DIR / filename
                if fpath.exists():
                    with open(fpath) as f:
                        try:
                            result[key] = json.load(f)
                        except json.JSONDecodeError:
                            pass
            self.send_json(200, result)

        elif self.path == "/api/history":
            if HISTORY_FILE.exists():
                with open(HISTORY_FILE) as f:
                    try:
                        data = json.load(f)
                    except json.JSONDecodeError:
                        data = {"activities": []}
            else:
                data = {"activities": []}
            self.send_json(200, data)

        elif self.path == "/api/reports":
            reports_dir = DATA_DIR / "reports"
            index_file = reports_dir / "index.json"
            if index_file.exists():
                with open(index_file) as f:
                    try:
                        data = json.load(f)
                    except json.JSONDecodeError:
                        data = {"reports": []}
            else:
                data = {"reports": []}
            self.send_json(200, data)

        elif self.path == "/api/project-dir":
            self.send_json(200, {"project_dir": str(PROJECT_ROOT)})

        else:
            super().do_GET()

    def send_json(self, status_code, data):
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def log_message(self, format, *args):
        # Suppress default logging noise
        if "/api/" in str(args):
            print(f"  [{self.command}] {args[0]}")
        # else: silence static file requests


def main():
    global PORT, DRY_RUN
    args = sys.argv[1:]

    if "--no-exec" in args:
        DRY_RUN = True
        args.remove("--no-exec")

    if "--port" in args:
        idx = args.index("--port")
        PORT = int(args[idx + 1])
        args = args[idx + 2:] if len(args) > idx + 1 else args[idx + 1:]

    server = http.server.HTTPServer(("0.0.0.0", PORT), DashboardHandler)

    print(f"""
╔══════════════════════════════════════════════════════════════╗
║       V-Model XT — Bidirectional Dashboard Server            ║
╠══════════════════════════════════════════════════════════════╣
║  Dashboard:  http://localhost:{PORT}/dashboard/               ║
║  API:        http://localhost:{PORT}/api/status               ║
║  Prompt API: POST http://localhost:{PORT}/api/prompt          ║
║  Project:    {str(PROJECT_ROOT)[:50]}
╠══════════════════════════════════════════════════════════════╣
║  Type prompts in the dashboard to launch pi.                 ║
║  Press Ctrl+C to stop.                                       ║
╚══════════════════════════════════════════════════════════════╝
""")
    if DRY_RUN:
        print("  ⚠ DRY-RUN mode — prompts will show commands without executing them.\n")

    # Open browser
    try:
        webbrowser.open(f"http://localhost:{PORT}/dashboard/")
    except Exception:
        pass

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n  Server stopped.")
        server.server_close()


if __name__ == "__main__":
    main()
