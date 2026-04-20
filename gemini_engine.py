import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv()

class BachatbotAI:
    def __init__(self):
        genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
        self.model = genai.GenerativeModel('gemini-1.5-flash')
        
        # MASTER PROMPT: Handles Onboarding, Romanized Nepali, and JSON Data
        self.system_instruction = (
            "You are 'Bachatbot', a helpful financial assistant for Nepalese users. "
            "TONE: Friendly and grounded. Speak Romanized Nepali or English as the user does. "
            "ONBOARDING FLOW: "
            "1. If it's the first message, say: 'Namaste! Bachatbot ma tapailai swagat cha. Tapai yo app pahilo patak chalaunu bhayeko?' "
            "2. If they say yes, ask: 'Tapai student ho ki jagire? Ani afnai ghar ma basnu hunxa ki bhada ma?' "
            "EXTRACTION RULE: If they mention money (e.g., 'Bhada 4000 diye'), reply naturally AND end with: "
            "DATA{\"amount\": 4000, \"category\": \"rent\", \"type\": \"expense\"}DATA"
        )

    def get_chat_response(self, user_input):
        # We wrap the user input with our master instructions
        full_prompt = f"{self.system_instruction}\n\nUser: {user_input}"
        response = self.model.generate_content(full_prompt)
        return response.text

# --- QUICK TEST ---
if __name__ == "__main__":
    bot = BachatbotAI()
    print(bot.get_chat_response("Hello"))