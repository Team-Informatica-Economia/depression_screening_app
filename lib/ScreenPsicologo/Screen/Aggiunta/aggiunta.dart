import 'package:depression_screening_app/ScreenPsicologo/homePsicologo.dart';
import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/components/customInputBox.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AggiungiPazientePage extends StatefulWidget{
  AggiungiPazientePage({Key key}): super(key: key);

  @override
  _AggiungiPazientePageState createState() => _AggiungiPazientePageState();

}

class _AggiungiPazientePageState extends State<AggiungiPazientePage> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser == null){
      return LoginScreen();
    }

    TextEditingController nomeController = TextEditingController();
    TextEditingController cognomeController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                //
                MyCustomInputBox(
                  label: 'Nome',
                  inputHint: 'Mario',
                  controller: nomeController,
                ),
                //
                SizedBox(
                  height: 15,
                ),
                //
                MyCustomInputBox(
                  label: 'Cognome',
                  inputHint: 'Rossi',
                  controller: cognomeController,
                ),
                //
                SizedBox(
                  height: 30,
                ),

                MyCustomInputBox(
                  label: 'Email',
                  inputHint: 'mario@gmail.com',
                  controller: emailController,
                ),
                SizedBox(
                  height: 30,
                ),

                MyCustomInputBox(
                  label: 'Password',
                  inputHint: 'password',
                  controller: passwordController,
                ),
                RoundedButton(
                  text: "Aggiungi paziente",
                  press: (){
                    Users u = new Users(nomeController.text.trim(), cognomeController.text.trim(), emailController.text.trim());
                    context.read<AuthenticationService>().sigUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      u: u,
                    );
                    /*
                    writeNewUser(u);*/
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePagePsicologo(),));

                  },
                )

              ],
            ),
          ],
        ),
      ),
    );
  }

}