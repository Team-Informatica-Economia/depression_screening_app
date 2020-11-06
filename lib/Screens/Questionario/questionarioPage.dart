
import 'package:depression_screening_app/components/customInputBox.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/home.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionarioPage extends StatefulWidget{
  QuestionarioPage({Key key}): super(key: key);

  @override
  _QuestionarioPageState createState() => _QuestionarioPageState();

}

class _QuestionarioPageState extends State<QuestionarioPage> {
  @override
  Widget build(BuildContext context) {

    TextEditingController nome = TextEditingController();
    TextEditingController cognome = TextEditingController();
    TextEditingController email = TextEditingController();
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
                    controller: nome,
                  ),
                  //
                  SizedBox(
                    height: 15,
                  ),
                  //
                  MyCustomInputBox(
                    label: 'Cognome',
                    inputHint: 'Rossi',
                    controller: cognome,
                  ),
                  //
                  SizedBox(
                    height: 30,
                  ),

                  MyCustomInputBox(
                    label: 'Email',
                    inputHint: 'mario@gmail.com',
                    controller: email,
                  ),
                  RoundedButton(
                    text: "Completa quiz",
                    press: (){
                      Users u = new Users(nome.text.trim(), cognome.text.trim(), email.text.trim());

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));

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