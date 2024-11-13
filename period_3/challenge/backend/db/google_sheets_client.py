# backend/db/google_sheets_client.py

from googleapiclient.discovery import build
import pandas as pd
from dependencies import get_credentials  
from config import SPREADSHEET_ID         

def get_sheet_data(range_name: str) -> pd.DataFrame:
    """Fetch data from the specified sheet range."""
    creds = get_credentials()
    service = build("sheets", "v4", credentials=creds)
    sheet = service.spreadsheets().values().get(spreadsheetId=SPREADSHEET_ID, range=range_name).execute()
    values = sheet.get("values", [])
    
    if not values:
        return pd.DataFrame()
    
    return pd.DataFrame(values[1:], columns=values[0])

def check_login(id: str, password: str, login_sheet: pd.DataFrame) -> dict:
    """Validate login credentials and return user ID if successful."""
    for _, row in login_sheet.iterrows():
        if (row['id_usuario'] == id or row.get('correo') == id) and row['contrasena'] == password:
            return {"status": True, "user_id": row['id_usuario']}
    return {"status": False}

def get_client_db(client_id: str, clients_sheet: pd.DataFrame) -> dict:
    """Look up a client by ID in the client sheet data."""
    for _, row in clients_sheet.iterrows():
        if row['id_cliente'] == client_id:
            return row.to_dict()
    return None

def search_clients_db(query: str, clients_sheet: pd.DataFrame) -> list:
    """Search for clients in the client sheet data based on the query."""
    results = []
    for _, client in clients_sheet.iterrows():
        if any(str(field).lower().find(query.lower()) != -1 for field in client.iloc[:3]):
            # Convert Series to dictionary to make it JSON serializable
            results.append(client.to_dict())
    return results

def get_clients_usuario(usuario_id: str, clients_sheet: pd.DataFrame) -> list:
    """Get all clients associated with the specified manager."""
    return clients_sheet[clients_sheet['id_usuario'] == usuario_id].to_dict(orient='records')

def send_form_data(data: dict) -> bool:
    """Append form data to the Google Sheet."""
    body = {"values": [list(data.values())]}
    creds = get_credentials()
    service = build("sheets", "v4", credentials=creds)
    service.spreadsheets().values().append(spreadsheetId=SPREADSHEET_ID, range="nueva_interaccion!A1", valueInputOption="RAW", body=body).execute()
    return True