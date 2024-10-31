
# backend/endpoints/auth.py

from fastapi import APIRouter, HTTPException
from db.google_sheets_client import check_login, get_sheet_data
from config import RANGES

router = APIRouter()

@router.post("/login/")
async def login(id: str, password: str):
    login_sheet = get_sheet_data(RANGES["login"])
    if check_login(id, password, login_sheet):
        return {"status": "success", "message": "Login successful"}
    raise HTTPException(status_code=401, detail="Invalid credentials")