
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'textstyles.dart';

class LoadingPage extends StatelessWidget{
  const LoadingPage({super.key, required this.backend});
  final dynamic backend;

  @override 
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: backend.generateQuestions(), 
      builder: (context,snapshot){
        //Pop after finished drawing and confirmed generation
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pop(context);
              //Can Redraw the Page here
            }
          });
        }
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              children: [
                Text("Generating Chapters... This Could Take A While.",style: defaultText,),
                CircularProgressIndicator(backgroundColor: Colors.grey,)
              ],
            ),
          ),
        );
      }
    );
  }
}