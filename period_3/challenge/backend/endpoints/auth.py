# backend/endpoints/auth.py

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db.google_sheets_client import check_login, get_sheet_data
from config import RANGES

router = APIRouter()

# Define a Pydantic model for the login request
class LoginRequest(BaseModel):
    id: str
    password: str

@router.post("/login/")
async def login(login_request: LoginRequest):
    login_sheet = get_sheet_data(RANGES["login"])
    if check_login(login_request.id, login_request.password, login_sheet):
        return {"status": "success", "message": "Login successful"}
    raise HTTPException(status_code=401, detail="Invalid credentials")
