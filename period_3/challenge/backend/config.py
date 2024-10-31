# app/config.py

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
SPREADSHEET_ID = "1b-GoXyIc_PLbAx9TWZgmCbWqTl2H9hfElPL2iqIoUeU"
RANGES = {
    "login": "credenciales_gestores!A:C",
    "clients": "clientes!A:G",
    "gestores": "gestores!A:C",
    "interactions": "nueva_interaccion!A:K"
}
