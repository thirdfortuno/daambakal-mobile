import 'package:flutter/material.dart';

class Login extends StatefulWidget{

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isRegister = false;

  static Color _colorSelected = Color(0xFF0062A6);

  Widget build(BuildContext context){
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover
              )
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 300,
                child: Center(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/app_logo_title.png',
                      height: 215,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 300,
                color: Colors.white,
                child: Container()
              ),
            ],
          ),
          Positioned(
            top: 275,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Center(
                        child: Text("${isRegister ? 'Registration' : 'Login'}")
                      )
                    ),
                  ),
                  Spacer()
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}