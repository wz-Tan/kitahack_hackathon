import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import json
import dotenv
import os
import gemini 

dotenv.load_dotenv()
credentialPath=os.getenv("firebase_credential_path")

#Initialise Firebase (API Key, Firebase, Client)
cred = credentials.Certificate(credentialPath)
firebase_admin.initialize_app(cred)
client=firestore.client()

sample_data=[
    {
    "name":"John",
    "hobby":"none"
    },
    {
    "name":"John",
    "hobby":"none"
    }
]

def retrieveQuestions(age,location):
    #Receive List Of Dictionaries Here
    questionList=gemini.generateTestQuestion(age=age,country=location)
    return questionList
    

def uploadQuestions(username,age,location):
    questionList=retrieveQuestions(age,location)
    questionNum=0
    client.collection(username).document("Questions").collection("TestQuestions").document(f"Question {questionNum}").set(sample_data)
    return
    for question in questionList:
        client.collection(username).document("Questions").collection("TestQuestions").document(f"Question {questionNum}").set(question)
        questionNum+=1
    
        
    

uploadQuestions("John",10,"China")
    

