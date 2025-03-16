import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

RegExp numericRegex = RegExp(r'^[0-9]+$');

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key, required this.backend});
  final dynamic backend;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final locationController = TextEditingController();
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
                'Enter Your Information',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002abc),
                ),
              ),
              SizedBox(height: 50),

              //----------Name TextField----------//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              //----------Age TextField----------//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: ageController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(numericRegex),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Age',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              //Location TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Location',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),

              //----------Button----------//
              //Create User Account
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () async {
                    print("All information here");
                    errorMessage=await infoCheck(
                      backend,
                      nameController.text,
                      ageController.text,
                      locationController.text,
                    );
                    print(errorMessage);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xff002abc),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> infoCheck(dynamic backend, String name, String age, String location) async {
  var response=await backend.locationExists("Malaysia");
  print(response);
  int ageVal = int.parse(age);
  if ((age == "" || location == "") || name == "") {
    return "Please Fill in All Fields.";
  }
  try {
    if (ageVal >= 100) {
      return "Please Ensure Your Age is Correct.";
    }
    if (backend.locationExists(location) == "no") {
      return "This location is not valid";
    }
  } catch (e) {
    return e.toString();
  }
  return "";
}
