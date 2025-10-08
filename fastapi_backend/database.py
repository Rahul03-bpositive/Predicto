# database.py
from dotenv import load_dotenv
import os
from motor.motor_asyncio import AsyncIOMotorClient

# Load the .env file
load_dotenv()

# Read MongoDB connection string and database name from .env
MONGO_URI = os.getenv("MONGO_URI")
DB_NAME = os.getenv("DB_NAME")

# Connect to MongoDB using Motor
client = AsyncIOMotorClient(MONGO_URI)
db = client[DB_NAME]

# Example: you can access collections like this
# collection = db['mycollection']
