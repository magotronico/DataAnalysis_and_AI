# backend/endpoints/client.py

from fastapi import APIRouter, HTTPException
from db.google_sheets_client import search_client, get_sheet_data
from config import RANGES

router = APIRouter()

@router.get("/client/{client_id}")
async def get_client(client_id: str):
    clients_sheet = get_sheet_data(RANGES["clients"])
    client_data = search_client(client_id, clients_sheet)
    if client_data:
        return client_data
    raise HTTPException(status_code=404, detail="Client not found")