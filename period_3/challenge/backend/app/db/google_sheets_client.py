import os.path
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import pandas as pd

# These are the scopes that the Google Sheets API uses
#     - https://www.googleapis.com/auth/spreadsheets -> Allows access to the Google Sheets API: See, edit, create, and delete all your Google Sheets spreadsheets
SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]

# The ID and range of a specific sheet within the spreadsheet.
SPREADSHEET_ID = "1b-GoXyIc_PLbAx9TWZgmCbWqTl2H9hfElPL2iqIoUeU"
LOGIN_RANGE = "credenciales_gestores!A:C"
CLIENTS_RANGE = "clientes!A:G"
GESTORES_RANGE = "gestores!A:C"
INTERACCIONES_RANGE = "nueva_interaccion!A:K"

def get_credentials(scopes: list) -> Credentials:
    """
    Get the credentials to access the Google Sheets API.
    Verify if token.json exists, if not, create it using the credentials.json file obtained from the Google Cloud Platform.

    Parameters:
    scopes (list): The scopes that the Google Sheets API uses

    Returns:
    google.oauth2.credentials.Credentials: The credentials to access the Google Sheets API

    """

    creds = None

    if os.path.exists("token.json"):
        creds = Credentials.from_authorized_user_file("token.json", scopes)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                "credentials.json", scopes
            )
            creds = flow.run_local_server(port=0)

        with open("token.json", "w") as token:
            token.write(creds.to_json())
    return creds

def get_sheet(SPREADSHEET_ID: str, RANGE: str, creds: Credentials) -> pd.DataFrame:
    """
    Get the values from a specific sheet in a spreadsheet
    
    Parameters:
    SPREADSHEET_ID (str): The ID of the spreadsheet
    RANGE (str): The range of the sheet to get the values from. Format: "SheetName!A1:Z1000"
    creds (google.oauth2.credentials.Credentials): The credentials to access the Google Sheets API

    Returns:
    pd.DataFrame: A DataFrame with the values from the sheet
    """

    # Connect to the Google Sheets API
    service = build("sheets", "v4", credentials=creds)

    # Call the Sheets API
    spreadsheet = service.spreadsheets()
    sheet = (spreadsheet.values().get(spreadsheetId=SPREADSHEET_ID, range=RANGE).execute())

    # Get the values from the sheet
    values = sheet.get("values", [])

    # Verify if there are values in the sheet
    if not values:
        print("No data found.")
        return
    
    # Create a DataFrame with the values
    df = pd.DataFrame(values[1:], columns=values[0])

    return df

def check_login(id:str, password:str, login_sheet: pd.DataFrame) -> bool:
    """
    Check if the login credentials are correct.

    Parameters:
    id (str): The ID of the user could be email or id_gestor
    password (str): The password of the user
    login_sheet (pd.DataFrame): A DataFrame with the login credentials

    Returns:
    bool: True if the credentials are correct, False otherwise
    """

    for index, row in login_sheet.iterrows():
        if (row['id_gestor'] == id or row['email' == id]) and row['contrasena'] == password:
            return True

    return False

def search_client(client_id: int, clients_sheet: pd.DataFrame) -> dict:
    """
    Search a client in the clients sheet.

    Parameters:
    client_id (int): The ID of the client
    clients_sheet (pd.DataFrame): A DataFrame with the clients information

    Returns:
    dict: A dictionary with the client information
    """

    for index, row in clients_sheet.iterrows():
        if row['id_cliente'] == client_id:
            return row.to_dict()

    return None

def main():
    """Shows basic usage of the Sheets API.
    Prints values from a specific sheet in a spreadsheet.
    """
    # Connect to the Google Sheets API
    creds = get_credentials(SCOPES)

    try:
        # Get login credentials
        login = get_sheet(SPREADSHEET_ID, LOGIN_RANGE, creds)

        print(check_login("G0001", "testpass123", login))

        # Get clients
        clients = get_sheet(SPREADSHEET_ID, CLIENTS_RANGE, creds)

        print(search_client("C0001", clients))

    except HttpError as err:
        print(err)

if __name__ == "__main__":
  main()
