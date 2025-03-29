
import 'package:flutter/material.dart';
import 'textstyles.dart';

class LoadingPage extends StatelessWidget{
  const LoadingPage({super.key, required this.backend, required this.redrawPage});
  final dynamic backend;
  final Function redrawPage;

  @override 
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: backend.generateQuestions(), 
      builder: (context,snapshot){
        //Pop after finished drawing and confirmed generation
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              redrawPage();
              Navigator.pop(context);
            }
          });
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 80,),
                Center(
                  child:Text("Generating Chapters... This Could Take A While.",style: defaultText,),
                ),
                CircularProgressIndicator(backgroundColor: Colors.grey,)
              ],
            ),
          ),
        );
      }
    );
  }
}