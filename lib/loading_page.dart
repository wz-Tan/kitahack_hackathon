import 'package:flutter/material.dart';
import 'textstyles.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
    required this.backend,
    required this.redrawPage,
  });
  final dynamic backend;
  final Function redrawPage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: backend.generateQuestions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                redrawPage();
                Navigator.pop(context);
              }
            });
          } else {
            return Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Text(
                      "Please Wait A Minute Before Each Chapter Generation.",
                      style: defaultText,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 80),
                    GestureDetector(
                      onTap: () {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0x99000abc),
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Center(
                          child: Text("Got It!", style: whiteSmallText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 80),
                Text(
                  "Generating Chapters... This Could Take A While.",
                  style: defaultText,
                  textAlign: TextAlign.center,
                ),

                CircularProgressIndicator(backgroundColor: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
