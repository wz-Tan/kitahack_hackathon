import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chapters_page.dart' as chapters_page;
import 'lesson_questions_page.dart' as lesson_question_selection_page;
import 'colours.dart' as colours;
import 'textstyles.dart' as textstyles;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'auth.dart' as custom_auth;
import 'login_page.dart' as login_page;
import 'backend.dart' as custom_backend;


dynamic backend;
dynamic auth;

void main() async {
  //Init plugins
  WidgetsFlutterBinding.ensureInitialized();

  backend=custom_backend.Backend();
  auth=custom_auth.AuthHandler();
  await backend.init();
  auth.createAuthListener(); 

  //Load Env File
  await dotenv.load(fileName: ".env");
  

  //Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

//API Key provider for firebase options
class EnvProvider{
  //Getter for firebase options
  static String get googleAPIKey{
    return dotenv.env["google_api_key"] ?? "Not Retrieved";
  }
}

//Global App State
class MainAppState extends ChangeNotifier {
  //Initialise the firebase client
  final db = FirebaseFirestore.instance;

  //Username needs to be from token.
  final username = "Wz";

  //See if logged in, check token
  bool loggedIn=false;

  //0 For Main Page, 1 for Chapter Selected
  int selectedPage = -1;
  late int latestSet;
  late dynamic setPath;
  late List<String> chapterList=[];
  late String currChapter;
  bool isLoading=true;

  void notifyLoggedIn(){
    loggedIn=true;
    notifyListeners();
  }

  //Get data from firestore
  Future initData() async {
    dynamic userInfo;

    //Acquire User Info
    await db.collection("Users").doc(username).get().then((
      DocumentSnapshot doc,
    ) {
      userInfo = doc.data();
    });

    latestSet = userInfo["latest_set"];

    //Get Set Path to Run Faster 
    setPath = db
        .collection("Users")
        .doc(username)
        .collection("Set $latestSet");

    //Get Chapter ID  (Create Chapter Card For Each)
    await setPath
        .get()
        .then(
          (QuerySnapshot query) {
            for (var doc in query.docs){
              chapterList.add(doc.id);
          }
        }
      );
    
    //Sort based on chapter number  (Split between spaces then retrieve the 2nd index, which is the number)
    chapterList.sort((a,b){
      int numA=int.parse(a.split(" ")[1].replaceAll(":", ""));
      int numB=int.parse(b.split(" ")[1].replaceAll(":", ""));
      return numA.compareTo(numB);
    });

    isLoading=false;
    notifyListeners();
  }

  void changePage(int page) {
    selectedPage = page;
    notifyListeners();
  }

}

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

class _MainLayoutState extends State<MainLayout>{

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MainAppState>();

    if (appState.loggedIn==false){
      return login_page.LoginPage();
    }
    
    var selectedPage = appState.selectedPage;
    String topAppBarText;
    Widget displayedPage;

    if (selectedPage == 0) {
      topAppBarText = "Home Page";
      displayedPage = chapters_page.ChaptersPage();
    }
    
    else if (selectedPage==-1){
      topAppBarText=appState.currChapter;
      displayedPage=lesson_question_selection_page.LessonQuestionsPage(chapterName: appState.currChapter);
    }
    else{
      topAppBarText="No Contents Yet";
      displayedPage=chapters_page.ChaptersPage();
    }

    return Scaffold(
      //Top App Bar
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),

        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.bottomCenter,

          child: Stack(
            children: [
              if (selectedPage != -1)
                Positioned(
                  right: 10,
                  bottom: 5,
                  child: IconButton(
                    onPressed: () {
                      appState.changePage(-1);
                    },
                    icon: Icon(Icons.home),
                    color: colours.black,
                  ),
                ),

              Positioned(
                left: 10,
                bottom: 5,
                child: Text(topAppBarText,style:textstyles.boldedText)
              ),
            ],
          ),
        ),
      ),

      //Contents
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: displayedPage,
      ),
    );
  }
}
