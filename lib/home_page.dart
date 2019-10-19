import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserResponse{
  final int tickets;
  final double wallet;
  final String fullName;
  final String accountNumber;

  UserResponse({this.tickets,this.wallet,this.fullName,this.accountNumber});

  factory UserResponse.fromJson(Map<String, dynamic> json){
    return UserResponse(
      tickets: json['tickets'],
      wallet: json['wallet'],
      fullName: json['full_name'].toString(),
      accountNumber: json['account_number']
    );
  }
}

class User{
  int tickets = 0;
  double wallet = 0;
  String name = "";
  String accountNumber = "";
  String token = "";
}

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  //Account stuff
  /*
  String _name = "Cardo Dalisay";
  String _accountNo = "DBPH-00001";
  int _tickets = 0;
  double _load = 53.00;*/

  String _token = "";

  User user = new User();

  void getUserInfo() async{
    var response = await http.get('https://daambakal.herokuapp.com/v1/user/info/$_token');
    print(response);
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    _token = ModalRoute.of(context).settings.arguments;
    getUserInfo();
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
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 300,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: Hero(
                            tag: "logo",
                            child: Image.asset('assets/app_logo.png'),
                          ),
                        ),
                        Text(
                          " $user.name",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Column(
                          children: <Widget>[
                            Text(
                              user.accountNumber,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Account Number",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 300,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 80),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Image.asset(
                                  'assets/buy_ticket.png',
                                  scale: .5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Buy Ticket',
                                style: TextStyle(
                                  color: Color(0xFF0061A6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Image.asset(
                                  'assets/schedule.png',
                                  scale: .5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Schedule',
                                style: TextStyle(
                                  color: Color(0xFF0061A6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          height: 180,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Image.asset(
                                  'assets/news_updates.png',
                                  scale: .5,  
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'News and\nUpdates',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0061A6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 180,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Image.asset(
                                  'assets/promos_rewards.png',
                                  scale: .5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Promos and\nRewards',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0061A6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer()
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 250,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 100,
                      width: 180,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "My Tickets",
                            style: TextStyle(
                              color: Color(0xFF0061A6),
                              fontSize: 18
                            ),
                          ),
                          Text("${user.tickets} Tickets")
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 100,
                      width: 180,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "My Wallet",
                            style: TextStyle(
                              color: Color(0xFF0061A6),
                              fontSize: 18
                            ),
                          ),
                          Text(
                            "PHP ${user.wallet.toStringAsFixed(2)} Balance Load"
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}