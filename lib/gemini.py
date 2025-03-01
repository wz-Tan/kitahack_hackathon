
from google import genai
from dotenv import load_dotenv
import os

#Load the Env File
load_dotenv()
gemini_api_key=os.getenv("gemini_api_key")

#Initialise Gemini 
gemini_client=genai.Client(api_key=gemini_api_key)
# response = gemini_client.models.generate_content(
#     model="gemini-2.0-flash", contents="Explain how AI works nigga"
# )

