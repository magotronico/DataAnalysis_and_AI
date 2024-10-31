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

def check_login(id: str, password: str, login_sheet: pd.DataFrame) -> bool:
    """Validate login credentials against the provided sheet data."""
    for _, row in login_sheet.iterrows():
        if (row['id_gestor'] == id or row.get('email') == id) and row['contrasena'] == password:
            return True
    return False

def search_client(client_id: str, clients_sheet: pd.DataFrame) -> dict:
    """Look up a client by ID in the client sheet data."""
    for _, row in clients_sheet.iterrows():
        if row['id_cliente'] == client_id:
            return row.to_dict()
    return None
