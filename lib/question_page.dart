// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart' as main;
import 'colours.dart' as colours;
import 'textstyles.dart' as textstyles;

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.chapterIndex});
  final int chapterIndex;

  @override
  Widget build(BuildContext context) {
    //Take In Question List From Main
    var questionList =
        context.watch<main.MainAppState>().chapterList;

    return Container(
      color: Color(0xFFFFFFFF),
      width: double.infinity,
      height: double.infinity,
      child: Contents(questionList: questionList),
    );
  }
}

//Actual Contents, Receives Question List, Important for Navigation
class Contents extends StatefulWidget {
  const Contents({super.key, required this.questionList});
  final List<String> questionList;

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  //State Variables here
  var questionIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Get the Question List from the Widget above
    var questionList = widget.questionList;
    var currQuestion = questionList[questionIndex];

    

    return SizedBox(
      width: double.infinity,
      height: double.infinity,

      child: 
      
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Top Bar
          
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: colours.offWhite,
              border: Border(bottom: BorderSide(color:colours.black,width: 2))
            ),

            child: Padding(
              padding: EdgeInsets.all(10),

              //Stacks Text And Icons 
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Center(
                    child: Text(
                      "${questionIndex + 1}/${questionList.length}",
                      style: textstyles.defaultText,
                    ),
                  ),

                  if (questionIndex != 0)
                    Positioned(
                        left: 0,
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              questionIndex--;
                            });
                          },
                          icon: Icon(Icons.arrow_back), 
                          color: colours.black),
                      ),
                    

                  if (questionIndex != questionList.length-1)
                    Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              questionIndex++;
                            });
                          },
                          icon:Icon(Icons.arrow_forward), 
                          color: colours.black),
                    ),
                ],
              ),
            ),
          ),

          //Contents
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Hello", style: textstyles.boldedText),
            
          ),
        ],
      ),
      
    );
  }
}
