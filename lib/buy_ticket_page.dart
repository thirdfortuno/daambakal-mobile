import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StationResponse{
  final List stations;
  final bool success;

  StationResponse({this.stations,this.success});

  factory StationResponse.fromJson(Map<String, dynamic> json){
    return StationResponse(
      stations: json['stations'],
      success: json['success'],
    );
  }
}

class Station{
  final int id;
  final String name;

  Station({this.id,this.name});

  factory Station.fromJson(Map<String, dynamic> json){
    return Station(
      id: json['id'],
      name: json['name']
    );
  }
}

class TimeResponse{
  final double price;
  final bool success;
  final List times;

  TimeResponse({this.price,this.success,this.times});

  factory TimeResponse.fromJson(Map<String, dynamic> json){
    return TimeResponse(
      price: json['price'],
      success: json['success'],
      times: json['times'],
    );
  }
}

class Time{
  final String departure;
  final String arrival;
  final int trainId;

  Time({this.departure,this.arrival,this.trainId});

  factory Time.fromJson(Map<String, dynamic> json){
    return Time(
      departure: json['departure'],
      arrival: json['arrival'],
      trainId: json['train_id'],
    );
  }
}

class BuyTicketPage extends StatefulWidget{

  @override
  _BuyTicketPageState createState() => _BuyTicketPageState();
}

class _BuyTicketPageState extends State<BuyTicketPage>{

  String _token = "";

  int _stationFrom = 0;
  int _stationTo = 0;
  int _departure = 0;

  List stations = [];
  List times = [];
  List paymentMode = ["Choose Method","GCash","Load"];

  int _quantity = 1;
  double _price = 0;
  String _method = "Choose Method";

  Future<void> _showTicket(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('PNR Commuter Ticket'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Route: ${stations[_stationFrom].name} to ${stations[_stationTo].name}"),
              Text("Departure: ${times[_departure].departure}"),
              Text("Arrival: ${times[_departure].arrival}"),
              Text("Mode of Payment: $_method"),
              
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Home'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  List<Station> parseStations(String response){
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
  
    return parsed.map<Station>((json) => Station.fromJson(json)).toList();
  }

  void getStations() async {
    var response = await http.get("https://daambakal.herokuapp.com/v1/stations/list");
    StationResponse resp = StationResponse.fromJson(json.decode(response.body));
    stations = resp.stations.map((stat) => Station.fromJson(json.decode(json.encode(stat)))).toList();
    stations.insert(0, Station(id:0,name:"null"));
    setState(() {
    });
  }

  void getTime() async {
    if(_stationFrom * _stationTo != 0 && _stationFrom != _stationTo){
      var response = await http.get("https://daambakal.herokuapp.com/v1/route/info?from=$_stationFrom&to=$_stationTo");
      TimeResponse resp = TimeResponse.fromJson(json.decode(response.body));
      _price = resp.price;
      times = resp.times.map((time) => Time.fromJson(json.decode(json.encode(time)))).toList();
      times.insert(0, Time(arrival: "null",departure: "null", trainId: -1));
    }
  }

  void buyTicket() async{
    String url = 'https://daambakal.herokuapp.com/v1/tickets/buy';
    var body = {
      "token": _token,
      "from": _stationFrom,
      "to": _stationTo,
      "train_id": times[_departure].trainId,
      "quantity": _quantity
    };
    http.post(url,
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    ).then((http.Response response) {
      print(response.body);
      _showTicket(context);
    });
  }

  void initState(){
    super.initState();
    getStations();
  }

  void dispose(){

    super.dispose();
  }



  List<DropdownMenuItem> _departureList(){
    return List.generate(times.length, (i)=>i).map((int val){
      return DropdownMenuItem<int>(
        value: val,
        child: (val > 0 && times.length > 0) ? Text(times[val].departure) : Text("Select Time", style: TextStyle(color: Colors.black45)),
      );
    }).toList();
  } 

  List<DropdownMenuItem> _stationList(){
    return List.generate(stations.length, (i)=>i).map((int val){
      return DropdownMenuItem<int>(
        value: val,
        child: (val > 0 && stations.length > 0) ? Text(stations[val].name) : Text("Select Station", style: TextStyle(color: Colors.black45)),
      );
    }).toList();
  } 

  @override
  Widget build(BuildContext context){
    if(_token == "")_token = ModalRoute.of(context).settings.arguments;
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
              ),
              Container(
                height: MediaQuery.of(context).size.height - 300,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                  ]
                ),
              ),
            ],
          ),
          Positioned(
            top: 150,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 650,
              margin: EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListView(
                  children: <Widget>[
                    InkWell(
                      child: SizedBox(height: 80),
                      onTap: (){
                        getStations();
                        /*for(var i = 0; i < times.length; i++){
                          print(times[i].trainId);
                        }*/
                      },
                    ),
                    Tile(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text("From"),
                            Spacer(),
                            DropdownButton(
                              value: _stationFrom,
                              onChanged: (newVal){
                                setState(() {
                                  _stationFrom = newVal;
                                  getTime();
                                });
                              },
                              items: _stationList()
                            )
                          ],
                        )
                      ),
                    ),
                    Tile(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text('To'),
                            Spacer(),
                            DropdownButton(
                              value: _stationTo,
                              onChanged: (newVal){
                                setState(() {
                                  _stationTo = newVal;
                                  getTime();
                                });
                              },
                              items: _stationList()
                            )
                          ],
                        ),
                      ),
                    ),
                    Tile(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text("Quantity"),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.chevron_left),
                              onPressed: (_quantity == 1 || _stationTo * _stationFrom == 0 || _stationFrom == _stationTo) ? null : (){
                                setState(() {
                                  _quantity--;
                                });
                              }
                            ),
                            Text((_stationTo * _stationFrom != 0 && _stationFrom != _stationTo)?"$_quantity":""),
                            IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: (_stationTo * _stationFrom == 0 || _stationFrom == _stationTo) ? null : (){
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tile(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text('Time'),
                            Spacer(),
                            DropdownButton(
                              value: _departure,
                              onChanged: (newVal){
                                setState(() {
                                  _departure = newVal;
                                });
                              },
                              items: _departureList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Tile(
                      child: Row(
                        children: <Widget>[
                          Text("Total"),
                          Spacer(),
                          Text(
                            (_stationTo * _stationFrom != 0 && _stationFrom != _stationTo)?"${(_price*_quantity).toStringAsFixed(2)} php":"",
                            style: TextStyle(
                              color: Color(0xFFCD2F24),
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          )
                        ],
                      ),
                    ),
                    Tile(
                      child: Row(
                        children: <Widget>[
                          Text("Payment Method"),
                          Spacer(),
                            DropdownButton(
                              value: _method,
                              onChanged: (newVal){
                                setState(() {
                                  _method = newVal;
                                });
                              },
                              items: paymentMode.map<DropdownMenuItem<String>>((value){
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: value == "Choose Method" ? Colors.black45 : Colors.black),),
                                );
                              }).toList()
                            )
                        ],
                      ),
                    ),
                    Tile(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            RaisedButton(
                              child: Text("Cancel"),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                            Spacer(),
                            RaisedButton(
                              child: Text("Purchase"),
                              color: Colors.blue,
                              onPressed: (_stationTo * _stationFrom == 0 || _stationFrom == _stationTo || _method == "Choose Method") ? null : (){
                                buyTicket();
                              },
                            ),
                          ],
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 115,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Hero(
                    tag: "buy_ticket",
                    child: Image.asset(
                      'assets/buy_ticket.png',
                      scale: .5,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget{
  Tile({
    this.child
  });

  final Widget child;

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 70,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12))
      ),
      child: child
    );
  }
}