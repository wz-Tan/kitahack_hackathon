// ignore_for_file: file_names

import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.backend});

  final dynamic backend;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: backend.retrieveLesson(), 
    builder: (context,snapshot){
      if (snapshot.hasData){
        return Text("Hello");
      }
      return Text("Loading");
    });
    
  }
}