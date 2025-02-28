
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chapters_page.dart' as chapters_page;
import 'question_page.dart' as question_page;

void main() {
  runApp(const MainApp());
}

//Texts 
const defaultText=TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Consolas");
const questionText=TextStyle(color: Colors.black, fontSize: 25, fontFamily: "Consolas");
//Colours
const whiteBlue=Color(0xFFcaf0f8);
const darkBlue=Color(0xFF03045e);
const midBlue=Color(0xFF00b4d8);
const lightBlue=Color(0xFF90e0ef);

//Data Class

class Question{
  Question({required this.difficulty,required this.description,required this.answer,required this.hint});
  String difficulty;
  String description;
  String answer;
  String hint;
}

class Chapter{
  Chapter({required this.chapterName, required this.questionList});
  String chapterName;
  List<Question> questionList;
}


//Global App State
class MainAppState extends ChangeNotifier{
  //List of Lessons
  List<Chapter> lessons=[
    Chapter(chapterName: "Chapter 1", 
    questionList: [Question(difficulty: "Hard", description: "5+5=?", answer: "10", hint: "Use PEMDAS")])];
  int selectedPage=-1;

  void changePage(int page){
    selectedPage=page;
    notifyListeners();
  }
}

//Main App, Prepares State and Prompts Main Layout
class MainApp extends StatelessWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>MainAppState(),
      child: MaterialApp(
        theme: Theme.of(context),
        home: MainLayout(),
      )
      );
  }
}

//Create App State and App, Then Set the Child as the layout, then set child of layout as page
//Main Layout, Requires State to Navigate
class MainLayout extends StatefulWidget{
  const MainLayout({super.key});
  @override
  State<MainLayout> createState()=>_MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>{

  @override
  Widget build(BuildContext context) {
    var selectedPage=context.watch<MainAppState>().selectedPage;
    Widget displayedPage;

    if (selectedPage==-1){
      displayedPage=chapters_page.ChaptersPage();
    }
    else{
      displayedPage=question_page.QuestionPage(chapterIndex: selectedPage);
    }
    return Scaffold(
      //Top App Bar, Set Size then the Child (Set to Black Color For Easy Visualisation)
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 0), 

          //Fill Max parent Size, cannot use expanded since preferred size is not a column row or container
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.bottomCenter,
            
            //Text At Low Center
            child: Text("",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontSize: 20),),
          )),

      body:Expanded(
        child: displayedPage
      )
    );
  }

}


