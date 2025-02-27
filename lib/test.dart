
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart' as main;

class TestPage extends StatelessWidget{
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    var mainAppState=context.watch<main.MainAppState>();
    
    return SizedBox
    (
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton(
      onPressed: (){
      mainAppState.changePage(-1);
    },
    child: Text("Click Me!")));
  }
}