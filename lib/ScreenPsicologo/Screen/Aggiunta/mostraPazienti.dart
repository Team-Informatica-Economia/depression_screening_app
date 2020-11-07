import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';

class MostraPazienti extends StatefulWidget{

@override
State<StatefulWidget> createState() {
  return MostraPazientiState();
}
}

class MostraPazientiState extends State<MostraPazienti> {
  Future userFuture;


  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
  }
  _getUser() async {
    return await readListPazienti();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("ciao"),
    );
  }


}