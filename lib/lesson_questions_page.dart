import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colours.dart' as colours;
import 'textstyles.dart' as textstyles;
import 'lesson_selection.dart' as lesson_selection;
import 'main.dart' as main;

//Something wrong here
Future <List<String>> retrieveLessons(path) async{
  List<String> lessonList = [];
  await path.collection("Lessons").get().then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      lessonList.add(doc.id);
    }
  });
  return lessonList;
}

class LessonQuestionsPage extends StatefulWidget {
  const LessonQuestionsPage({super.key, required this.chapterName});

  final String chapterName;

  @override
  State<LessonQuestionsPage> createState() => _LessonQuestionsState();
}

class _LessonQuestionsState extends State<LessonQuestionsPage> {
  //0 for questions/exercise selection/1 for lessons/2 for exercises
  int currPage = 0;

  @override
  Widget build(BuildContext context) {
    var setPath=context.watch<main.MainAppState>().setPath;
    var path=setPath.doc(widget.chapterName);

    if (currPage == 0) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,

        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

          //Questions/Summative Exercises
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      currPage=1;
                    });
                  },
                  child:Container(
                  width: 100,
                  height: 40,
                  color: colours.midBlue,
                  child: Text(
                    "Lessons",
                    style: textstyles.whiteDefaultText,
                    textAlign: TextAlign.center,
                  ),
                ),
                )
              ),

              Container(
                width: 100,
                height: 40,
                color: colours.midBlue,
                child: Text(
                  "Exercises",
                  style: textstyles.whiteDefaultText,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else if (currPage==1){
      //Call the Lesson Retriever, Then Store the Value Inside of the Snapshot 
      //(Generate Info Before Opening Lessons Page)
      return FutureBuilder(
        future: retrieveLessons(path), 
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if (snapshot.hasData){
            return lesson_selection.LessonSelectionPage(lessonList: snapshot.data);
          }
          else if(snapshot.hasError){
            return Text('Failed');
          }
          return LinearProgressIndicator(value: null, borderRadius: BorderRadius.circular(360),);
      }
      );
    }
    
    return Text("Current Page is $currPage");
  }
}
