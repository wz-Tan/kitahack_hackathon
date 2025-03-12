import 'package:flutter/material.dart';
// import 'package:kitalearn/pages/chapter_1.dart';

class ChapterPage extends StatelessWidget {
  const ChapterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Choose the chapter',
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
class bottomBorder extends StatelessWidget {
  const bottomBorder({
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

  HoverRow({required this.text});

  @override
  _HoverRowState createState() => _HoverRowState();
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
              Image.asset(
                "assets/icons/Right-Arrow.png",
                width: 14,
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//----------Multiple Chapters----------//
class ChapterList extends StatelessWidget {
  final List<String> chapters = List.generate(14, (index) => "Chapter ${index + 1}: ");

  final List<Widget> chapterPages = [
    // Chapter1Page(),
  ];

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
            if (index != chapters.length - 1) bottomBorder(),
          ],
        );
      })
      .toList(),
    );
  }
}