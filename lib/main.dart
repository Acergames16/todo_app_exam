import 'package:flutter/material.dart';
import 'package:todo_app_exam/screens/homescreen/home.screen.dart';

void main(){
  runApp(MaterialApp(home: MyApp(),));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}