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

sample_data={
             "information":{
                 "name":"JSDHSHDSJH",
                 "age":"15"
             },
             "data":{
                 "apple":"sasa",
                 "nigdsdasdsa":"sahdashdhsa"
             }
             
             }

def retrieveQuestions(age,location):
    #Receive List Of Dictionaries Here
    questionDictList=gemini.generateTestQuestion(age=age,country=location)
    
    #Assign A Key for Each of Them, then Dump Them Into A Dict
    modifiedQuestionDictList=[]
    questionIndex=1
    for question in questionDictList:
        modifiedQuestionDictList.append(
            {f"Question {questionIndex}" : question}
            )
        questionIndex+=1
    
    return modifiedQuestionDictList


def uploadQuestions(username,age,location):
    questionList=retrieveQuestions(age,location)
    questionIndex=1
    for question in questionList:
        client.collection(username).document("Questions").collection("Test Questions").document(f"Question_{questionIndex}").set(question)
        questionIndex+=1
    return
       

uploadQuestions("John",10,"China")
    

