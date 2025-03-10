import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/colours.dart';
import 'lesson_page.dart' as lesson_page;

//Fetch Info of Selected Lesson
Future<dynamic> retrieveLessonInfo(lessonPath) async {
  dynamic lessonInfo;
  await lessonPath.get().then((docSnapshot) {
    lessonInfo = docSnapshot.data();
  });
  return lessonInfo;
}

//This Page Is Used to Display All Lessons Available (Display Cards, When Click Change AppState Chapter Path, then future builder to retrieve info)
class LessonSelectionPage extends StatefulWidget {
  const LessonSelectionPage({
    super.key,
    required this.lessonList,
    required this.lessonsPath,
  });

  final List<String> lessonList;
  final dynamic lessonsPath;

  @override
  State<LessonSelectionPage> createState() => _LessonSelectionPageState();
}

//Controls Page Switching  (0 for Lesson Selection, 1 for Selected Lesson)
class _LessonSelectionPageState extends State<LessonSelectionPage> {
  late dynamic lessonPath;
  int currPage=0;

  void changePage(int pageNum){
    setState(() {
      currPage=pageNum;
    });
  }

  void setLessonPath(dynamic path){
    setState(() {
      lessonPath=path;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (currPage==0){
      return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          //Pass in Functions By reference
          for (var lesson in widget.lessonList)
            LessonCard(lessonName: lesson, lessonsPath: widget.lessonsPath, changePage: changePage, changePath: setLessonPath,),
        ],
      ),
    );
    }
    else{
      return FutureBuilder(
        future: retrieveLessonInfo(lessonPath), 
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData){
            return lesson_page.LessonPage(lessonInfo: snapshot.data);
          }
          else if (snapshot.hasError){
            print(snapshot.error);
          }
          return Text("Loading Lesson Info");
        }
        );
      
    }
    
  }
}

//Card for EACH lesson card
class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lessonName,
    required this.lessonsPath,
    required this.changePage,
    required this.changePath,
  });

  final String lessonName;
  final dynamic lessonsPath;
  final Function(int) changePage;
  final Function(dynamic) changePath;

  @override
  Widget build(BuildContext context) {

    //When A Card Is Clicked, Retrieve Data and Switch Screens
    return GestureDetector(
      onTap: () {
        changePath(lessonsPath.doc(lessonName));
        changePage(1);
      },

      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
          ),
        ),

        //The Box For Each Chapter
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Positioned(
              left: 15,
              child: Text(
                lessonName,
                style: TextStyle(color: black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
