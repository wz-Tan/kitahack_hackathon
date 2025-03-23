import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //----------Title----------//
              Text(
                'TITLEEEEEE',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000abc),
                ),
              ),
              SizedBox(height: 50),

              //----------Button----------//
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Center(
                        child: Text(
                          'Lessons',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            ),
                          ),
                      ),
                    ),
                    
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Color(0xff002abc),
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Center(
                        child: Text(
                          'Questions',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}