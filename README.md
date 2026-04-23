# _Bachat_Bot_
# bachatbot

project for bachat

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 💰 BachatBot (बचत-बोट)

> Know your kharcha, grow your bachat.

BachatBot is a conversational AI-powered expense tracking system designed for students and young professionals in Nepal.  
Instead of filling complex forms, users simply chat naturally, and the system intelligently extracts and stores structured financial data.

---

# 🚀 Project Overview

Traditional finance apps require manual entry through forms.  
BachatBot removes friction by allowing users to type:

Momo khada 250 gayo

The system:
- Uses AI to extract structured financial data
- Stores transactions securely under each user account
- Supports confirmation for notification-based transactions
- Maintains onboarding memory
- Prepares system for monthly financial insights

---

# 🔐 Authentication System

We use **Firebase Email & Password Authentication**.

## ✅ Signup Process

User provides:
- First Name
- Last Name
- Email
- Password
- Confirm Password

Firebase:
- Creates secure user account
- Generates a unique `uid`
- Generates an `idToken` after login

After successful signup, frontend calls:

POST /complete-signup

Headers:
Authorization: Bearer <idToken>

Body:
{
  "first_name": "...",
  "last_name": "...",
  "email": "..."
}

Backend verifies token and stores profile data in Firestore under:

users/{uid}

---

## ✅ Login Process

User logs in using:
- Email
- Password

Frontend retrieves:

String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();

Every backend request includes:

Authorization: Bearer <idToken>

Backend verifies token securely before allowing access.

---

# 🏗️ Architecture Overview

Frontend (Flutter)
        │
        │  HTTP (Authorization: Bearer idToken)
        ▼
Backend (FastAPI)
        │
        ├── Firebase Auth (Token Verification)
        ├── Gemini API (NLP Parsing)
        └── Firestore (Database)

Frontend never writes directly to database.  
All communication happens through backend API.

---

# 🧠 Core Features

✅ Conversational Expense Logging  
Users log expenses naturally:

Momo 250

AI extracts:

{
  "amount": 250,
  "category": "Food",
  "type": "expense"
}

---

✅ Notification-Based Transaction Detection (Future Ready)

When bank/eSewa notification is received:
- Parsed into structured transaction
- Stored as status = pending
- User confirms before final save

---

✅ User Onboarding Memory

Chatbot asks:
- Student or working?
- Rent or own house?
- Approximate monthly income?

Answers stored in onboarding map.  
Bot does not repeat questions.

---

✅ Monthly Detection

System tracks last_active_month.  
When new month begins:
- Prompts user to review finances.

---

✅ Secure Multi-User Isolation

All user data is stored under:

users/{uid}

No user can access another user’s data.

---

# 🗄️ Database Schema (Firestore)

users (collection)
└── {uid} (document)
    │
    ├── profile (map)
    │   ├── first_name
    │   ├── last_name
    │   ├── email
    │   ├── created_at
    │   └── last_login_at
    │
    ├── onboarding (map)
    │   ├── occupation
    │   ├── living
    │   ├── monthly_income_approx
    │   ├── onboarding_completed
    │   └── completed_at
    │
    ├── chatbot_state (map)
    │   ├── last_active_month
    │   ├── last_budget_prompt_month
    │   ├── conversation_mode
    │   └── last_interaction_at
    │
    ├── settings (map)
    │   ├── language_pref
    │   ├── notifications_enabled
    │   └── currency
    │
    └── transactions (subcollection)
        └── {transaction_id}
            ├── amount
            ├── currency
            ├── type
            ├── category
            ├── source
            ├── status
            ├── merchant
            ├── raw_text
            ├── month_key
            ├── created_at
            └── occurred_at

---

# 🛠️ Backend Technology Stack

- FastAPI
- Firebase Admin SDK
- Firestore
- Google Gemini API
- Python 3.11+
- Uvicorn

---

# 🧩 AI Integration

We use Google Gemini to:
- Parse natural language
- Extract amount, category, and type
- Return structured JSON inside DATA{} block

Example AI output format:

DATA{"amount":250,"category":"Food","type":"expense"}DATA

Regex extracts JSON safely.

---

# 🔑 Environment Setup

Create a .env file:

GEMINI_API_KEY=your_gemini_api_key

Place serviceAccountKey.json inside backend folder.

Ensure .gitignore contains:

.env
serviceAccountKey.json
__pycache__/

---

# ▶️ Running Backend

cd backend  
uvicorn main:app --reload  

For remote testing:

ngrok http 8000  

Use generated HTTPS URL in frontend.

---

# 🔎 API Endpoints

POST /complete-signup  
Creates user profile after first signup.

POST /chat  
Processes chat message and logs transactions.

GET /transactions  
Returns all transactions for authenticated user.

All endpoints require:

Authorization: Bearer <idToken>

---

# 📌 Future Enhancements

- Budget limits per category
- Monthly summary reports
- Graph visualizations
- Smart alerts (80% usage)
- Investment suggestions
- Shared wallets

---

# 👥 Team Roles

- Backend & AI Integration
- Frontend (Flutter + Firebase Auth)
- Database & Schema Management
- Notification Integration

---

# 📜 License

Educational / Innovation Project