import 'dart:io';

import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:depression_screening_app/services/Questionario.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../constants.dart';

class resultpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return resultpageState();
  }
}

class resultpageState extends State<resultpage> {
  final pdf = pw.Document();

  String nome;
  String cognome;
  String email;
  String statoCivile;
  String sesso;
  String scuola;
  String regione;
  String provincia;
  String eta;

  List<String> domande = new List(3);
  List<String> risposte = new List(3);

  List<String> voceAngry = new List(3);
  List<String> voceNeutral = new List(3);
  List<String> voceFear = new List(3);
  List<String> voceSurprise = new List(3);
  List<String> voceSad = new List(3);
  List<String> voceDisgust = new List(3);
  List<String> voceHappy = new List(3);

  List<String> faceAngry = new List(3);
  List<String> faceNeutral = new List(3);
  List<String> faceFear = new List(3);
  List<String> faceSurprise = new List(3);
  List<String> faceSad = new List(3);
  List<String> faceDisgust = new List(3);
  List<String> faceHappy = new List(3);

  List<List<String>> strList = new List(8);

  int punteggio;
  String inizioTest;
  String gradoDepressione;

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  readSharedPreferences() async {
    SharedPreferences sharedPrefs = await getSharedPreferencesInstance();
    setState(() {
      nome = sharedPrefs.getString("nome");
      cognome = sharedPrefs.getString("cognome");
      email = sharedPrefs.getString("email");
      statoCivile = sharedPrefs.getString("statoCivile");
      sesso = sharedPrefs.getString("sesso");
      scuola = sharedPrefs.getString("scuola");
      regione = sharedPrefs.getString("regione");
      provincia = sharedPrefs.getString("provincia");
      eta = sharedPrefs.getString("eta");

      for (int i = 1; i <= 3; i++) {
        domande[i - 1] = sharedPrefs.getString("domanda" + i.toString());
        risposte[i - 1] = sharedPrefs.getString("risposta" + i.toString());

        voceAngry[i - 1] = sharedPrefs.getString("voceangry" + i.toString());
        voceNeutral[i - 1] = sharedPrefs.getString("voceneutral" + i.toString());
        voceFear[i - 1] = sharedPrefs.getString("vocefear" + i.toString());
        voceSurprise[i - 1] = sharedPrefs.getString("vocesurprise" + i.toString());
        voceSad[i - 1] = sharedPrefs.getString("vocesad" + i.toString());
        voceDisgust[i - 1] = sharedPrefs.getString("vocedisgust" + i.toString());
        voceHappy[i - 1] = sharedPrefs.getString("vocehappy" + i.toString());

        faceAngry[i - 1] = sharedPrefs.getString("faceangry" + i.toString());
        faceNeutral[i - 1] = sharedPrefs.getString("faceneutral" + i.toString());
        faceFear[i - 1] = sharedPrefs.getString("facefear" + i.toString());
        faceSurprise[i - 1] = sharedPrefs.getString("facesurprise" + i.toString());
        faceSad[i - 1] = sharedPrefs.getString("facesad" + i.toString());
        faceDisgust[i - 1] = sharedPrefs.getString("facedisgust" + i.toString());
        faceHappy[i - 1] = sharedPrefs.getString("facehappy" + i.toString());
      }
      punteggio = sharedPrefs.getInt("punteggio");
      inizioTest = sharedPrefs.getString("inizio");

      /*
      Punteggi 0-13 indicano un’assenza di contenuti depressivi;
      punteggi compresi tra 14-19:  una depressione lieve punteggi
      27-29 una depressione di grado moderato; punteggi
      30- 63: una depressione di grado severo.
       */

      gradoDepressione = getGrado(punteggio);


    });
  }

  String getGrado(int punteggio){
    if(punteggio>=0 && punteggio<=13)
      return "Assenza di contenuti depressivi";
    else if(punteggio>=14 && punteggio<=19)
      return "Depressione lieve";
    else if(punteggio>=27 && punteggio<=29)
      return "Depressione di grado moderato";
    else "Depressione di grado severo"; //tra 30 e 63
  }

  List<List<String>> getTabella (int numDomanda) {
    strList[0] = ['Emozione', 'Tono vocale', 'Espressione facciale'];
    strList[1] = ['Arrabbiato', voceAngry[numDomanda], faceAngry[numDomanda]];
    strList[2] = ['Neutrale', voceNeutral[numDomanda], faceNeutral[numDomanda]];
    strList[3] = ['Impaurito', voceFear[numDomanda], faceFear[numDomanda]];
    strList[4] = ['Sorpreso', voceSurprise[numDomanda], faceSurprise[numDomanda]];
    strList[5] = ['Triste', voceSad[numDomanda], faceSad[numDomanda]];
    strList[6] = ['Disgustato', voceDisgust[numDomanda], faceDisgust[numDomanda]];
    strList[7] = ['Felice', voceHappy[numDomanda], faceHappy[numDomanda]];

    return strList;
  }


  writePDF() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(50),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Risultati questionario")),
          pw.Paragraph(
              text: "Di seguito sono riportati i risultati del questionario: " +
                  generaNome() + "\n"
                  + "Svolto da: " + cognome + " " + nome + "\n"
                  + "Email: " + email + "\n"
                  + "Stato civile: " + statoCivile + "\n"
                  + "Sesso: " + sesso + "\n"
                  + "Formazione scolastica: " + scuola + "\n"
                  + "Regione: " + regione + "\n"
                  + "Provincia: " + provincia + "\n"
                  + "Fascia d'età: " + eta + "\n"
          ),
          pw.Header(level: 1, child: pw.Text("1)" + domande[0].toString())),
          pw.Paragraph(text: risposte[0].toString()),
          pw.Table.fromTextArray(context: context, data: getTabella(0)),

          pw.Header(level: 1, child: pw.Text("2)" + domande[1].toString())),
          pw.Paragraph(text: risposte[1].toString()),
          pw.Table.fromTextArray(context: context, data: getTabella(1)),

          pw.Header(level: 1, child: pw.Text("3)" + domande[2].toString())),
          pw.Paragraph(text: risposte[2].toString()),
          pw.Table.fromTextArray(context: context, data: getTabella(2)),

          pw.Header(level: 2, child: pw.Text("Risultato ottenuto: " + gradoDepressione)),

          pw.Header(level: 2, child: pw.Text("Ora inizio test: " + convertData(inizioTest))),

          pw.Header(level: 2, child: pw.Text("Ora fine test: " + convertData(DateTime.now().toString()))),

          pw.Header(level: 2, child: pw.Text("Tempo impiegato: " + differenzaTime(inizioTest, DateTime.now().toString()))),

        ];
      },
    ));
  }

  String convertData(String str) {
    DateTime parsedDate = DateTime.parse(str);

    String retStr = "";
    retStr = parsedDate.day.toString() + " " + monthsInYear[parsedDate.month] + ", " + parsedDate.year.toString();
    retStr = retStr + " " +  parsedDate.hour.toString() + ":" + parsedDate.minute.toString() + ":" + parsedDate.second.toString();

    return retStr;
  }

  String differenzaTime(String a, String b) {
    DateTime data1 = DateTime.parse(a);
    DateTime data2 = DateTime.parse(b);

    int x = data2.difference(data1).inSeconds;

    String retStr = "";
    double minuti = x/60;
    int minutiInt = minuti.toInt();
    retStr = "Minuti: " + minutiInt.toString() + ", Secondi: " + (x%60).toString();

    return retStr;
  }

  String generaNome() {
    DateTime dateTime = DateTime.now();
    return dateTime.toString() + ".pdf";
  }

  Future saveLocalPDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    String nomeFile = generaNome();
    File file = File("$documentPath/$nomeFile");
    file.writeAsBytes(pdf.save());
    savePdf(file, nomeFile);
  }

  savePdf(File asset, String name) async {
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putFile(asset);
    String url = await (await uploadTask).ref.getDownloadURL();
    print("url " + url);
    name = name.substring(0, 19);
    Questionario quest = new Questionario(name, url, punteggio.toString());
    await addPdfPaziente(quest);
    //documentFileUpload(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/quizTerminato.png",
            ),
            Text("Quiz terminato"),
            RoundedButton(
              text: "Vai alla Home",
              press: () async {
                await readSharedPreferences();
                writePDF();
                await saveLocalPDF();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
