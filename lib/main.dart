import 'dart:collection';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chapters_page.dart' as chapters_page;
import 'question_page.dart' as question_page;
import 'colours.dart' as colours;
import 'textstyles.dart' as textstyles;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  //Init plugins
  WidgetsFlutterBinding.ensureInitialized();
  //Load Env File
  await dotenv.load(fileName: ".env");

  //Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

//API Key provider for firebase options
class EnvProvider{
  //Getter for firebase options
  static String get googleAPIKey{
    return dotenv.env["google_api_key"] ?? "Not Retrieved";
  }

}
//Data Class
class Question {
  Question({
    required this.topic,
    required this.difficulty,
    required this.description,
    required this.answer,
    required this.hint,
  });
  String topic;
  String difficulty;
  String description;
  String answer;
  String hint;
}

class Chapter {
  Chapter({required this.chapterName, required this.questionList});
  String chapterName;
  List<Question> questionList;
}

//Global App State
class MainAppState extends ChangeNotifier {
  //Initialise the firebase client
  final db = FirebaseFirestore.instance;
  

  //Username needs to be from token.
  final username = "Youtube Tan";

  //List of Lessons
  List<Chapter> lessons = [
    Chapter(
      chapterName: "Chapter 1: Polynomials",
      questionList: [
        Question(
          difficulty: "Hard",
          description: "5+5=?",
          answer: "10",
          hint: "Use PEMDAS",
          topic: "Addition",
        ),
        Question(
          difficulty: "Hard",
          description: "1000*20343204302302=?",
          topic: "Addition",
          answer: "10",
          hint: "Use PEMDAS",
        ),
      ],
    ),
    Chapter(
      chapterName: "Chapter 2: Matrices",
      questionList: [
        Question(
          difficulty: "Hard",
          description: "5+5=?",
          answer: "10",
          hint: "Use PEMDAS",
          topic: "Addition",
        ),
        Question(
          difficulty: "Hard",
          description: "1000*20343204302302=?",
          topic: "Addition",
          answer: "10",
          hint: "Use PEMDAS",
        ),
      ],
    ),
  ];

  int selectedPage = -1;

  void changePage(int page) {
    selectedPage = page;
    notifyListeners();
  }

  //Get data from firestore
  Future getData() async {
    dynamic userInfo;

    //Acquire User Info
    await db.collection("Users").doc(username).get().then((
      DocumentSnapshot doc,
    ) {
      userInfo = doc.data();
    });

    int latestSet = userInfo["latest_set"];

    //Get Set Path to Run Faster 
    dynamic setPath = db
        .collection("Users")
        .doc(username)
        .collection("Set $latestSet");

    List<String> chapters=[];

    //Get Chapter ID  (Create Chapter Card For Each)
    await setPath
        .get()
        .then(
          (QuerySnapshot query) {
            for (var doc in query.docs){
              chapters.add(doc.id);
            }
        }
      );

    print(chapters);

    
  }
}

//Main App, Prepares State and Prompts Main Layout
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(theme: Theme.of(context), home: MainLayout()),
    );
  }
}

//Create App State and App, Then Set the Child as the layout, then set child of layout as page
//Main Layout, Requires State to Navigate
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    appState.getData();
    var selectedPage = appState.selectedPage;
    String topAppBarText;
    Widget displayedPage;

    if (selectedPage == -1) {
      topAppBarText = "Chapter Selection";
      displayedPage = chapters_page.ChaptersPage();
    } else {
      topAppBarText = appState.lessons[selectedPage].chapterName;
      displayedPage = question_page.QuestionPage(chapterIndex: selectedPage);
    }
    return Scaffold(
      //Top App Bar
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),

        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.bottomCenter,

          child: Stack(
            children: [
              if (selectedPage != -1)
                Positioned(
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      appState.changePage(-1);
                    },
                    icon: Icon(Icons.home),
                    color: colours.black,
                  ),
                ),

              Center(child: Text(topAppBarText, style: textstyles.boldedText)),
            ],
          ),
        ),
      ),

      //Contents
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: displayedPage,
      ),
    );
  }
}
