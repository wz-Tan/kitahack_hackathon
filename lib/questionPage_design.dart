// ignore_for_file: file_names
import 'textstyles.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.backend});

  final dynamic backend;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currQuestion = 0;
  dynamic questions;
  String topic = "";
  String explanation = "";
  String example = "";

  Future<dynamic> fetchQuestions() async {
    final questions = await widget.backend.retrieveLesson();
    setState(() {
      topic = questions["topicList"][currQuestion]["topic"];
      explanation = questions["topicList"][currQuestion]["explanation"];
      example = questions["topicList"][currQuestion]["example"];
    });
    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchQuestions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(width: double.infinity, height: 40),
                    Stack(
                      children: [
                        Positioned(
                          left: 10,
                          bottom: 5,
                          child: GestureDetector(
                            onTap: () {
                              if (context.mounted){
                                Navigator.pop(context);
                              }
                            },
                            child: Icon(Icons.home),
                          )

                        ),
                        Center(
                          child: Text(
                            topic,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey, height: 2),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Stack(
                      children: [
                        if (currQuestion!=0)
                        Positioned(
                        left: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap:()=> setState(() {
                            currQuestion--;
                          }),
                          child:Icon(Icons.arrow_back_ios_sharp),
                        
                      ),
                        ),
                      if (currQuestion!=2)
                        Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap:()=> setState(() {
                            currQuestion++;
                          }),
                          child:Icon(Icons.arrow_forward_ios_sharp), 
                        )
                         
                        )
                      ] 
                    ),
                  ),
                  Text(
                    "What Is It?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(width: double.infinity, height: 10),
                  Text(
                    explanation,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(width: double.infinity, height: 20),
                  Text(
                    "Example:",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(width: double.infinity, height: 10),
                  Text(
                    example,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 80),
                Text("Loading", style: defaultText),
                CircularProgressIndicator(backgroundColor: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
