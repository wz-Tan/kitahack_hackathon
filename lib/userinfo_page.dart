import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_list/country_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                        hintText: 'Country',
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
                    errorMessage=await infoCheck(
                      backend,
                      nameController.text,
                      ageController.text,
                      locationController.text,
                    );

                    if(errorMessage!=""){
                        Fluttertoast.showToast(
                          msg: errorMessage,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                    }
                    
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

Future<String> infoCheck(dynamic backend, String name, String age, String countryInput) async {
  String countryName=" $countryInput";
  List<String> countryList=[];
  for (var country in Countries.list){
    countryList.add(country.name.toLowerCase().trim());
  }

  int ageVal = int.parse(age);
  if ((age == "" || countryName == "") || name == "") {
    return "Please Fill in All Fields.";
  }
  if (ageVal >= 100) {
    return "Please Ensure Your Age is Correct.";
  }
  if (countryList.contains(countryName.toLowerCase())){
    return "Please Insert A Valid Country"; 
  }
  else{
    await backend.createUser(name,age,countryName);
  }

  return "";
}
