import 'package:flutter/material.dart';

class IntroSection extends StatelessWidget{
  IntroSection({
    this.image,
    this.title,
    this.description,
    this.order
  });

  final image;
  final title;
  final description;
  final order;
  final orderMax = 5;

  List<Widget> orderDots(){
    var current = Icon(Icons.lens, color: Color(0xFF56C4EA));
    var others = Icon(Icons.panorama_fish_eye);
    List<Widget> dots = new List.generate(orderMax, (i) => i == order - 1 ? current : others);
    dots.insert(0, Spacer());
    dots.add(Spacer());
    return dots;
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  child: Text("Skip"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/login");
                  },
                ),
              ],
            ),
            Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.scaleDown
                )
              ),
            ),
            Container(
              height: 140,
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: orderDots(),
            ),
            SizedBox(height: 100),
            order == orderMax ? 
              Container(
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    RaisedButton(
                      child: Text("Login"),
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                    Spacer(),
                    RaisedButton(
                      child: Text("Register"),
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ) :
              Container(),
          ],
        ),
      )
    );
  }
}

class IntroPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Material(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              AppBar(
                bottom: TabBar(
                  tabs: <Widget>[
                    Text("1"),
                    Text("2"),
                    Text("3"),
                    Text("4"),
                    Text("5"),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover
                  )
                ),
              ),
              TabBarView(
                children: <Widget>[
                  IntroSection(
                    image: AssetImage('assets/app_logo_title.png'),
                    title: "Welcome to\nDAAMBAKAL PH",
                    description: "Philippine National Railways Ticket Selling Mobile Application",
                    order: 1,
                  ),
                  IntroSection(
                    image: AssetImage('assets/buy_ticket_intro.png'),
                    title: "Buy tickets without hassle",
                    description: "Choose your destination and buy tickets in just a few taps.",
                    order: 2,
                  ),
                  IntroSection(
                    image: AssetImage('assets/schedule_intro.png'),
                    title: "Check the Schedule",
                    description: "Check the Northbound/Southbound schedules of Philippine National Railways.",
                    order: 3,
                  ),
                  IntroSection(
                    image: AssetImage('assets/news_intro.png'),
                    title: "News and Updates",
                    description: "See the latest news and updates about Philippine National Railways.",
                    order: 4,
                  ),
                  IntroSection(
                    image: AssetImage('assets/promos_intro.png'),
                    title: "Promos and Rewards",
                    description: "Enjoy the promos and rewards for every transaction.",
                    order: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}