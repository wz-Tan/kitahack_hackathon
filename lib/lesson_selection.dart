import 'package:flutter/material.dart';

import 'main.dart' as main;

//This Page Is Used to Display All Lessons Available
class LessonSelectionPage extends StatefulWidget{
  const LessonSelectionPage({super.key, required this.lessonList});

  final List<String> lessonList;

  @override
  State<LessonSelectionPage> createState()=>_LessonSelectionPageState();
}


class _LessonSelectionPageState extends State<LessonSelectionPage>{
  @override
  Widget build(BuildContext context) {

    print(widget.lessonList);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          for (var lesson in widget.lessonList)
          LessonCard(lessonName: lesson)
        ],
      ),
    );
  }
}

class LessonCard extends StatelessWidget{
  const LessonCard({super.key, required this.lessonName});

  final String lessonName; 

  @override
  Widget build(BuildContext context) {
    return Text(lessonName);
  }
}