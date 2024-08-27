import json
from typing import Dict, List
from fastapi import WebSocket

class WebSocketManager:
    def __init__(self):
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, user_email: str, websocket: WebSocket):
        if user_email not in self.active_connections:
            self.active_connections[user_email] = []
        self.active_connections[user_email].append(websocket)
        print(f"WebSocket connected for {user_email}")

    def disconnect(self, user_email: str, websocket: WebSocket):
        if user_email in self.active_connections:
            self.active_connections[user_email].remove(websocket)
            if not self.active_connections[user_email]:
                del self.active_connections[user_email]
        print(f"WebSocket disconnected for {user_email}")

    async def send_message(self, user_email: str, message: str):
        if user_email in self.active_connections:
            for connection in self.active_connections[user_email]:
                await connection.send_text(message)
                print(f"Sent message to {user_email}: {message}")
