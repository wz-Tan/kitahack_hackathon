import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/colours.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lessonInfo});

  final dynamic lessonInfo;

  @override
  State<LessonPage> createState() => _LessonPageState();
}


class _LessonPageState extends State<LessonPage> {
  int currQuestion=0;

  @override
  Widget build(BuildContext context) {
    var questionList=widget.lessonInfo["questions"];

    //Print to Test the Variable
    print(widget.lessonInfo);
    //Display Question Page Here
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          //Top Stack for Navigation Between Pages
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              children: [
                if (currQuestion != 0)
                  Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currQuestion--;
                      });
                    },
                    child: Icon(Icons.arrow_back_ios_new, color: black),
                  ),
                ),

                //Next Button 
                if (currQuestion!=questionList.length-1)
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currQuestion++;
                      });
                    },
                    child: Icon(Icons.arrow_forward_ios, color: black),
                  ),
                ),
              ],
            ),
          ),

          //Contents Go Here (Display Lesson, Question and Choices)
          Text(questionList[currQuestion]["description"])
        ],
      ),
    );
  }
}
