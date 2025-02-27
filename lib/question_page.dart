import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart' as main;

class QuestionPage extends StatelessWidget{
  const QuestionPage({super.key, required this.chapterIndex});
  final int chapterIndex;

  @override
  Widget build(BuildContext context) {
    //Take In Question List From Main
    var questionList=context.watch<main.MainAppState>().lessons[chapterIndex].questionList;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Contents(questionList: questionList)
    );
  }
}

//Actual Contents, Receives Question List, Important for Navigation
class Contents extends StatefulWidget{
  const Contents({super.key, required this.questionList});
  final List<main.Question> questionList;

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {

  @override
  Widget build(BuildContext context) {
    //Get the Question List from the Widget above
    var questionList=widget.questionList;
    var questionIndex=0;
    var currQuestion=questionList[questionIndex];


    String description=currQuestion.description;
    String difficulty=currQuestion.difficulty;
    String answer=currQuestion.answer;
    String hint=currQuestion.hint;

    
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
      children: [
        Text(description),
        Text(hint),
        Text(answer),
        Text("Difficulty is: $difficulty"),
      ],
    ),
    );
    
    
  }
}