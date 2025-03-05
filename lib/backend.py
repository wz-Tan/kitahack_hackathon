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
class Question(BaseModel):
    description :str 
    answer: str
    
class Lesson(BaseModel):
    lessonName: str
    description: str
    example: str
    explanation: str
    completed: bool
    questions: list[Question]
    

    
class Chapter(BaseModel):
    chapterName: str
    Lessons: list[Lesson]

chapterList=[]

def firebase_CreateUser(name: str,age: int,location: str):
    db.collection("Users").document(name).set({"age":age,"location":location, "latest_set":0})
    



def generateQuestions(username:str):
    
    #Retrieve User Info
    userInfo=db.collection("Users").document(username).get().to_dict()
    age=userInfo["age"]
    location=userInfo["location"]
    setNum=userInfo["latest_set"]
    
    #Assign New Set
    db.collection("Users").document(username).update({"latest_set":setNum+1})
    destination=(db
             .collection("Users").document(username)
             .collection(f"Set {setNum+1}"))
    
    chapters=gemini_client.models.generate_content(
        model="gemini-2.0-flash", 
        contents=f"Generate 12 math chapters for a {age} year old in {location}, Keep the names as simple as possible while keeping a format such as Chapter 1: Multiplication",
        config= {
            "response_mime_type":"application/json",
            "response_schema":list[str]
        },
    ).text
    
    #List of Chapters
    chapters=(json.loads(chapters))

    for chapter in chapters:
        #Generate Chapters
        lessons=gemini_client.models.generate_content(
            model="gemini-2.0-flash", 
            contents=f"According to the chapter name, provide a list of lessons. For each lesson, provide 3 suitable practice questions as well. Provide concrete examples and comprehensive elaborations. Humanise your reply as if you are an actual teacher. This is aimed to help a {age} year old in {location} to understand the local syllabus. The chapter name is {chapter}",
            config= {
                "response_mime_type":"application/json",
                "response_schema":list[Lesson]
            },
            ).text
        
        lessons=json.loads(lessons)
        
        #Uploading into Firebase
        for lesson in lessons:
            (destination.document(chapter)
             .collection("Lessons").document(lesson["lessonName"])
             .set(lesson)
             )
        
generateQuestions("Youtube Tan")