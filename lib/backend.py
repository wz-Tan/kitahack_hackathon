
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
from google import genai
from pydantic import BaseModel
import json
from dotenv import load_dotenv
import os

#Load the Env File
load_dotenv()
gemini_api_key=os.getenv("gemini_api_key")
firebase_credential_path=os.getenv("firebase_credential_path")

#Initialise Firebase
cred = credentials.Certificate(firebase_credential_path)
firebase_admin.initialize_app(cred)
db=firestore.client()

#Initialise Gemini 
gemini_client=genai.Client(api_key=gemini_api_key)

 
#Initialise the JSON Format (BaseModel is used to validate if it matches)
class lesson(BaseModel):
    lessonName: str
    description: str
    example: str 
    explanation: str
    completed: bool 
    
class question(BaseModel):
    description :str 
    answer: str
    
class Chapter(BaseModel):
    chapterName: str
    Lessons: list[lesson]=[]
    Questions: list[question]=[]

chapterList=[]

def firebase_CreateUser(name: str,age: int,location: str):
    db.collection("Users").document(name).set({"age":age,"location":location})
    

def firebase_InitContent(name:str):
    userInfo=db.collection("Users").document(name).get().to_dict()
    age=userInfo["age"]
    location=userInfo["location"]
    gemini_Testing(age=age,location=location)
    


def gemini_Testing(age:int,location:str):
    response=gemini_client.models.generate_content(
        model="gemini-2.0-flash", 
        contents=f"Generate 12 math chapters for a {age} year old in {location}, Keep the names as simple as possible while keeping a format such as Chapter 1: Multiplication",
        config= {
            "response_mime_type":"application/json",
            "response_schema":list[str]
        },
    ).text
    
    response_dict=(json.loads(response))
    
    #Create A List Of Chapters
    for chapter in response_dict:
        chapterList.append(chapter)
    
    #Generate Lessons 
    for chapter in chapterList:
        lessons=gemini_client.models.generate_content(
            model="gemini-2.0-flash", 
            contents=f"According to the chapter name, provide a list of lessons. Provide concrete examples and comprehensive elaborations. Humanise your reply as if you are an actual teacher. This is aimed to help a {age} year old in {location} to understand the local syllabus. The chapter name is {chapter}",
            config= {
                "response_mime_type":"application/json",
                "response_schema":list[lesson]
            },
            ).text
        print("\n\n\nThe lesson for",chapter,"is",lessons)
    
    #Generate Questions Left (O n^2)
    
