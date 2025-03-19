import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/colours.dart';
import 'textstyles.dart';

class ChapterPage extends StatelessWidget {
  const ChapterPage({super.key, required this.backend});
  final dynamic backend;

  @override
  Widget build(BuildContext context) {
    List<String> chapterNames;

    return FutureBuilder(
      future:backend.retrieveChapters(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          chapterNames=snapshot.data as List<String>;
          return Text(chapterNames.first);
        }

        else{
          return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 80,),
                Text("Retrieving Chapters",style: defaultText,),
                CircularProgressIndicator(backgroundColor: Colors.grey,)
              ],
            ),
          ),
        );
        }
      }
    );
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                //----------Title----------//
                Padding(
                  padding: const EdgeInsets.only(top:  25, bottom: 16),
                  child: Text(
                    'Choose A Chapter to Learn!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            
                //----------Chapters---------//
                Column(
                  children: [
                    ChapterList(),
                    SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//----------Divider----------//
class BottomBorder extends StatelessWidget {
  const BottomBorder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Divider(
        color: Colors.grey,
      ),
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
        onEnter: (_) => setState(() {
          _backgroundColor = Color(0xff002abc);
          _textColor = Colors.white;
          }),
        onExit: (_) => setState(() {
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
                style: TextStyle(color: _textColor),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: black,
              )
            ],
          ),
        ),
      ),
    );
  }
}

//----------Multiple Chapters----------//
class ChapterList extends StatelessWidget {

  //Feed Chapters Here
  final List<String> chapters = List.generate(14, (index) => "Chapter ${index + 1}: ");

  final List<Widget> chapterPages = [
    // Chapter1Page(),
  ];

  ChapterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: chapters
      .asMap()
      .entries
      .map((entry) {
        int index = entry.key;
        String chapter = entry.value;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => chapterPages[index]),
                );
              },
              child: HoverRow(text: chapter)
            ),
            if (index != chapters.length - 1) BottomBorder(),
          ],
        );
      })
      .toList(),
    );
  }
}