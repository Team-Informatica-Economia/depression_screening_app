import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:depression_screening_app/Screens/Login/components/background.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/components/rounded_input_field.dart';
import 'package:depression_screening_app/components/rounded_password_field.dart';
import 'package:depression_screening_app/home.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:depression_screening_app/Screens/Quiz/quiz.dart';
import 'package:intl/intl.dart';

class BodyDatiPersonali extends StatefulWidget {
  BodyDatiPersonali({Key key, this.title}):super(key: key);
  final String title;
  final DateFormat _df= DateFormat("dd/MM/yyyy");


  @override
  _BodyDatiPersonali createState() => _BodyDatiPersonali();
}
class _BodyDatiPersonali extends State<BodyDatiPersonali>{
  final _formKey=GlobalKey<FormState>();
  final _pswKey= GlobalKey<FormFieldState>();
  DateTime _selectedDate=DateTime.now();
  final RegistraUtente utente = RegistraUtente();


  @override
  Widget build(BuildContext context) {
    return Background(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: "Nome"),
                        onSaved: (value) => utente.nome=value,
                        validator: (value){
                          if(value.isEmpty)
                            return "Campo obbligatorio";
                          else if(value.length<3) return "Nome non valido";
                          return null;
                        },
                      ),

                      TextFormField(
                        decoration: InputDecoration(labelText: "Cognome"),
                        onSaved: (value) => utente.nome=value,
                        validator: (value){
                          if(value.isEmpty)
                            return "Campo obbligatorio";
                          else if(value.length<3) return "Cognome non valido";
                          return null;
                        },

                      ),

                      Row(
                          children: <Widget>[
                            Text("Stato civile"),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: DropdownButtonFormField<StatoCivile>(
                                  value: utente.statoCivile,
                                  onChanged: (value){
                                    utente.statoCivile=value;
                                  },

                                  onSaved: (value)=>utente.statoCivile=value,

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Celibe"),
                                      value: StatoCivile.celibe,
                                    ),

                                    DropdownMenuItem(
                                      child: Text("Nubile"),
                                      value: StatoCivile.nubile,
                                    ),



                                  ]
                              ),


                            ),


                          ]
                      ),

                      Row(
                          children: <Widget>[
                            Text("Sesso"),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: DropdownButtonFormField<Sesso>(
                                  value: utente.sesso,
                                  onChanged: (value){
                                    utente.sesso=value;
                                  },

                                  onSaved: (value)=>utente.sesso=value,

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("M"),
                                      value: Sesso.M,
                                    ),

                                    DropdownMenuItem(
                                      child: Text("F"),
                                      value: Sesso.F,
                                    ),



                                  ]
                              ),


                            ),


                          ]
                      ),

                      Row(
                          children: <Widget>[
                            Text("Istruzione"),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: DropdownButtonFormField<Scuola>(
                                  value: utente.scuola,
                                  onChanged: (value){
                                    utente.scuola=value;
                                  },

                                  onSaved: (value)=>utente.scuola=value,

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Primaria"),
                                      value: Scuola.Primaria,
                                    ),

                                    DropdownMenuItem(
                                      child: Text("Medie"),
                                      value: Scuola.Medie,
                                    ),



                                  ]
                              ),


                            ),


                          ]
                      ),

                      Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Text("Data di nascita"),
                            ),
                            Spacer(),
                            Text(utente.nascita == null
                                ? "--/--/----"
                                : widget._df.format(utente.nascita)),

                            IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: () => getData(context),
                            )


                          ]
                      ),







                      RoundedButton(
                          text: "Inizia il quiz",
                          press: (){
                            if(_formKey.currentState.validate()){
                          print("Nesun errore");
                          _formKey.currentState.save();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context){
                                    return getjson();
                                  }
                              )
                          );
                        }


                          }
                      )


                    ]
                )
            )
        )

    );
  }

  getData(BuildContext context) async{
    var fDate=await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );

    if(fDate!=null) setState(() {
      utente.nascita=fDate;
    });

  }
}




enum StatoCivile{
  celibe, nubile
}

enum Sesso{
  M, F
}

enum Scuola{
  Primaria, Medie
}

class Utente{
  String nome;
  String cognome;
  StatoCivile statoCivile =StatoCivile.celibe;
  Sesso sesso=Sesso.M;
  Scuola scuola= Scuola.Primaria;
  DateTime nascita;

}

class RegistraUtente extends Utente{
  String regPassword;
}