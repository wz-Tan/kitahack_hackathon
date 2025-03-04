import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colours.dart' as colours;
import 'main.dart' as main;

//Chapters Page
class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lessons = context.watch<main.MainAppState>().lessons;

    //Padding, Sized Box then Column
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          for (var lesson in lessons.indexed)
            ChapterSelectionBox(
              chapterName: lesson.$2.chapterName,
              index: lesson.$1,
            ),
        ],
      ),
    );
  }
}

//Chapter Selection Box
class ChapterSelectionBox extends StatelessWidget {
  const ChapterSelectionBox({
    super.key,
    required this.chapterName,
    required this.index,
  });
  final String chapterName;
  final int index;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<main.MainAppState>();
    return GestureDetector(
      onTap: () {
        appState.changePage(index);
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
          ),
        ),

        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Positioned(
              left: 15,
              child: Text(
                chapterName,
                style: TextStyle(color: colours.black, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
