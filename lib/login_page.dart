import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth.dart' as auth;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String errorMessage = "";

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //----------Title----------//
              Text(
                'kitaLearn',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002abc),
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Welcome back you've been missed!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),

              //----------Email TextField----------//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),

                //Email Container
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              //----------Password TextField----------//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //Password Container
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    //Password TextField
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),

              //----------Button----------//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),

                child: Container(
                  padding: EdgeInsets.all(12),

                  child: GestureDetector(
                    onTap: () async {
                      if (!validEmail(emailController.text)) {
                        errorMessage = "Invalid Email Format";
                      } else if (passwordController.text == "") {
                        errorMessage = "Password is Empty";
                      } else {
                        //Run Email Authentication Here
                        errorMessage = await auth.AuthHandler().signIn(
                          emailController.text,
                          passwordController.text,
                        );
                      }

                      //Return Toast Notif
                      if (errorMessage != "success") {
                        Fluttertoast.showToast(
                          msg: errorMessage,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        //After Logged In Can Switch to Chapters
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),

              //----------Create new account----------//
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Create new account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

bool validEmail(emailInput) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(emailInput);
  }
