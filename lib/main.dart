
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'test.dart' as test;
void main() {
  runApp(const MainApp());
}

//Data Class
class LessonData{
  LessonData(this.chapterName);
  String chapterName;
}

//Global App State
class MainAppState extends ChangeNotifier{
  //List of Lessons
  List<LessonData> lessons=[LessonData("Chapter 1"),LessonData("Chapter 2"),LessonData("Chapter 3"),LessonData("Chapter 4")];
  int selectedPage=0;

  void changePage(int page){
    selectedPage=page;
    print("PAGE IS CHANGEDDD $selectedPage");
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
      displayedPage=ChaptersPage();
    }
    else{
      displayedPage=test.TestPage();
    }
    return Scaffold(
      //Top App Bar, Set Size then the Child (Set to Black Color For Easy Visualisation)
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 30), 

          //Fill Max parent Size, cannot use expanded since preferred size is not a column row or container
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(10),
            color: Color(0xFF000000),

            //Text At Low Center
            child: Text("Top App Bar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontSize: 20),),
          )),

      body:Expanded(
        child: displayedPage
      )
    );
  }

}


//Chapters Page
class ChaptersPage extends StatelessWidget{
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lessons=context.watch<MainAppState>().lessons;
    var page=context.watch<MainAppState>().selectedPage;

    //Padding, Sized Box then Column
    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Text("$page"),
            for (var lesson in lessons.indexed)
              ChapterSelectionBox(chapterName: lesson.$2.chapterName, index: lesson.$1)
          ],
        ),
      )
    );
  }
}

//Chapter Selection Box
class ChapterSelectionBox extends StatelessWidget{
  const ChapterSelectionBox({super.key, required this.chapterName, required this.index});
  final String chapterName;
  final int index;

  @override
  Widget build(BuildContext context) {
    var appState=context.watch<MainAppState>();
    return Padding(
      padding: EdgeInsets.all(10),

      child: SizedBox(
        width: double.infinity,
        height: 60,

        //Inkwell is an On Click Listener
        child:InkWell(
          onTap: (){
            print("I am tapped! $index");
            appState.changePage(index);
          },

        child: Card(
        color: Colors.blue,
        
        child: Center(
          child:Text(chapterName,
          style: TextStyle(color: Colors.white,
          fontSize: 30))
        )
        ),
      ),
      )
    );
  }
}