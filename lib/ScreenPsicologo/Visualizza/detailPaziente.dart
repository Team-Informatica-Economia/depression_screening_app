import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:flutter/material.dart';



class DetailPazienti extends StatefulWidget{
  final Users user;

  const DetailPazienti({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailPazientiState(user);
  }
}

class DetailPazientiState extends State<DetailPazienti> {
  Users user;
  DetailPazientiState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
              color: KPrimaryColor,
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 30,right: 30,top: 75),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/pic.png")
                              )
                          ),
                        ),
                        SizedBox(width: 50),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(user.nome +" "+user.cognome, style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                            ]
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
          Padding(
            padding:  EdgeInsets.only(top: 175),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(left: 30.0, top: 30),
                      child: Text("Risultati Quiz", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
                    ),
                    SizedBox(height: 0),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Text("prova 1",),
                          Text("prova 1",),
                          Text("prova 1",),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}