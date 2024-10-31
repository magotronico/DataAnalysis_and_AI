from fastapi import FastAPI, HTTPException
from db.google_sheets_client import *

app = FastAPI()

# Login endpoint
@app.post("/login/")
async def login(id: str, password: str):
    result = check_login(id, password)
    if result["status"] == "failure":
        raise HTTPException(status_code=401, detail=result["message"])
    return result

# Search client endpoint
@app.get("/client/{client_id}")
async def get_client(client_id: int):
    result = get_client(client_id)
    if result["status"] == "failure":
        raise HTTPException(status_code=404, detail=result["message"])
    return result

# Test api
@app.get("/helloword/")
async def hello_world():
    return {"message": "Hello World!"}