from fastapi import FastAPI, Body, HTTPException
from gemini_engine import BachatbotAI
from database import TransactionDB
import re
import json

# Initialize the FastAPI app
app = FastAPI()

# Documentation: We initialize our modular classes here.
# ai handles the conversation, and db handles the Firestore saving.
ai = BachatbotAI()
db = TransactionDB()

@app.get("/")
def read_root():
    """Simple health check to see if the server is running."""
    return {"status": "Bachatbot API is Live!"}

@app.post("/chat")
async def chat_api(payload: dict = Body(...)):
    """
    The main endpoint Namrata will call.
    Expected Input: {"message": "...", "uid": "..."}
    """
    # 1. Extract data from the request sent by the Frontend
    user_message = payload.get("message")
    uid = payload.get("uid")

    if not user_message or not uid:
        raise HTTPException(status_code=400, detail="Missing message or uid")

    try:
        # 2. Get the response from our Gemini Engine
        ai_response = ai.get_chat_response(user_message)

        # 3. Use Regular Expressions (re) to find the hidden DATA block
        # We look for anything between the tags DATA{...}DATA
        match = re.search(r"DATA(\{.*?\})DATA", ai_response)
        
        if match:
            # Convert the string inside the tags into a Python Dictionary
            transaction_json = json.loads(match.group(1))
            
            # 4. Save to Luniva's database
            # We pass the uid so the expense is linked to the correct user
            db.add_transaction(uid, transaction_json)
            
            # 5. Clean the response for the user
            # We remove the ugly JSON block so the user only sees the friendly text
            clean_reply = ai_response.replace(match.group(0), "").strip()
        else:
            # If no money was mentioned, just return the AI text as is
            clean_reply = ai_response

        # Return the final response back to Namrata's Flutter app
        return {"reply": clean_reply}

    except Exception as e:
        print(f"Error in /chat endpoint: {e}")
        return {"reply": "Sorry, mero system ma ali problem aayo. Pheri try garnus na?"}

# --- TO RUN THIS ---
# In terminal: uvicorn main:app --reload