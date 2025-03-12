import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:convert';
void main() async {
  print("Hello World");
}

class Question {
  final String description;
  final String working;
  final String answer;
  final List<String> choices;

  const Question({
    required this.description,
    required this.working,
    required this.answer,
    required this.choices,
  });
}

class Lesson {
  final String lessonName;
  final String description;
  final String example;
  final String explanation;
  final bool completed;
  final List<Question> questions;

  const Lesson({
    required this.lessonName,
    required this.description,
    required this.example,
    required this.explanation,
    required this.completed,
    required this.questions,
  });
}

class Chapter {
  final String chapterName;
  final List<Lesson> lessons;

  const Chapter({required this.chapterName, required this.lessons});
}

void initGemini() async {
  await dotenv.load(fileName: ".env");

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
        "completed":Schema.boolean(
          nullable: false
          ),
        //Adding In A List Of Choices
        "choices": Schema.array(
          items: Schema.string(
            description: "Possible Answer for the question",
            nullable: false
          )
        )
      },
      requiredProperties: ["answer", "working", "description", "choices"],
    );


  final lessonSchema=Schema.object(
    description: "Schema for a Lesson",
    properties: {
      "lessonName":Schema.string(
        description: "Name of the Lesson. Should be short and concise",
        nullable: false
      ),
      "description":Schema.string(
        description: "Teach about the lesson as if you are a human teacher. Be detailed but concise.",
        nullable: false
      ),
      "example":Schema.string(
        description: "Provide an example for the lesson.",
        nullable: false
      ),
      "explanation":Schema.string(
        description: "Based on the example, provide the working and elaboration.",
        nullable: false
      ),

      "questions":Schema.array(
        description: "3 Questions for the Lesson ",
        items: questionSchema
      ),
    },
    requiredProperties: ["lessonName","description","example","explanation","questions"],
    nullable: false
  );

  final chapterSchema=Schema.object(
    description: "Schema For A Chapter",
    properties: {
      "chapterName": Schema.string(
        description: "Name of the Chapter. Format-> Chapter 1: Algebra",
        nullable: false
      ),
      "lessons":Schema.array(
        description: "List of Lessons for this Chapter",
        items: lessonSchema
      ),
      "questions":Schema.array(
        description: "List of Summative Questions (20) for this Chapter",
        items: questionSchema
      )
    },
    nullable: false,
    requiredProperties: ["chapterName","lessons","questions"]
  );


  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: dotenv.env["gemini_api_key"].toString(),
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: Schema.array(items: chapterSchema),
    ),
  );

  final response = await model.generateContent([
    Content.text(
      "Do not truncate responses. Generate 12 math chapters for a 10 year old in France, Keep the names as simple as possible while keeping a format such as Chapter 1: Multiplication",
    ),
  ]);

  print(response.text);

  // var responseText=jsonDecode(response.text!);
  // print(responseText);
  // for (var question in responseText){
  //   print(question);
  //   print("\n\n");
  // }

}

void createUser(){

}