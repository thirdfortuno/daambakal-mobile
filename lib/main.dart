import 'package:daambakal/home.dart';
import 'package:flutter/material.dart';

import 'package:daambakal/intro.dart';
import 'package:daambakal/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/intro",
      routes: {
        "/": (context) => HomePage(),
        "/login": (context) => Login(),
        "/intro": (context) => IntroPage(),
      },
    );
  }
}
