# database.py
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime


class TransactionDB:
    def __init__(self):
        if not firebase_admin._apps:
            cred = credentials.Certificate("serviceAccountKey.json")
            firebase_admin.initialize_app(cred)

        self.db = firestore.client()
        print("✅ Firebase Connected Successfully!")

    # ---------------------------------------------------------
    # CREATE USER PROFILE AFTER SIGNUP
    # ---------------------------------------------------------
    def create_user(self, uid, first_name, last_name, phone):
        user_ref = self.db.collection("users").document(uid)

        user_ref.set({
            "profile": {
                "first_name": first_name,
                "last_name": last_name,
                "phone": phone,
                "email": None,
                "created_at": datetime.utcnow(),
                "last_login_at": datetime.utcnow()
            },
            "onboarding": {},
            "chatbot_state": {
                "last_active_month": datetime.utcnow().strftime("%Y-%m"),
                "last_budget_prompt_month": None,
                "conversation_mode": "normal",
                "last_interaction_at": datetime.utcnow()
            },
            "settings": {
                "language_pref": "roman_nepali",
                "notifications_enabled": True,
                "currency": "NPR"
            }
        }, merge=True)

        return {"success": True}

    # ---------------------------------------------------------
    # ADD TRANSACTION
    # ---------------------------------------------------------
    def add_transaction(self, uid, transaction_data):
        now = datetime.utcnow()

        transaction_document = {
            "amount": transaction_data.get("amount"),
            "currency": "NPR",
            "type": transaction_data.get("type"),
            "category": transaction_data.get("category"),
            "source": transaction_data.get("source", "chat"),
            "status": transaction_data.get("status", "confirmed"),
            "merchant": transaction_data.get("merchant"),
            "raw_text": transaction_data.get("raw_text"),
            "month_key": now.strftime("%Y-%m"),
            "created_at": now,
            "occurred_at": now
        }

        ref = (
            self.db.collection("users")
            .document(uid)
            .collection("transactions")
            .add(transaction_document)
        )

        return {"success": True, "id": ref[1].id}

    # ---------------------------------------------------------
    # GET USER TRANSACTIONS
    # ---------------------------------------------------------
    def get_transactions(self, uid):
        docs = (
            self.db.collection("users")
            .document(uid)
            .collection("transactions")
            .order_by("created_at", direction=firestore.Query.DESCENDING)
            .stream()
        )

        transactions = []
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            transactions.append(data)

        return transactions