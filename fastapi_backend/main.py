from fastapi import FastAPI, HTTPException
from database import db  # your database connection
from pydantic import BaseModel

app = FastAPI(title="FastAPI + MongoDB Example")

# Pydantic model for profile data
class Profile(BaseModel):
    name: str
    email: str
    age: str

# POST endpoint to save profile data
@app.post("/api/profile")
async def save_profile(profile: Profile):
    profile_dict = profile.dict()
    try:
        result = await db["profiles"].insert_one(profile_dict)
        return {"id": str(result.inserted_id)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error saving profile: {e}")

# Simple root endpoint to verify server is running
@app.get("/")
def root():
    return {"message": "FastAPI + MongoDB backend is running 🚀"}
