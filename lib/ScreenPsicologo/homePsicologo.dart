import 'package:depression_screening_app/ScreenPsicologo/Screen/Aggiunta/aggiunta.dart';
import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:provider/provider.dart';

class HomePagePsicologo extends StatefulWidget {
  @override
  _HomePagePsicologoState createState() => _HomePagePsicologoState();
}

class _HomePagePsicologoState extends State<HomePagePsicologo> {
  Future userFuture;


  @override
  void initState() {
    super.initState();
    //userFuture = _getUser();
  }
 /* _getUser() async {
    return await readUser();
  }*/
  @override
  Widget build(BuildContext context){
    final firebaseUser = context.watch<User>();
    if(firebaseUser == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: Container(
        child: FutureBuilder(
          //future: userFuture,
          builder: (context,snapshot){
            //if(snapshot.connectionState == ConnectionState.done){
              return displayInformation(context, snapshot);
            //}else{
             // return CircularProgressIndicator();
            //}
          },
        ),
      ),
    );
  }
}

Widget displayInformation(BuildContext context,snapshot){

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.logout),
        color: Colors.black,
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
      ),
      Text("Sono la home dello psicologo"),
      RoundedButton(
        text: "Aggiungi paziente",
        press: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AggiungiPazientePage(),));
        },
      ),
      RoundedButton(
        text: "Visualizza lista pazienti",
        press: (){
        },
      ),
    ],
  );
}
