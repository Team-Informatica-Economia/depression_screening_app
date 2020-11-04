import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:depression_screening_app/services/database.dart';
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

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("Acconsenti e inizia il quiz"),
      onPressed: () {


          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context){
                    return getjson();
                  }
              )
          );


      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Autorizzazione al trattamento dei dati personali"),
      content: Text("Dire che per fare sto test useremo i suoi dati personali, anagafici, voce e viso, esclusivamento per scopi "
          "sanitari(??) e per permettere ciò deve acconsentie."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    return Background(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: "Nome"),
                        initialValue: "c",
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

                                    DropdownMenuItem(
                                      child: Text("Preferisco\nnon specificarlo"),
                                      value: Sesso.PreferiscoNonRispondere,
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
                            Text("Regione"),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: DropdownButtonFormField<Regione>(
                                  value: utente.regione,
                                  onChanged: (value){
                                    utente.regione=value;
                                  },

                                  onSaved: (value)=>utente.regione=value,

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Regione1"),
                                      value: Regione.regione1,
                                    ),

                                    DropdownMenuItem(
                                      child: Text("Regione2"),
                                      value: Regione.regione2,
                                    ),



                                  ]
                              ),


                            ),


                          ]
                      ),

                      Row(
                          children: <Widget>[
                            Text("Provincia"),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: DropdownButtonFormField<Provincia>(
                                  value: utente.provincia,
                                  onChanged: (value){
                                    utente.provincia=value;
                                  },

                                  onSaved: (value)=>utente.provincia=value,

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Provincia1"),
                                      value: Provincia.provincia1,
                                    ),

                                    DropdownMenuItem(
                                      child: Text("Provincia2"),
                                      value: Provincia.provincia2,
                                    ),



                                  ]
                              ),


                            ),


                          ]
                      ),


                      Row(
                          children: <Widget>[
                            Text("Fascia di età"),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: DropdownButtonFormField<FasciaEta>(
                                  value: utente.eta,
                                  onChanged: (value){
                                    utente.eta=value;
                                  },

                                  onSaved: (value)=>utente.eta=value,

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("(18-20)"),
                                      value: FasciaEta.diciottoVenti,
                                    ),

                                    DropdownMenuItem(
                                      child: Text("(21-30)"),
                                      value: FasciaEta.ventunoTrenta,
                                    ),



                                  ]
                              ),


                            ),


                          ]
                      ),








                      RoundedButton(
                          text: "Inizia il quiz",
                          press: (){
                            showAlertDialog(context);
                         /*   if(_formKey.currentState.validate()){
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
                        } */


                          }
                      )


                    ]
                )
            )
        )

    );
  }


}




enum StatoCivile{
  celibe, nubile
}

enum Sesso{
  M, F, PreferiscoNonRispondere
}

enum Scuola{
  Primaria, Medie
}

enum Regione{
  regione1, regione2
}

enum Provincia{
  provincia1, provincia2
}

enum FasciaEta{
  diciottoVenti, ventunoTrenta, trentunoQuaranta, quarantunoCinquanta, cinquantuno60, settantaEOltre
}

class Utente{
  String nome;
  String cognome;
  StatoCivile statoCivile =StatoCivile.celibe;
  Sesso sesso=Sesso.M;
  Scuola scuola= Scuola.Primaria;
  Regione regione=Regione.regione1;
  Provincia provincia=Provincia.provincia1;
  FasciaEta eta=FasciaEta.diciottoVenti;

}

class RegistraUtente extends Utente{
  String regPassword;
}