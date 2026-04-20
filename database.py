import firebase_admin
from firebase_admin import credentials, firestore
import os
from dotenv import load_dotenv

# Load the .env file to get the path to your serviceAccountKey.json
load_dotenv()

class TransactionDB:
    def __init__(self):
        """
        Constructor: Sets up the connection to the shared Firebase project.
        """
        # Get the path to the JSON key Namrata gave you
        cert_path = os.getenv("FIREBASE_SERVICE_ACCOUNT_PATH")
        
        # We check if the app is already initialized to prevent errors 
        # during multiple runs or reloads.
        if not firebase_admin._apps:
            # Use the 'Service Account' credentials to gain full access
            cred = credentials.Certificate(cert_path)
            firebase_admin.initialize_app(cred)
            
        # This 'db' object is what we use to read/write data
        self.db = firestore.client()

    def add_transaction(self, uid, data):
        """
        This function takes the parsed JSON from Gemini and saves it 
        to the 'transactions' collection in Firestore.
        """
        try:
            # We create a new document in the 'transactions' collection
            # Using .document() without an ID generates a unique random ID
            doc_ref = self.db.collection('transactions').document()
            
            # We add the User ID so Luniva can filter data for specific users
            data['uid'] = uid
            
            # We add a server-side timestamp so we know exactly when this happened
            data['created_at'] = firestore.SERVER_TIMESTAMP
            
            # Write the data to Firestore
            doc_ref.set(data)
            
            print(f"✅ Success: Transaction saved with ID {doc_ref.id}")
            return True
            
        except Exception as e:
            print(f"❌ Error saving to database: {e}")
            return False

# --- LOCAL TESTING BLOCK ---
if __name__ == "__main__":
    # Test to see if you can manually push data to the shared DB
    # Make sure you have 'serviceAccountKey.json' in your folder!
    db_manager = TransactionDB()
    
    test_data = {
        "amount": 250,
        "category": "food",
        "item": "momo",
        "type": "expense"
    }
    
    # Use a dummy UID for testing
    db_manager.add_transaction("kashish_test_123", test_data)