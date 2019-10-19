import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResponse{
  final bool success;
  final String message;
  final String token;

  LoginResponse({this.success, this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      token: json['token'].toString()
    );
  }
}

class Login extends StatefulWidget{

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _number;
  String _password;

  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();

  final RegExp _numberExp = new RegExp(r"9[0-9]{9}");

  String _message = "";

  LoginResponse resp = new LoginResponse();

  @override
  void initState(){
    super.initState();
    _message = "";
  }

  @override
  void dispose(){

    super.dispose();
  }

  Future<http.Response> fetchPost() async{
    String url = 'https://daambakal.herokuapp.com/v1/auth/login';
    var body = {
      "number": int.parse(_number),
      "password": _password,
    };
    print(body);
    
    http.post(url,
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    ).then((http.Response response) {
      resp = LoginResponse.fromJson(json.decode(response.body));
      if(resp.success){
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          '/home',
          arguments: resp.token
        );
      }else{
        setState(() {
          _message = "Login Failed. Please check credentials";
        });
      }
      print(resp.success);
      print(resp.message);
      print(resp.token);
      //if(response.body.)
    });
    return null;
  }

  void login(){
    bool valid = true;
    setState((){
      _message = "";
      if(!_numberExp.hasMatch(_number) || _number.length != 10){
        _message += "Number must match format 9xxxxxxxxx\n";
        valid = false;
      }
      if(_password.isEmpty){
        _message += "Please enter password";
        valid = false;
      }
      if(valid){
        fetchPost();
        _message = "Processing";
      }
    });
  }

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
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Format: \"9xxxxxxxxx\""
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password"
                      ),
                    ),
                    Text(_message),
                    SizedBox(height: 20),
                    RaisedButton(
                      child: Text(
                        "Log In",
                        textAlign: TextAlign.center,
                          ),
                      onPressed: (){
                        _number = _numberController.text;
                        _password = _passwordController.text;
                        login();
                      },
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      child: Text(
                        "Register Here",
                        textAlign: TextAlign.center,
                          ),
                      onPressed: (){
                        Navigator.pushNamed(context, "/register");
                      },
                    ),
                  ],
                ),
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
                        child: Text("Login")
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
