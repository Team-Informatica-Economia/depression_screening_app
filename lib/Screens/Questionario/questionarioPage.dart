
import 'package:depression_screening_app/Screens/Questionario/validazione.dart';
import 'package:depression_screening_app/components/customInputBox.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/home.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class QuestionarioPage extends StatefulWidget{
  QuestionarioPage({Key key}): super(key: key);

  @override
  _QuestionarioPageState createState() => _QuestionarioPageState();
}



class _QuestionarioPageState extends State<QuestionarioPage> {
  Validazione validazione=new Validazione();
  Utente utente=new Utente();
  String dataReg;
  var jsonResult;
  final String data =
      '[{"ID": 1, "Code": "01", "Description": "REGION I (ILOCOS REGION)", "PSGCCode": "010000000"}, {"ID": 2, "Code": "02", "Description": "REGION II (CAGAYAN VALLEY)", "PSGCCode": "020000000"}]';
  List<Region> _region = [];
  String selectedRegion;

  @override
  void initState() {
    super.initState();
    _getUser();
  }
  _getUser() async {
    dataReg = await DefaultAssetBundle.of(context).loadString("assets/regioni-province.json");
    jsonResult = json.decode(dataReg);
  }

  @override
  Widget build(BuildContext context) {
    final json = JsonDecoder().convert(data);
    _region = (json).map<Region>((item) => Region.fromJson(item)).toList();
    int id;
    id = _region[0].id;

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
                    label: 'Nome (Almeno 3 caratteri)',
                    inputHint: 'Mario',
                    controller: nome,
                  ),
                  //
                  SizedBox(
                    height: 15,
                  ),
                  //
                  MyCustomInputBox(
                    label: 'Cognome (Almeno 3 caratteri)',
                    inputHint: 'Rossi',
                    controller: cognome,
                  ),
                  //

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
                          utente.regione=value;
                        },

                     /* items: _mappa.map((Mappa map) {
                        return new DropdownMenuItem<String>(
                          value: map.regione,
                          child: new Text(map.regione,
                              style: new TextStyle(color: Colors.black)),
                        );
                      }).toList(),*/
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

                      onChanged: (value){
                        utente.provincia=value;
                      },
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
                      print(jsonResult["regioni"][0]["nome"]);
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

class Region {
  //final String regione;
  //final String provincia;

  int id; //prova

  Region({this.id});
  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(id: json["ID"]);
  }
}

