import 'package:depression_screening_app/ScreenPaziente/Questionario/infoPrivacy.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> statoCivile = ["Nubile", "Celibe", "Sposato/a", "Vedovo/a", "Divorziato/a"];
  List<String> sesso = ["M", "F", "Preferisco non specificarlo"];
  List<String> gradoIstruzione = ["Elementari", "Medie", "Diploma", "Laurea"];
  List<String> eta = [
    "18-20 anni",
    "21-30 anni",
    "31-40 anni",
    "41-50 anni",
    "51-60 anni",
    "61-70 anni",
    "70+ anni"
  ];
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

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  static void saveKV(Users user) async {
    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();

    sharedPreferences.setString("nome", user.nome);
    sharedPreferences.setString("cognome", user.cognome);
    sharedPreferences.setString("email", user.email);
    sharedPreferences.setString("statoCivile", user.statoCivile);
    sharedPreferences.setString("sesso", user.sesso);
    sharedPreferences.setString("scuola", user.scuola);
    sharedPreferences.setString("regione", user.regione);
    sharedPreferences.setString("provincia", user.provincia);
    sharedPreferences.setString("eta", user.eta);
  }

  @override
  Widget build(BuildContext context) {
    regioni = listaRegioni();
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;
    Users utenteLoggato;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: userFuture,
                    builder: (context, snapshot) {
                      utenteLoggato = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done) {
                        return displayInformation(context, snapshot);
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            )
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
    if ((utenteLoggato.statoCivile == null) ||
        (utenteLoggato.sesso == null) ||
        (utenteLoggato.scuola == null) ||
        (utenteLoggato.regione == null) ||
        (utenteLoggato.provincia == null) ||
        (utenteLoggato.eta == null))
      firstCompilation = true;
    else
      firstCompilation = false;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            "Dati personali",
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
              !firstCompilation
                  ? "${utenteLoggato.regione}"
                  : "Seleziona regione",
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
                province = listaProvince(regioni, utenteLoggato.regione);
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
              !firstCompilation
                  ? "${utenteLoggato.provincia}"
                  : "Seleziona provincia",
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
          text: "Avanti",
          press: () async {
            if ((utenteLoggato.statoCivile != null) &&
                (utenteLoggato.sesso != null) &&
                (utenteLoggato.scuola != null) &&
                (utenteLoggato.regione != null) &&
                (utenteLoggato.provincia != null) &&
                (utenteLoggato.eta != null)) {
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

              await saveKV(newUser);

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InfoPrivacy(),
              ));
            } else {
              print("Non sono stati compilati tutti i campi");
            }
          },
        )
      ],
    );
  }
}
