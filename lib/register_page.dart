import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterResponse{
  final bool success;
  final String message;
  final String token;

  RegisterResponse({this.success, this.message, this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json){
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      token: json['token'].toString()
    );
  }
}

class Register extends StatefulWidget{

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String _firstName;
  String _lastName;
  String _number;
  String _password;
  String _confirmPass;

  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _confirmController = TextEditingController();

  RegisterResponse resp = new RegisterResponse();

  String _message = "";

  final RegExp _numberExp = new RegExp(r"9[0-9]{9}");

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
    
    String url = 'https://daambakal.herokuapp.com/v1/auth/register';
    var body = {
      "number": int.parse(_number),
      "first_name": _firstName,
      "last_name": _lastName,
      "password": _password,
    };
    //print(body);
    
    http.post(Uri.encodeFull(url),
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    ).then((http.Response response) {
      resp = RegisterResponse.fromJson(json.decode(response.body));
      if(resp.success){
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          '/home',
          arguments: resp.token,  
        );
      }else{
        setState(() {
         _message = resp.message ?? 'Registration failed'; 
        });
      }
    });
    return null;
  }

  void register(){
    bool valid = true;
    setState((){
      _message = "";
      if (_firstName.isEmpty){
        _message += "First Name must not be empty\n";
        valid = false;
      }
      if (_lastName.isEmpty){
        _message += "Last Name must not be empty\n";
        valid = false;
      }
      if(!_numberExp.hasMatch(_number) || _number.length != 10){
        _message += "Number must match format 9xxxxxxxxx\n";
        valid = false;
      }
      if(_password.length < 8){
        _message += "Password must have 8 or more characters\n";
        valid = false;
      } else if (_password != _confirmPass){
        _message += "Password and Confirm Password must match";
        valid = false;
      }
      if(valid) fetchPost();
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
                height: MediaQuery.of(context).size.height/3,
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
                height: 2*MediaQuery.of(context).size.height/3,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _firstController,
                      decoration: InputDecoration(
                        labelText: "First Name",
                      ),
                    ),
                    TextField(
                      controller: _lastController,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                      ),
                    ),
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
                    TextField(
                      obscureText: true,
                      controller: _confirmController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password"
                      ),
                    ),
                    Text(_message),
                    SizedBox(height: 20),
                    RaisedButton(
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                          ),
                      onPressed: (){
                        _number = _numberController.text;
                        _password = _passwordController.text;
                        _firstName = _firstController.text;
                        _lastName = _lastController.text;
                        _confirmPass = _confirmController.text;
                        register();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height/3 - 25,
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
                        child: Text("Register")
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