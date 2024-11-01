# backend/endpoints/client.py

from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect
from db.google_sheets_client import get_client_db, get_sheet_data, search_clients_db
from config import RANGES
import re

router = APIRouter()

@router.get("/client/{client_id}")
async def get_client(client_id: str):
    clients_sheet = get_sheet_data(RANGES["clients"])
    client_data = get_client_db(client_id, clients_sheet)
    if client_data:
        return client_data
    raise HTTPException(status_code=404, detail="Client not found")

# WebSocket endpoint to stream client search results in real-time
@router.websocket("/ws/search_clients")
async def search_clients(websocket: WebSocket):
    await websocket.accept()
    clients_sheet = get_sheet_data(RANGES["clients"])
    
    try:
        while True:
            query = await websocket.receive_text()
            if not re.match(r"^[a-zA-Z0-9\s]*$", query):
                await websocket.send_text("Invalid search query")
                continue
            results = search_clients_db(query, clients_sheet)
            await websocket.send_json(results)

    except WebSocketDisconnect:
        await websocket.close()