import google.generativeai as genai
import os
from dotenv import load_dotenv

# Load variables from the .env file (like your API key)
load_dotenv()

class BachatbotAI:
    def __init__(self):
        """
        Constructor: Initializes the Gemini AI model using the API key
        stored in your hidden .env file.
        """
        # Retrieve the API key from the environment
        api_key = os.getenv("GEMINI_API_KEY")
        
        # Configure the Google GenAI library with your key
        genai.configure(api_key=api_key)
        
        # We use 'gemini-1.5-flash' because it is fast and cost-effective for chatbots
        self.model = genai.GenerativeModel('gemini-1.5-flash')
        
        # This 'System Instruction' acts as the Bot's personality and rules.
        # It tells the AI exactly how to behave and what data format to return.
        self.system_instruction = (
            "You are 'Bachatbot', a friendly financial assistant for Nepalese users. "
            "TONE: Friendly, supportive, and grounded. "
            "LANGUAGE RULE: If the user speaks Romanized Nepali, reply in Romanized Nepali. "
            "If they speak English, reply in English. "
            
            "ONBOARDING FLOW (For New Users): "
            "1. First greeting: 'Namaste! Bachatbot ma tapailai swagat cha. Tapai yo app pahilo patak chalaunu bhayeko?' "
            "2. If they say 'Yes' or 'Ahh', ask about their living situation: 'Tapai student ho ki jagire? Ani afnai ghar ma basnu hunxa ki bhada ma?' "
            
            "DATA EXTRACTION RULES (CRITICAL): "
            "When a user mentions a specific expense or income (e.g., 'Bhada 4000 diye' or 'Salary 20000 aayo'): "
            "1. Give a natural friendly response. "
            "2. At the very end of your response, add a hidden data block in this EXACT format: "
            "DATA{\"amount\": 4000, \"category\": \"rent\", \"type\": \"expense\"}DATA "
            
            "ALLOWED CATEGORIES: Food, Rent, Transportation, Groceries, Education, Saving, Income."
        )

    def get_chat_response(self, user_input):
        """
        This function takes the message from the user, sends it to Gemini 
        with the system rules, and returns the AI's text response.
        """
        # Combine our hidden rules with the user's actual message
        full_prompt = f"{self.system_instruction}\n\nUser: {user_input}"
        
        # Generate the response using the Gemini model
        response = self.model.generate_content(full_prompt)
        
        # Return the text portion of the response to the caller
        return response.text

# --- LOCAL TESTING BLOCK ---
# This part only runs if you execute 'python gemini_engine.py' directly.
# It helps you verify the AI works before connecting it to the database.
if __name__ == "__main__":
    bot = BachatbotAI()
    
    # Test 1: Initial Greeting
    print("--- Test 1: Greeting ---")
    print(bot.get_chat_response("Hello"))
    
    # Test 2: Expense Parsing
    print("\n--- Test 2: Expense ---")
    print(bot.get_chat_response("Momo khada 250 gayo"))