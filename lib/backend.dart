// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'dart:core';

class Backend {
  late String google_api_key;
  late String gemini_api_key;
  late dynamic db;
  late dynamic currSet;
  late dynamic setPath;
  late String userId;
  late dynamic userInfo;
  late String currChapter;
  late String currLesson;
  bool userInfoRetrieved = false;

  Future<void> init() async {
    await dotenv.load(fileName: ".env");
    google_api_key = dotenv.env["google_api_key"].toString();
    gemini_api_key = dotenv.env["gemini_api_key"].toString();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    db = FirebaseFirestore.instance;
  }

  Future<bool> userExists() async {
    dynamic response = false;
    await db.collection("Users").doc(userId).get().then((snapshot) {
      if (snapshot.data() != null) {
        response = true;
      }
    });
    return response;
  }

  void createUser(String name, String age, String location) async {
    db.collection("Users").doc(userId).set({
      "name": name,
      "age": age,
      "location": location,
      "latest_set": 0,
      "current_set": 0,
      "latest_generation_time": DateTime.now().add(Duration(minutes: -1)).toString()
    });
  }

  Future<void> retrieveUserInfo() async {
    await db.collection("Users").doc(userId).get().then((docSnapshot) {
      userInfo = docSnapshot.data();
    });
    setPath = db
        .collection("Users")
        .doc(userId)
        .collection("Set ${userInfo["current_set"]}");
    currSet=userInfo["current_set"];
    userInfoRetrieved = true;
  }

  Future<List<String>> retrieveChapters() async {
    if (!userInfoRetrieved) await retrieveUserInfo();
    List<String> chapterList = [];
    await setPath.get().then((QuerySnapshot query) {
      for (var doc in query.docs) {
        chapterList.add(doc.id);
      }
    });
    
    chapterList.sort((a, b) {
      int numA = int.parse(a.split(" ")[1].replaceAll(":", ""));
      int numB = int.parse(b.split(" ")[1].replaceAll(":", ""));
      return numA.compareTo(numB);
    });
    return chapterList;
  }

  Future<List<String>> retrieveLessons() async {
    List<String> lessonList = [];
    await setPath.doc(currChapter).collection("Lessons").get().then((QuerySnapshot query) {
      for (var doc in query.docs) {
        lessonList.add(doc.id);
      }
    });
    
    return lessonList;
  }

  Future<dynamic> retrieveLesson() async {
    dynamic response;
    await setPath.doc(currChapter).collection("Lessons").doc(currLesson).get().then((snapshot) {
      response=snapshot.data();
    });
    return response;
  }

  void updateCurrSet(int target){
    db.collection("Users").doc(userId).update({"current_set": target});
  }

  Future<int> generateQuestions() async {
    if (!userInfoRetrieved) await retrieveUserInfo();
    var currentTime=DateTime.now();

    //Retrieve User Information
    var userAge = userInfo["age"];
    var userLocation = userInfo["location"];
    var latestSet = userInfo["latest_set"];
    var timeGenerated=DateTime.parse( userInfo["latest_generation_time"]);
    var timeDifference=currentTime.difference(timeGenerated).inMinutes;


    if (timeDifference<1){
      return 0;
    }

    latestSet++;
    updateCurrSet(latestSet);

    db.collection("Users").doc(userId).update({"latest_set": latestSet});
    db.collection("Users").doc(userId).update({"latest_generation_time": currentTime.toString()});
    final generateQuestionsPath = db
        .collection("Users")
        .doc(userId)
        .collection("Set $latestSet");


    final topicSchema=Schema.object(
      properties: {
        "topic": Schema.string(
          nullable: false,
        ),
        "explanation": Schema.string(
          description:
              "Brief explanation on the topic",
          nullable: false,
        ),
        "example": Schema.string(
          description: "Based off topic and explanation, provide a simple example of the topic",
          nullable: false,
        ),
      },
      requiredProperties: [
        "topic",
        "explanation",
        "example"
      ],
      nullable: false
    );
    final lessonSchema = Schema.object(
      description: "Schema for a Lesson",
      properties: {
        "lessonName": Schema.string(
          description: "Name of the Lesson. Should be short and concise",
          nullable: false,
        ),

        "topicList":Schema.array(
          items: topicSchema,
          nullable: false,
        )

      },
      requiredProperties: [
        "lessonName",
        "topicList"
      ],
      nullable: false,
    );

    
    var chapterListObject = await GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: gemini_api_key,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.array(items: Schema.string()),
      ),
    ).generateContent([
      Content.text(
        "Chapter names should be within 25 characters. Generate up to 12 math chapters for a $userAge year old in $userLocation strictly based on the local syllabus and their age, Keep the names within 3 to 4 words while keeping a format such as Chapter 1: Multiplication",
      ),
    ]);

    List<dynamic> chapterList = jsonDecode(chapterListObject.text!);
    

    //Generate List of Lessons for Each Chapter (Wait for Everything to Run due to Map)
    await Future.wait(
      chapterList.map((chapter) async {
        var lessonListObject = await GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: gemini_api_key,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: Schema.array(items: lessonSchema),
          ),
        ).generateContent([
          Content.text(
            "According to the chapter name, provide a list of lessons. Lesson names should not exceed 20 characters. Since the content is meant to be displayed on a mobile screen, keep the contents clean and concise without compromising understanding. Each lesson should contain at least 3 subtopics, with a brief topic such as 'What is Area?' and an explanation as well as an example. This is aimed to help a $userAge year old in $userLocation to understand the local syllabus. The chapter name is $chapter",
          ),
        ]);
        List<dynamic> lessonList = jsonDecode(lessonListObject.text!);
        

        //Create the Doc to Hold the Lessons
        generateQuestionsPath.doc(chapter).set({"completed": false});

        //Insert Lessons Into Lesson Folder
        await Future.wait(
          lessonList.map((lesson) =>
            generateQuestionsPath
                .doc(chapter)
                .collection("Lessons")
                .doc(lesson["lessonName"])
                .set(lesson)
          ),
        );
      }),
    );

    userInfoRetrieved=false;
    return 1;
  }

  
}
