import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler{  

  void createAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user){
        if (user==null){
          print("User is signed out!");
        }
        else{
          print(user.uid);
        }
      }
    );
  }

  Future<String> register(email,password) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await signIn(email=email,password=password);
      //Prompt Create User
      return "success";
    }
    on FirebaseAuthException catch (e){
      return e.code;
    }
  }

  //Register, Then Retrieve User Info and Associate the values 
  void createUser(){
    
  }

  Future<String> signIn(email,password) async{

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password);
        return "success";
    }
    on FirebaseAuthException catch(e){
      return e.code;
    }
  }
}