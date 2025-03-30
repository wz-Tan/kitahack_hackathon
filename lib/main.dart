import 'dart:math';
import 'textstyles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chapter_page.dart' as chapter_page;
import 'colours.dart' as colours;
import 'textstyles.dart' as textstyles;
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart' as custom_auth;
import 'login_page.dart' as login_page;
import 'backend.dart' as custom_backend;
import 'userinfo_page.dart' as userinfo_page;

dynamic backend;
dynamic auth;

void main() async {
  //Init plugins
  WidgetsFlutterBinding.ensureInitialized();

  //Init backend
  backend = custom_backend.Backend();
  auth = custom_auth.AuthHandler();
  await backend.init();

  runApp(const MainApp());
}

//API Key provider for firebase options
class EnvProvider {
  //Getter for firebase options
  static String get googleAPIKey {
    return dotenv.env["google_api_key"] ?? "Not Retrieved";
  }
}

//Global App State
class MainAppState extends ChangeNotifier {}

//Main App, Prepares State and Prompts Main Layout
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(theme: Theme.of(context), home: MainLayout()),
    );
  }
}

//Main Layout, Requires State to Navigate
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool userLoggedIn = false;

  void redrawPage(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    //Auth Listener
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (userLoggedIn == true) {
          setState(() {
            backend.userId = "";
            userLoggedIn = false;
          });
        }
      } else {
        if (userLoggedIn == false) {
          backend.userId = user.uid;
          setState(() {
            userLoggedIn = true;
          });
        }
      }
    });

    //Ensure Logged In
    if (userLoggedIn == false) {
      return login_page.LoginPage();
    }

    
    return FutureBuilder(
      future: backend.userExists(),
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return userinfo_page.UserInfoPage(
            backend: backend,
            redrawPage: redrawPage,
          );
        }
        if (snapshot.data == true) {
          return chapter_page.ChapterPage(backend: backend, redrawPage: redrawPage);
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 80,),
                Text("Retrieving User Info",style: defaultText,),
                CircularProgressIndicator(backgroundColor: Colors.grey,)
              ],
            ),
          ),
        );
      },
    );
  
  }
}
