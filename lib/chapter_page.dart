import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/account_page.dart';
import 'package:kitahack_hackathon/colours.dart';
import 'package:kitahack_hackathon/main.dart';
import 'package:kitahack_hackathon/sets_page.dart';
import 'textstyles.dart';
import "lessons_page.dart";

class ChapterPage extends StatefulWidget {
  const ChapterPage({super.key, required this.backend, required this.redrawPage});
  final dynamic backend;
  final dynamic redrawPage;

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  @override
  Widget build(BuildContext context) {
    List<String> chapterNames;

    return FutureBuilder(
      future: widget.backend.retrieveChapters(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          chapterNames = snapshot.data as List<String>;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //----------Title----------//
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 16),
                        child: SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                bottom: 13,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SetsPage(
                                              backend: widget.backend,
                                              refresh: widget.redrawPage
                                            ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.format_line_spacing_sharp),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                bottom: 13,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AccountPage(
                                              backend: widget.backend,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.account_box_rounded),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Choose A Chapter',
                                  style: defaultText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //----------Chapters---------//
                      Column(
                        children: [
                          ChapterList(chapters: chapterNames),
                          SizedBox(height: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text("Retrieving User Info", style: defaultText),
                  CircularProgressIndicator(backgroundColor: Colors.grey),
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
              Text(
                widget.text,
                style: TextStyle(color: _textColor, fontSize: 18),
              ),
              Icon(Icons.arrow_forward_ios_outlined, color: black),
            ],
          ),
        ),
      ),
    );
  }
}

//----------Multiple Chapters----------//
class ChapterList extends StatelessWidget {
  final List<String> chapters;

  const ChapterList({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          chapters.asMap().entries.map((entry) {
            int index = entry.key;
            String chapter = entry.value;

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    backend.currChapter = chapter;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonsPage(backend: backend),
                      ),
                    );
                  },
                  child: HoverRow(text: chapter),
                ),
                if (index != chapters.length - 1) BottomBorder(),
              ],
            );
          }).toList(),
    );
  }
}
