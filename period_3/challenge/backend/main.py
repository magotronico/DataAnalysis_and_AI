# backend/main.py

from fastapi import FastAPI
from endpoints import auth, client, common  # Updated import paths

app = FastAPI()

# Register routers
app.include_router(auth.router, tags=["auth"])
app.include_router(client.router, tags=["client"])
app.include_router(common.router, tags=["common"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
