# debug_test.py
# Run: python debug_test.py
# This tests each component ONE BY ONE

print("="*50)
print("BACHATBOT DEBUG TEST")
print("="*50)

# ─── TEST 1: Environment Variables ───
print("\n[1/3] Testing .env file...")
try:
    from dotenv import load_dotenv
    import os
    load_dotenv()
    
    api_key = os.getenv("GEMINI_API_KEY")
    if api_key:
        # Only show first 10 characters for security
        print(f"✅ GEMINI_API_KEY found: {api_key[:10]}...")
    else:
        print("❌ GEMINI_API_KEY is MISSING from .env file!")
        print("   Fix: Open .env and add: GEMINI_API_KEY=your_key_here")
except Exception as e:
    print(f"❌ .env Error: {e}")

# ─── TEST 2: Gemini AI ───
print("\n[2/3] Testing Gemini AI...")
try:
    from gemini_engine import BachatbotAI
    bot = BachatbotAI()
    response = bot.get_chat_response("Hello, say hi back in one sentence")
    print(f"✅ Gemini AI working!")
    print(f"   Response: {response[:80]}...")
except Exception as e:
    print(f"❌ Gemini AI Error: {e}")
    print("   Fix: Check your GEMINI_API_KEY in .env")

# ─── TEST 3: Firebase Database ───
print("\n[3/3] Testing Firebase Database...")
try:
    from database import TransactionDB
    db = TransactionDB()
    print("✅ Firebase connected!")
    
    # Try saving a test transaction
    result = db.add_transaction("debug_test_user", {
        "amount": 100,
        "category": "food", 
        "type": "expense"
    })
    print(f"✅ Test transaction saved: {result}")
    
except FileNotFoundError:
    print("❌ serviceAccountKey.json NOT FOUND!")
    print("   Fix: Download it from Firebase Console and put it in your project folder")
except Exception as e:
    print(f"❌ Firebase Error: {e}")
    print("   Check your serviceAccountKey.json file")

print("\n" + "="*50)
print("DEBUG COMPLETE - Share the output above!")
print("="*50)