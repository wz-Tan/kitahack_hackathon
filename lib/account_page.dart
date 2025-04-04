import 'package:flutter/material.dart';
import 'textstyles.dart';
import 'package:kitahack_hackathon/colours.dart';
import 'auth.dart' as auth;

class AccountPage extends StatelessWidget {
  final dynamic backend;
  const AccountPage({super.key, required this.backend});

  @override
  Widget build(BuildContext context) {
    final name = backend.userInfo["name"];
    final age = backend.userInfo["age"];
    final location = backend.userInfo["location"];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 50, left: 10, right: 10),
        color: offWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Positioned(
                  left: 20,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.keyboard_return_rounded),
                  ),
                ),
                Center(child: Text('Your Account Info', style: defaultText)),
              ],
            ),
            SizedBox(width: double.infinity, height: 30),

            Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0x99000abc),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Name', style: whiteDefaultText),
                  Text(name, style: whiteSmallText),
                ],
              ),
            ),
            SizedBox(width: double.infinity, height: 30),

            Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0x99000abc),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Age', style: whiteDefaultText),
                  Text(age, style: whiteSmallText),
                ],
              ),
            ),
            SizedBox(width: double.infinity, height: 30),

            Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0x99000abc),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Location', style: whiteDefaultText),
                  Text(location, style: whiteSmallText),
                ],
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 200,
            ),

            GestureDetector(
              onTap: (){
                backend.userInfoRetrieved=false;
                auth.AuthHandler().signOut();
                if (context.mounted){
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red[500],
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Center(child: Text("Sign Out", style: whiteSmallText)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
