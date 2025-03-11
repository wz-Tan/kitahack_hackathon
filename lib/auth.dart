import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler{

  Future<String> register(email,password) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return "success";
    }
    on FirebaseAuthException catch (e){
      return e.code;
    }
  }

  //Register, Then Retrieve User Info and Associate the values 
  void createUser(){
    
  }

  void signIn(){

  }
}