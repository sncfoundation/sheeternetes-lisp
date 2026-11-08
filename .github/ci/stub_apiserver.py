"""A stand-in for the Apps Script apiserver, just enough for a CI smoke run."""
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

PODS = {"items": [{"name": "hello-1", "deployment": "hello", "node": "node-a", "phase": "Running"}]}


class Handler(BaseHTTPRequestHandler):
    def _reply(self, body):
        data = json.dumps(body).encode()
        self.send_response(200)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        self._reply(PODS)

    def do_POST(self):
        body = json.loads(self.rfile.read(int(self.headers["content-length"])))
        self._reply({"ok": True, "action": body.get("action")})

    def log_message(self, *args):
        pass


HTTPServer(("127.0.0.1", 8080), Handler).serve_forever()
