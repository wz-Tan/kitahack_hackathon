import 'package:flutter/material.dart';

class LessonPage extends StatefulWidget{
  const LessonPage({super.key, required this.lessonInfo});

  final dynamic lessonInfo;

  @override
  State<LessonPage> createState()=>_LessonPageState();
}

class _LessonPageState extends State<LessonPage>{

  @override
  Widget build(BuildContext context) {
    print(widget.lessonInfo);
    //Display Question Page Here
    return Text(widget.lessonInfo["explanation"]);
  }
}