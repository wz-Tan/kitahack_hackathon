
from google import genai
from pydantic import BaseModel
import json
from dotenv import load_dotenv
import os

#Load the Env File
load_dotenv()
gemini_api_key=os.getenv("gemini_api_key")

#Initialise Gemini 
gemini_client=genai.Client(api_key=gemini_api_key)
 
#Initialise the JSON Format (BaseModel is used to validate if it matches)
class question(BaseModel):
    topic : str
    description :str 
    answer: str
    difficulty: str
    hint: str
    

def generateTestQuestion(age,country):
    prompt_testQuestion=f"I am a {age} year old living in {country}. Strictly based on local goovernment education standards retrieved from referenced local exam papers and local newest textbooks, ask me a few questions to determine my math level for my age. "
    response = gemini_client.models.generate_content(
        model="gemini-2.0-flash", 
        contents=prompt_testQuestion,
        config= {
            "response_mime_type":"application/json",
            "response_schema":list[question]
        },
    )
    
    
    json_string=response.text  

    #Convert JSON String to a List of Dictionaries 
    return (json.loads(json_string))

generateTestQuestion(20,"Malaysia")
