import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProvaLettura extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return ProvaLetturaState();
  }
}
class ProvaLetturaState extends State<ProvaLettura>{
  Future userFuture;


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
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: userFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){

              return displayInformation(context, snapshot);
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );

  }
}
Widget displayInformation(context,snapshot){
  Users utenteLoggato = snapshot.data;
  return Column(

    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Nome:  ${utenteLoggato.nome}",
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Cognome:  ${utenteLoggato.cognome}",
          style: TextStyle(
              fontSize: 20
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Email:  ${utenteLoggato.email}",
          style: TextStyle(
              fontSize: 20
          ),
        ),
      ),
    ],
  );

}