import 'package:flutter/material.dart';
import 'package:quiflutter/homepage.dart';
import 'package:quiflutter/style/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: quizMainPanelColor,
      ),
      //---------------  Go to main root widget - Homepage  --------------------
      home: MyHomePage(title: 'Flutter quiz'),
    );
  }
}

