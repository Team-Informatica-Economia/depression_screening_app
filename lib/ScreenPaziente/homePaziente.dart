import 'package:depression_screening_app/ScreenPaziente/AudioRecorder.dart';
import 'package:depression_screening_app/ScreenPaziente/ProvaPDF.dart';
import 'package:depression_screening_app/ScreenPaziente/Questionario/questionarioPage.dart';
import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/components/bottomBar.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/AppuntamentoObj.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future userFuture;
  Future appuntamentoFuture;
  AppuntamentoObj appuntamento;

  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
    appuntamentoFuture = _getAppuntamento();
  }

  _getUser() async {
    return await readUser();
  }

  _getAppuntamento() async {
    return await readAppuntamento();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KPrimaryColor,
      extendBody: true,
      body: Container(
        child: FutureBuilder(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return displayInformation(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: bottomBarPaziente(),
    );
  }

  Widget displayInformation(BuildContext context, snapshot) {
    Users utenteLoggato = snapshot.data;
    return Column(
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
                  ))
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
          height: MediaQuery.of(context).size.height - 165,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
          ),
          child: ListView(
            padding: EdgeInsets.only(left: 25.0, right: 20.0),
            children: <Widget>[
              SizedBox(height: 55.0),
              InkWell(
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.4,
                          top: 40,
                          right: 30,
                        ),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              KColorButtonLight,
                              KColorButtonDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Completa il quiz",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(color: Colors.white)),
                          ]),
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
                      builder: (context) {
                        return getjsonQuestionario();
                      },
                    ),
                  );
                },
              ),
              FutureBuilder(
                future: appuntamentoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    appuntamento = snapshot.data;
                    if (appuntamento.giorno != "") {
                      String str =
                          "${appuntamento.giornoSettimana}, alle ore: ${appuntamento.orario}";
                      return timeSlotWidget(appuntamento.giorno,
                          appuntamento.mese, "Prossima visita", str);
                    } else {
                      return Container(width: 0.0, height: 0.0);
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              RoundedButton(
                text: "Python",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Python();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container timeSlotWidget(
      String date, String month, String slotType, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: KPrimaryLightColor),
      child: Container(
        padding: EdgeInsets.all(11),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: KPrimaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$date",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "$month",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$slotType",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "$time",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
