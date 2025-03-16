import 'package:firebase_auth/firebase_auth.dart';


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

  Future<String> signIn(email,password) async{

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password);
        print("Sign In Success");
        return "success";
    }
    on FirebaseAuthException catch(e){
      return e.code;
    }
  }

  Future <void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}