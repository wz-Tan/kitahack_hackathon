import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

  //Find a Way to Convert This Via the Class Declaration
  final schema = Schema.array(
    description: 'List of recipes',
    items: Schema.object(
      properties: {
        'recipeName': Schema.string(
          description: 'Name of the recipe.',
          nullable: false,
        ),
      },
      requiredProperties: ['recipeName'],
    ),
  );

  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: dotenv.env["gemini_api_key"].toString(),
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: schema,
    ),
  );
}
