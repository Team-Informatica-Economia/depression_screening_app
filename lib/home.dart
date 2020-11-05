import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/Screens/Profile/compilazioneDatiPersonali.dart';
import 'package:depression_screening_app/Screens/Questionario/questionarioPage.dart';
import 'package:depression_screening_app/components/bottomBar.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/provaLettura.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'services/Users.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context){
    final firebaseUser = context.watch<User>();
    if(firebaseUser == null){
      return LoginScreen();
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KPrimaryColor,
      extendBody: true,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: Colors.white,
                          onPressed: () {
                            context.read<AuthenticationService>().signOut();
                          },
                        ),
                      ],
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Depression',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('Screening',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 30.0),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height-165,


            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                /*Padding(
                   padding: EdgeInsets.only(top: 45.0),
               ),*/


                SizedBox(height: 55.0),
                RoundedButton(
                  text: "Completa questionario",
                  press: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context){
                          return QuestionarioPage();
                        },
                      ),
                    );
                  },
                ),
                InkWell(
                  child: Container(
                    //height: 135,

                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width*0.4,
                            top: 40,
                            right: 30,

                          ),
                          height: 120,

                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffb79adc),
                                Color(0xFF673AB7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Completa il quiz",
                                      style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)
                                  ),
                                ]
                            ),
                          ),


                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SvgPicture.asset("assets/icons/nurse.svg"),
                        ),

                      ],
                    ),

                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context){
                          return DatiPersonali();
                          //return getjson();
                        },
                      ),
                    );
                  },
                ),
                RoundedButton (
                  text: "Leggi",
                  press: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context){
                          return ProvaLettura();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
}


