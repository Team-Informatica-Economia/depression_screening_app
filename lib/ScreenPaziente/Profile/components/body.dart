
import 'package:depression_screening_app/ScreenPaziente/Profile/components/info.dart';
import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/components/rounded_input_field.dart';
import 'package:depression_screening_app/components/rounded_password_field.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:flutter/material.dart';
import 'package:depression_screening_app/services/database.dart';


class Body extends StatefulWidget {

  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future userFuture;
  Users utenteLoggato;

  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
  }

  _getUser() async {
    return await readUser();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(

        children: <Widget>[
          FutureBuilder(
            future: userFuture,
            builder: (context, snapshot) {
              utenteLoggato = snapshot.data;
              if (snapshot.connectionState ==
                  ConnectionState.done) {
                utenteLoggato=snapshot.data;
                return displayInformation(context, snapshot);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),

        ],
      ),
    );
  }
}

Widget displayInformation(context, snapshot) {
  Users utenteLoggato = snapshot.data;

  return SingleChildScrollView(
    child: Column(

      children: <Widget>[

        Info(
          image: "assets/images/pic.png",
          name: "${utenteLoggato.nome}"+" ${utenteLoggato.cognome}",
          email: "${utenteLoggato.email}",
          eta: "${utenteLoggato.eta}"=="null" ? "Da inserire" : "${utenteLoggato.eta}"+" anni",
          regione:  "${utenteLoggato.regione}"=="null" ? "Da inserire" : "${utenteLoggato.regione}",
          provincia:  "${utenteLoggato.provincia}"=="null" ? "Da inserire" : "${utenteLoggato.provincia}",
          scuola:  "${utenteLoggato.scuola}"=="null" ? "Da inserire" : "${utenteLoggato.scuola}",
          sesso:  "${utenteLoggato.eta}"=="null" ? "Da inserire" : "${utenteLoggato.sesso}",
          statoCivile:  "${utenteLoggato.statoCivile}"=="null" ? "Da inserire" : "${utenteLoggato.statoCivile}",
        ),


      ],
    ),
  );
}
