// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:convert';

class Backend {
  late String google_api_key;
  late String gemini_api_key;
  late dynamic db;
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
    });
  }

  Future<void> retrieveUserInfo() async {
    await db.collection("Users").doc(userId).get().then((docSnapshot) {
      userInfo = docSnapshot.data();
    });
    setPath = db
        .collection("Users")
        .doc(userId)
        .collection("Set ${userInfo["latest_set"]}");
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

  Future<int> generateQuestions() async {
    if (!userInfoRetrieved) await retrieveUserInfo();

    //Retrieve User Information
    var userAge = userInfo["age"];
    var userLocation = userInfo["location"];
    var latestSet = userInfo["latest_set"];
    latestSet++;

    //Update Latest Set
    db.collection("Users").doc(userId).update({"latest_set": latestSet});
    final generateQuestionsPath = db
        .collection("Users")
        .doc(userId)
        .collection("Set $latestSet");

    final questionSchema = Schema.object(
      properties: {
        "description": Schema.string(
          description: "Description for a Math Question",
          nullable: false,
        ),
        "answer": Schema.string(
          description: "Answer For the Math Question",
          nullable: false,
        ),
        "working": Schema.string(
          description: "Working for the Math Question",
          nullable: false,
        ),
        "completed": Schema.boolean(nullable: false),
        //Adding In A List Of Choices
        "choices": Schema.array(
          items: Schema.string(
            description: "Possible Answer for the question",
            nullable: false,
          ),
        ),
      },
      requiredProperties: ["answer", "working", "description", "choices"],
    );

    final lessonSchema = Schema.object(
      description: "Schema for a Lesson",
      properties: {
        "lessonName": Schema.string(
          description: "Name of the Lesson. Should be short and concise",
          nullable: false,
        ),
        "description": Schema.string(
          description:
              "Teach about the lesson as if you are a human teacher. Be detailed but concise.",
          nullable: false,
        ),
        "example": Schema.string(
          description: "Provide an example for the lesson.",
          nullable: false,
        ),
        "explanation": Schema.string(
          description:
              "Based on the example, provide the working and elaboration.",
          nullable: false,
        ),

        "questions": Schema.array(
          description: "3 Questions for the Lesson ",
          items: questionSchema,
        ),
      },
      requiredProperties: [
        "lessonName",
        "description",
        "example",
        "explanation",
        "questions",
      ],
      nullable: false,
    );

    //Get List of Chapters
    var chapterListObject = await GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: gemini_api_key,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.array(items: Schema.string()),
      ),
    ).generateContent([
      Content.text(
        "Generate up to 12 math chapters for a $userAge year old in $userLocation based on the local syllabus, Keep the names as simple as possible while keeping a format such as Chapter 1: Multiplication",
      ),
    ]);

    List<dynamic> chapterList = jsonDecode(chapterListObject.text!);

    //Generate List of Lessons for Each Chapter (Wait for Everything to Run due to Map)
    Future.wait(
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
            "According to the chapter name, provide a list of lessons. For each lesson, provide 3 suitable practice questions as well. Each question should be provided with the working for the solution of the question. Provide 4 choices for each answer, one has to contain the actual answer. At the sam Provide concrete examples and comprehensive elaborations. Humanise your reply as if you are an actual teacher. This is aimed to help a $userAge year old in $userLocation to understand the local syllabus. The chapter name is $chapter",
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
    //Reset for fetching
    userInfoRetrieved=false;
    return 1;
  }
}
