import 'package:depression_screening_app/ScreenPaziente/Questionario/validazione.dart';
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
import 'package:rflutter_alert/rflutter_alert.dart';

class AggiungiPazientePage extends StatefulWidget{
  AggiungiPazientePage({Key key}): super(key: key);

  @override
  _AggiungiPazientePageState createState() => _AggiungiPazientePageState();

}

class _AggiungiPazientePageState extends State<AggiungiPazientePage> {
  Validazione validazione = new Validazione();

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

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 55,
                ),
                Text('Aggiungi paziente',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)
                ),
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
                  inputHint: 'email@address.com',
                  controller: emailController,
                ),
                SizedBox(
                  height: 30,
                ),

                MyCustomInputBox(
                  label: 'Password',
                  inputHint: 'Password',
                  controller: passwordController,
                ),
                RoundedButton(
                  text: "Aggiungi",
                  press: (){
                    Users u = new Users(nomeController.text.trim(), cognomeController.text.trim(), emailController.text.trim(), uid);
                    context.read<AuthenticationService>().sigUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      user: u,
                    );


                    if(validazione.isValid(nomeController.text.trim()) && validazione.isValid(cognomeController.text.trim()) && validazione.isValidEmail(emailController.text.trim()) && validazione.isValidPassword(passwordController.text.trim())){
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Aggiunto",
                        desc: "Paziente aggiunto con successo.",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Chiudi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    } else {

                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Non aggiunto",
                        desc: "Attenzione! Paziente non aggiunto, controllare i campi.",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Chiudi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    }


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