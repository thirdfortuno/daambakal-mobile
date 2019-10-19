import 'package:daambakal/home_page.dart';
import 'package:flutter/material.dart';
import 'package:daambakal/register_page.dart';
import 'package:daambakal/intro_page.dart';
import 'package:daambakal/login_page.dart';

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
        "/register": (context) => Register()
      },
    );
  }
}
