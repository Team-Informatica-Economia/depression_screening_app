
import 'package:depression_screening_app/ScreenPaziente/Questionario/validazione.dart';
import 'package:depression_screening_app/components/customInputBox.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
class getjsonQuestionario extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString("assets/regioni-province.json"),
      builder: (context,snapshot){
        var mydata = json.decode(snapshot.data.toString());
        if(mydata == null){
          return Scaffold(
            body: Center(
              child: Text(
                  "Caricamento..."
              ),
            ),
          );
        }else{
          return QuestionarioPage( mydata : mydata);
        }
      },
    );
  }
}
class QuestionarioPage extends StatefulWidget{
  var mydata;
  QuestionarioPage({Key key,this.mydata}): super(key: key);

  @override
  _QuestionarioPageState createState() => _QuestionarioPageState(mydata);
}


class _QuestionarioPageState extends State<QuestionarioPage> {
  Validazione validazione=new Validazione();
  Utente utente=new Utente();
  String dataReg;
  var myData;
  String selectedRegion;
  String selectedProvincia;
  List<String> regioni=new List<String>();
  List<String> province=new List<String>();

  _QuestionarioPageState(this.myData);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    regioni=listaRegioni();
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
                  SizedBox(
                    height: 100,
                    width: 250,

                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            )
                        ),
                        hint: new Text('Seleziona lo stato civile', style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                          color: Color(0xff8f9db5),
                        ),),

                        onChanged: (value){
                          utente.statoCivile=value;
                        },

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

                  SizedBox(
                    height: 100,
                    width: 250,

                   child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          )
                      ),
                      hint: new Text('Seleziona il genere', style: TextStyle(
                        fontFamily: 'Product Sans',
                        fontSize: 15,
                        color: Color(0xff8f9db5),
                      ),),

                     onChanged: (value){
                       utente.sesso=value;
                     },

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

                  SizedBox(
                    height: 100,
                    width: 250,

                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            )
                        ),
                        hint: new Text('Seleziona grado istruzione', style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                          color: Color(0xff8f9db5),
                        ),),

                        onChanged: (value){
                          utente.scuola=value;
                        },

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

                  SizedBox(
                    height: 100,
                    width: 250,

                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            )
                        ),
                        hint: new Text('Seleziona regione', style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                          color: Color(0xff8f9db5),
                        ),),

                        onChanged: (value){
                          setState(() {
                            utente.provincia = " ";
                            utente.regione = value;
                            province = listaProvince(regioni, utente.regione);
                            selectedProvincia = province[0];
                          });
                          },


                        items: regioni.map((String value) {
                        return  DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),


                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 250,

                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          )
                      ),
                      hint: new Text('Seleziona provincia', style: TextStyle(
                        fontFamily: 'Product Sans',
                        fontSize: 15,
                        color: Color(0xff8f9db5),
                      ),),

                      items: province.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),

                      onChanged: (value){
                        setState(() {
                          selectedProvincia = value;
                          utente.provincia = value;
                        });
                      },
                      value: selectedProvincia,
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 250,

                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            )
                        ),
                        hint: new Text('Seleziona fascia età', style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                          color: Color(0xff8f9db5),
                        ),),

                        onChanged: (value){
                          utente.eta=value;
                        },

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


                  RoundedButton(
                    text: "Completa quiz",

                    press: (){
                      if(validazione.isValid(nome.text) && validazione.isValid(cognome.text))
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

     List<String> listaRegioni() {
     List<String> list= new List();

     for (int i=0; i<20 ; i++){
        list.add(myData["regioni"][i]["nome"]);
      }
      return list;
    }

    List<String> listaProvince(List<String> regioni, String regione){

    int indice=regioni.indexOf(regione);
    List listaProv=myData["regioni"][indice]["capoluoghi"];
    List<String> lista=new List();

    for (int i=0; i<(listaProv.length) ; i++){
      lista.add(myData["regioni"][indice]["capoluoghi"][i]);
    }
    return lista;
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



enum FasciaEta{
  diciottoVenti, ventunoTrenta, trentunoQuaranta, quarantunoCinquanta, cinquantuno60, settantaEOltre
}

class Utente{
  String nome;
  String cognome;
  StatoCivile statoCivile =StatoCivile.celibe;
  Sesso sesso=Sesso.M;
  Scuola scuola= Scuola.Primaria;
  String regione="Abruzzo";
  String provincia="Cheti";
  FasciaEta eta=FasciaEta.diciottoVenti;

}



