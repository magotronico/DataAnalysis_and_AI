# app/config.py

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
SPREADSHEET_ID = "1b-GoXyIc_PLbAx9TWZgmCbWqTl2H9hfElPL2iqIoUeU"
RANGES = {
    "login": "credenciales_usuarios!A:C",
    "clients": "clientes!A:AS",
    "usuarios": "usuarios!A:D",
    "interactions": "nueva_interaccion!A:K"
}
