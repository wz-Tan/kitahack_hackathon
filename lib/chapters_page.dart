
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart' as main;

//Chapters Page
class ChaptersPage extends StatelessWidget{
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lessons=context.watch<main.MainAppState>().lessons;

    //Padding, Sized Box then Column
    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            for (var lesson in lessons.indexed)
              ChapterSelectionBox(chapterName: lesson.$2.chapterName, index: lesson.$1)
          ],
        ),
      )
    );
  }
}

//Chapter Selection Box
class ChapterSelectionBox extends StatelessWidget{
  const ChapterSelectionBox({super.key, required this.chapterName, required this.index});
  final String chapterName;
  final int index;

  @override
  Widget build(BuildContext context) {
    var appState=context.watch<main.MainAppState>();
    return Padding(
      padding: EdgeInsets.all(10),

      child: SizedBox(
        width: double.infinity,
        height: 60,

        //Inkwell is an On Click Listener
        child:InkWell(
          onTap: (){
            print("I am tapped! $index");
            appState.changePage(index);
          },

        child: Card(
        color: Colors.blue,
        
        child: Center(
          child:Text(chapterName,
          style: TextStyle(color: Colors.white,
          fontSize: 30))
        )
        ),
      ),
      )
    );
  }
}