import json
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from app.services.websocket_service import WebSocketManager

router = APIRouter()
websocket_manager = WebSocketManager()

@router.websocket("/websocket/{user_email}")
async def websocket_endpoint(user_email: str, websocket: WebSocket):
    await websocket.accept()
    print(f"WebSocket accepted for {user_email}")
    try:
        # Add the connection to the manager
        await websocket_manager.connect(user_email, websocket)
        
        while True:
            data = await websocket.receive_text()
            print(f"Received data from WebSocket: {data}")
            # You can also send messages or handle data here
            
    except WebSocketDisconnect:
        await websocket_manager.disconnect(user_email, websocket)
        print(f"WebSocket disconnected for {user_email}")