
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chapters_page.dart' as chapters_page;
import 'question_page.dart' as question_page;
import 'colours.dart' as colours;
import 'textstyles.dart' as textstyles;
void main() {
  runApp(const MainApp());
}




//Data Class

class Question{
  Question({required this.topic,required this.difficulty,required this.description,required this.answer,required this.hint});
  String topic;
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
    Chapter(
      chapterName: "Chapter 1: Polynomials", 
      questionList: [
        Question(difficulty: "Hard", description: "5+5=?", answer: "10", hint: "Use PEMDAS", topic: "Addition" ),
        Question(difficulty: "Hard", description: "1000*20343204302302=?", topic: "Addition", answer: "10", hint: "Use PEMDAS")
        ]
      ),
    Chapter(
      chapterName: "Chapter 2: Matrices", 
      questionList: [
        Question(difficulty: "Hard", description: "5+5=?", answer: "10", hint: "Use PEMDAS", topic: "Addition" ),
        Question(difficulty: "Hard", description: "1000*20343204302302=?", topic: "Addition", answer: "10", hint: "Use PEMDAS")
        ]
      )

        ];
    

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
    var appState=context.watch<MainAppState>();
    var selectedPage=appState.selectedPage;
    String topAppBarText;
    Widget displayedPage;

    if (selectedPage==-1){
       topAppBarText="Chapter Selection";
      displayedPage=chapters_page.ChaptersPage();
    }
    else{
      topAppBarText=appState.lessons[selectedPage].chapterName;
      displayedPage=question_page.QuestionPage(chapterIndex: selectedPage);
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
                if (selectedPage!=-1)
                Positioned(
                  left: 10,
                  child: IconButton(
                    onPressed: (){
                      appState.changePage(-1);
                    },
                    icon:Icon(Icons.home), 
                    color: colours.black)),

                Center(
                  child: Text(topAppBarText,
                  style: textstyles.boldedText,)
                  )
                
                
                
              ],
            )
          )),

      body:SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: displayedPage
      )
    );
  }

}


