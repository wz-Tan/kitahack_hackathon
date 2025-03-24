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
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //----------Questions----------//
              Text(
                'Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              //----------Buttons----------//
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //----------Answer 1----------//
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 16),
                        child: Text(
                          'Answer 1',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            ),
                          ),
                      ),
                    ),
                    
                    //----------Answer 2----------//
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 16),
                        child: Text(
                          'Answer 2',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            ),
                          ),
                      ),
                    ),

                    //----------Answer 3----------//
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 16),
                        child: Text(
                          'Answer 3',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            ),
                          ),
                      ),
                    ),

                    //----------Answer 4----------//
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 16),
                        child: Text(
                          'Answer 4',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}