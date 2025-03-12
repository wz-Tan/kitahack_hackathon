import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class AuthHandler{

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