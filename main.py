# main.py
from fastapi import FastAPI, Body, HTTPException
from gemini_engine import BachatbotAI
from database import TransactionDB
import re
import json

app = FastAPI(
    title="Bachatbot API",
    description="Know your kharcha, grow your bachat!",
    version="1.0.0"
)

# Initialize AI and Database
ai = BachatbotAI()
db = TransactionDB()

@app.get("/")
def read_root():
    return {
        "status": "✅ Bachatbot API is Live!",
        "message": "Namaste! Ready to track your kharcha."
    }

@app.post("/chat")
async def chat_api(payload: dict = Body(...)):
    """
    Main chat endpoint.
    Input:  {"message": "Momo khada 250 gayo", "uid": "user123"}
    Output: {"reply": "...", "transaction_saved": true/false}
    """
    user_message = payload.get("message")
    uid = payload.get("uid")

    # Validate input
    if not user_message:
        raise HTTPException(status_code=400, detail="Message cannot be empty")
    if not uid:
        raise HTTPException(status_code=400, detail="User ID (uid) is required")

    try:
        # Step 1: Get AI response
        ai_response = ai.get_chat_response(user_message)
        print(f"🤖 Raw AI Response: {ai_response}")

        # Step 2: Look for hidden DATA block using regex
        match = re.search(r"DATA(\{.*?\})DATA", ai_response, re.DOTALL)
        
        transaction_saved = False
        saved_data = None

        if match:
            try:
                # Step 3: Parse the JSON from the DATA block
                transaction_json = json.loads(match.group(1))
                print(f"💰 Extracted Transaction: {transaction_json}")
                
                # Step 4: Save to Firebase
                result = db.add_transaction(uid, transaction_json)
                transaction_saved = result.get("success", False)
                saved_data = transaction_json
                
                # Step 5: Remove DATA block from user-facing response
                clean_reply = ai_response.replace(match.group(0), "").strip()
                
            except json.JSONDecodeError as je:
                print(f"⚠️ Could not parse DATA block: {je}")
                clean_reply = ai_response
        else:
            # No transaction mentioned, just a conversation
            clean_reply = ai_response

        return {
            "reply": clean_reply,
            "transaction_saved": transaction_saved,
            "data": saved_data  # Frontend can use this to update UI instantly
        }

    except Exception as e:
    # This part is for YOU to see the error in VS Code/Terminal
        import traceback
        print("--- FULL ERROR TRACEBACK ---")
        traceback.print_exc() 
        
        # This part is for SWAGGER to show you the error message
        return {
            "reply": f"Technical Error: {str(e)}",
            "transaction_saved": False,
            "data": None
        }

@app.get("/transactions/{uid}")
async def get_user_transactions(uid: str):
    """
    Get all transactions for a user.
    Useful for testing if data is actually being saved.
    """
    try:
        transactions = db.get_transactions(uid)
        return {
            "uid": uid,
            "count": len(transactions),
            "transactions": transactions
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/budget")
async def set_budget(payload: dict = Body(...)):
    """
    Set category budget for a user.
    Input: {"uid": "user123", "category": "food", "limit": 5000}
    """
    uid = payload.get("uid")
    category = payload.get("category")
    limit = payload.get("limit")
    
    if not all([uid, category, limit]):
        raise HTTPException(status_code=400, detail="Missing uid, category, or limit")
    
    result = db.set_budget(uid, category, float(limit))
    return result