import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import dotenv
import os

dotenv.load_dotenv()
credentialPath=os.getenv("firebase_credential_path")
#Initialise Firebase (API Key, Firebase, Client)
cred = credentials.Certificate(credentialPath)
firebase_admin.initialize_app(cred)
client=firestore.client()

#Sample JSON File
sample_data={
    "task":"clean dishes",
    "status":"done"
}

#Get/Create Reference to Collection/Folder, Create Document, Add Data
folder=client.collection("SampleFolder")
document=folder.document("V03ozbJ1tEn5N1cvVyOe")
document.set(sample_data)

#Retrieve Data/Instance From the Document
print(document.get())
info=document.get().to_dict()
print(info)

