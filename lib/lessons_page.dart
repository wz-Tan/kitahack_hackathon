import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/colours.dart';
import 'package:kitahack_hackathon/questionPage_design.dart';
import 'textstyles.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key, required this.backend});
  final dynamic backend;

  @override
  Widget build(BuildContext context) {
    List<String> lessonNames;

    return FutureBuilder(
      future: backend.retrieveLessons(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lessonNames = snapshot.data as List<String>;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //----------Title----------//
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 16),
                        child: Text(
                          'Choose A Lesson',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      //----------Chapters---------//
                      Column(
                        children: [
                          LessonList(lessons: lessonNames, backend:backend),
                          SizedBox(height: 16),
                        ],
                      ),
                    ],
                  ),
              ),
            ),
          );
        } else {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: CircularProgressIndicator(backgroundColor: Colors.grey),
                  )
                  ,
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

//----------Divider----------//
class BottomBorder extends StatelessWidget {
  const BottomBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Divider(color: Colors.grey),
    );
  }
}

//----------HoverEffect----------//
class HoverRow extends StatefulWidget {
  final String text;

  const HoverRow({required this.text, super.key});

  @override
  createState() => _HoverRowState();
}

class _HoverRowState extends State<HoverRow> {
  Color _backgroundColor = Colors.transparent;
  Color _textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MouseRegion(
        onEnter:
            (_) => setState(() {
              _backgroundColor = Color(0xff002abc);
              _textColor = Colors.white;
            }),
        onExit:
            (_) => setState(() {
              _backgroundColor = Colors.transparent;
              _textColor = Colors.black;
            }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.text, style: TextStyle(color: _textColor, fontSize: 18)),
              Icon(Icons.arrow_forward_ios_outlined, color: black),
            ],
          ),
        ),
      ),
    );
  }
}

//----------Multiple Chapters----------//
class LessonList extends StatelessWidget {
  
  final dynamic backend;
  final List<String> lessons;

  const LessonList({super.key, required this.lessons, required this.backend});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          lessons.asMap().entries.map((entry) {
            int index = entry.key;
            String lesson = entry.value;

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    backend.currLesson=lesson;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(backend: backend)
                      ),
                    );
                  },
                  child: HoverRow(text: lesson),
                ),
                if (index != lessons.length - 1) BottomBorder(),
              ],
            );
          }).toList(),
    );
  }
}
