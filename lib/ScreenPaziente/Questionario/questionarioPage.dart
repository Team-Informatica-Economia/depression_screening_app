import 'package:depression_screening_app/ScreenPaziente/Questionario/validazione.dart';
import 'package:depression_screening_app/Screens/Login/components/background.dart';
import 'package:depression_screening_app/components/customInputBox.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class getjsonQuestionario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString("assets/regioni-province.json"),
      builder: (context, snapshot) {
        var mydata = json.decode(snapshot.data.toString());
        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: Text("Caricamento..."),
            ),
          );
        } else {
          return QuestionarioPage(mydata: mydata);
        }
      },
    );
  }
}

class QuestionarioPage extends StatefulWidget {
  var mydata;

  QuestionarioPage({Key key, this.mydata}) : super(key: key);

  @override
  _QuestionarioPageState createState() => _QuestionarioPageState(mydata);
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  Validazione validazione = new Validazione();
  String dataReg;
  var myData;
  String selectedRegion;
  String selectedProvincia;
  List<String> regioni = new List<String>();
  List<String> province = new List<String>();
  Future userFuture;
  String nomeUtente;
  String cognomeUtente;
  List<String> statoCivile = ["Nubile", "Celibe", "Sposato/a", "Vedovo/a"];
  List<String> sesso = ["M", "F", "Preferisco non specificarlo"];
  List<String> gradoIstruzione = ["Primaria", "Secondaria", "Universitaria"];
  List<String> eta = ["18-20", "21-30", "31-40", "41-50", "51-60", "61-70", "70+"];
  bool firstCompilation;

  _QuestionarioPageState(this.myData);

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
    regioni = listaRegioni();
    var scrWidth = MediaQuery
        .of(context)
        .size
        .width;
    var scrHeight = MediaQuery
        .of(context)
        .size
        .height;
    Users utenteLoggato;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Background(
                child:
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: userFuture,
                        builder: (context, snapshot) {
                          utenteLoggato = snapshot.data;
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return displayInformation(context, snapshot);
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  List<String> listaRegioni() {
    List<String> list = new List();

    for (int i = 0; i < 20; i++) {
      list.add(myData["regioni"][i]["nome"]);
    }
    return list;
  }

  List<String> listaProvince(List<String> regioni, String regione) {
    int indice = regioni.indexOf(regione);
    List listaProv = myData["regioni"][indice]["capoluoghi"];
    List<String> lista = new List();

    for (int i = 0; i < (listaProv.length); i++) {
      lista.add(myData["regioni"][indice]["capoluoghi"][i]);
    }
    return lista;
  }


  Widget displayInformation(context, snapshot) {
    Users utenteLoggato = snapshot.data;
    if(utenteLoggato.statoCivile == null)
      firstCompilation = true;
    else
      firstCompilation = false;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            "Questionario dati personali",
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 30,
              color: KPrimaryColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Paziente: ${utenteLoggato.nome} ${utenteLoggato.cognome}",
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 20,
              color: Color(0xff8f9db5),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 75,
          width: 250,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                )),
            hint: new Text(
              'Seleziona lo stato civile',
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
            value: !firstCompilation ? "${utenteLoggato.statoCivile}" : null,
            onChanged: (value) {
              utenteLoggato.statoCivile = value;
            },
            items: statoCivile.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 75,
          width: 250,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                )),
            hint: new Text(
              'Seleziona il genere',
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
            value: !firstCompilation ? "${utenteLoggato.sesso}" : null,
            onChanged: (value) {
              utenteLoggato.sesso = value;
            },
            items: sesso.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 75,
          width: 250,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                )),
            hint: new Text(
              'Seleziona grado istruzione',
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
            value: !firstCompilation ? "${utenteLoggato.scuola}" : null,
            onChanged: (value) {
              utenteLoggato.scuola = value;
            },
            items: gradoIstruzione.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 75,
          width: 250,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                )),
            hint: new Text(
              !firstCompilation ? "${utenteLoggato.regione}" : "Seleziona regione",
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
            onChanged: (value) {
              setState(() {
                utenteLoggato.provincia = " ";
                utenteLoggato.regione = value;
                province =
                    listaProvince(regioni, utenteLoggato.regione);
                selectedProvincia = province[0];
              });
            },
            items: regioni.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 75,
          width: 250,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                )),
            hint: new Text(
              !firstCompilation ? "${utenteLoggato.provincia}" : "Seleziona provincia",
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
            items: province.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedProvincia = value;
                utenteLoggato.provincia = value;
              });
            },
            value: selectedProvincia,
          ),
        ),
        SizedBox(
          height: 75,
          width: 250,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                )),
            hint: new Text(
              'Seleziona fascia età',
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
            value: !firstCompilation ? "${utenteLoggato.eta}" : null,
            onChanged: (value) {
              utenteLoggato.eta = value;
            },
            items: eta.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
        RoundedButton(
          text: "Completa quiz",
          press: () {
            Users newUser = new Users.overloadedConstructor(
                utenteLoggato.nome,
                utenteLoggato.cognome,
                utenteLoggato.email,
                utenteLoggato.statoCivile.toString(),
                utenteLoggato.sesso.toString(),
                utenteLoggato.scuola.toString(),
                utenteLoggato.regione,
                utenteLoggato.provincia,
                utenteLoggato.eta.toString(),
                utenteLoggato.uidPadre);
            updateUser(newUser);

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
          },
        )
      ],
    );
  }
}