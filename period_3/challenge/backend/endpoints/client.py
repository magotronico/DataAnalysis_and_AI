# backend/endpoints/client.py

from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect
from db.google_sheets_client import get_client_db, get_sheet_data, search_clients_db, send_form_data, update_client_data
from config import RANGES
from send_msm.snd_msm import send_agreement_message, print_agreement_message
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
        
        # Convert payment amount to float
        pago_float = float(re.sub(r"[{},]", "", client_data['Pago']))

        # Calculate payment amount based on agreement and offer and print agreement message
        if data['acuerdo_logrado'] and data['oferta_cobranza'] == 'Tus Pesos Valen Más':
            data['pago'] = f"{round(0.5 * pago_float, 2):.2f}"
            print_agreement_message(acuerdo = 1, nombre = client_data['nombre_completo'], amount = data['pago'], fecha = data['fecha_prox_pago'], recipient_number = client_data['telefono'])

        elif data['acuerdo_logrado'] and data['oferta_cobranza'] == 'Pago sin Beneficio':
            data['pago'] = client_data['Pago']
            print_agreement_message(acuerdo = 2, nombre = client_data['nombre_completo'], amount = data['pago'], fecha = data['fecha_prox_pago'], recipient_number = client_data['telefono'])

        elif data['acuerdo_logrado'] and data['oferta_cobranza'] == 'Quita / Castigo':
            data['pago'] = f"{round(float(data['pago']), 2):.2f}"
            print_agreement_message(acuerdo = 3, nombre = client_data['nombre_completo'], amount = data['pago'], fecha = data['fecha_prox_pago'], recipient_number = client_data['telefono'])

        elif data['acuerdo_logrado'] and data['oferta_cobranza'] == 'Reestructura del Crédito':
            data['pago'] = f"{round(float(data['pago']), 2):.2f}"
            client_data['tasa interes'] = data['tasa_interes']
            client_data['Plazo_Meses'] = data['plazo_meses']
            client_data['Pago'] = data['pago']
            print_agreement_message(acuerdo = 4, nombre = client_data['nombre_completo'], amount = data['pago'], fecha = data['fecha_prox_pago'], recipient_number = client_data['telefono'], interes = data['tasa_interes'], meses = data['plazo_meses'])
        
        # Send form data to Google Sheets
        send_form_data(data)

        # Update client data in Google Sheets
        # update_client_data(data['id_cliente'], client_data) # Uncomment this line to update client data in Google Sheets

    except Exception as e:
        print(f"Failed to send form data: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to send form data: {str(e)}")
    return {"status": "Form data sent successfully"}