# backend/endpoints/client.py

from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect
from db.google_sheets_client import get_client_db, get_sheet_data, search_clients_db, send_form_data
from config import RANGES
from send_msm.snd_msm import send_agreement_message, send_hello, print_agreement_message
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

@router.post("/nueva_interaccion")
async def form_data(data: dict):
    try:
        # Get client data
        client_data = await get_client(data['id_cliente'])

        # Calculate payment amount based on agreement and offer
        if data['acuerdo_logrado'] and data['oferta_cobranza'] == 'Tus Pesos Valen Más':
            data['pago'] = 0.5 * client_data['Linea credito']
        elif data['acuerdo_logrado'] and data['oferta_cobranza'] == 'Pago sin Beneficio':
            data['pago'] = client_data['Linea credito']

        # Send form data to Google Sheets
        send_form_data(data)
        
        # Send agreement message if agreement was reached
        if data['acuerdo_logrado']:
            # send_agreement_message(client_data['nombre_completo'], data['pago'], data['fecha_prox_pago'], client_data['telefono']) # Este es el código original
            # send_agreement_message(client_data['nombre_completo'], data['pago'], data['fecha_prox_pago'], '+526644423353') # Este es el codigo para prueba de envio de mensaje
            print_agreement_message(client_data['nombre_completo'], data['pago'], data['fecha_prox_pago'], client_data['telefono']) # Este es el código de prueba en terminal
            
    except Exception as e:
        print(f"Failed to send form data: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to send form data: {str(e)}")
    return {"status": "Form data sent successfully"}