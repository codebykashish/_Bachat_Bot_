# database.py
import firebase_admin
from firebase_admin import credentials, firestore
import os
from datetime import datetime

class TransactionDB:
    def __init__(self):
        """
        Constructor: Initializes Firebase connection using your 
        serviceAccountKey.json file. Only initializes once to avoid errors.
        """
        # Check if Firebase app is already initialized to prevent duplicate errors
        if not firebase_admin._apps:
            # Load the service account key from the JSON file in your project folder
            cred = credentials.Certificate("serviceAccountKey.json")
            
            # Initialize the Firebase app with your credentials
            firebase_admin.initialize_app(cred)
        
        # Get a reference to the Firestore database client
        self.db = firestore.client()
        print("✅ Firebase Connected Successfully!")

    def add_transaction(self, uid: str, transaction_data: dict):
        """
        Saves a single transaction under the correct user's document.
        
        Firestore Structure:
        users (collection)
          └── {uid} (document)
                └── transactions (sub-collection)
                      └── {auto-id} (document)
                            ├── amount: 250
                            ├── category: "food"
                            ├── type: "expense"
                            └── timestamp: 2025-07-10T...
        """
        try:
            # Add a timestamp so we know WHEN the expense happened
            transaction_data["timestamp"] = datetime.utcnow().isoformat()
            transaction_data["uid"] = uid
            
            # Navigate to: users -> {uid} -> transactions -> (new document)
            transaction_ref = (
                self.db
                .collection("users")        # Main collection
                .document(uid)              # This specific user
                .collection("transactions") # Their transactions sub-collection
                .add(transaction_data)      # Add new document with auto-ID
            )
            
            print(f"✅ Transaction saved for user {uid}: {transaction_data}")
            return {"success": True, "data": transaction_data}
            
        except Exception as e:
            print(f"❌ Error saving transaction: {e}")
            return {"success": False, "error": str(e)}

    def get_transactions(self, uid: str):
        """
        Retrieves ALL transactions for a specific user.
        Useful for dashboard and reports later.
        """
        try:
            # Get all documents from the user's transactions sub-collection
            docs = (
                self.db
                .collection("users")
                .document(uid)
                .collection("transactions")
                .order_by("timestamp", direction=firestore.Query.DESCENDING)
                .stream()
            )
            
            # Convert Firestore documents into a plain Python list
            transactions = []
            for doc in docs:
                data = doc.to_dict()
                data["id"] = doc.id  # Include the document ID
                transactions.append(data)
            
            return transactions
            
        except Exception as e:
            print(f"❌ Error fetching transactions: {e}")
            return []

    def get_budget_summary(self, uid: str):
        """
        Gets the user's manually set category budgets.
        This is what the AI will reference to warn users.
        (You'll use this in the Dashboard milestone M5)
        """
        try:
            doc = (
                self.db
                .collection("users")
                .document(uid)
                .get()
            )
            
            if doc.exists:
                return doc.to_dict().get("budgets", {})
            return {}
            
        except Exception as e:
            print(f"❌ Error fetching budget: {e}")
            return {}

    def set_budget(self, uid: str, category: str, limit: float):
        """
        Allows users to set a spending limit for a category.
        Example: Food budget = 5000 NPR
        """
        try:
            self.db.collection("users").document(uid).set(
                {"budgets": {category: limit}},
                merge=True  # Don't overwrite other fields, just update this one
            )
            print(f"✅ Budget set: {category} = {limit} for user {uid}")
            return {"success": True}
            
        except Exception as e:
            print(f"❌ Error setting budget: {e}")
            return {"success": False, "error": str(e)}


# --- LOCAL TESTING BLOCK ---
# Run: python database.py  to test connection independently
if __name__ == "__main__":
    print("Testing Firebase Connection...")
    
    db = TransactionDB()
    
    # Test with a dummy user ID
    test_uid = "test_user_123"
    
    # Test saving a transaction
    print("\n--- Test: Adding Transaction ---")
    result = db.add_transaction(test_uid, {
        "amount": 250,
        "category": "food",
        "type": "expense"
    })
    print(f"Result: {result}")
    
    # Test retrieving transactions
    print("\n--- Test: Getting Transactions ---")
    transactions = db.get_transactions(test_uid)
    print(f"Found {len(transactions)} transactions")
    for t in transactions:
        print(f"  - {t}")