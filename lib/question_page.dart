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

    return Container(
      color: main.lightBlue,
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

      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Top Bar
            Container(
              color: main.darkBlue,
              width: double.infinity,
              height: 50,

              child: Padding(
                padding: EdgeInsets.all(10),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    if(questionIndex!=0)
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      ),

                    //Expanded to Use Align Width
                    Text("${questionIndex+1}/${questionList.length}",style: main.defaultText,textAlign: TextAlign.center,),
                     Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      ),
                  ],
                ),
                )
            ),

            //Contents
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(description,style: main.questionText)
              )
            
      ],
      
    ),
    );
    
    
  }
}