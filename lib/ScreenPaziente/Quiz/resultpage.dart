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

  int punteggio;

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
    });
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
          pw.Paragraph(
              text: "Analisi tono vocale su risposta aperta:\n"
                  + "Angry: " +
                  voceAngry[0] +
                  "\n" +
                  "Neutral: " +
                  voceNeutral[0] +
                  "\n" +
                  "Fear: " +
                  voceFear[0] +
                  "\n" +
                  "Surprise: " +
                  voceSurprise[0] +
                  "\n" +
                  "Sad: " +
                  voceSad[0] +
                  "\n" +
                  "Disgust: " +
                  voceDisgust[0] +
                  "\n" +
                  "Happy: " +
                  voceHappy[0] +
                  "\n"),
          pw.Paragraph(
              text: "Analisi espressione facciale su risposta aperta:\n"
                  + "Angry: " +
                  faceAngry[0] +
                  "\n" +
                  "Neutral: " +
                  faceNeutral[0] +
                  "\n" +
                  "Fear: " +
                  faceFear[0] +
                  "\n" +
                  "Surprise: " +
                  faceSurprise[0] +
                  "\n" +
                  "Sad: " +
                  faceSad[0] +
                  "\n" +
                  "Disgust: " +
                  faceDisgust[0] +
                  "\n" +
                  "Happy: " +
                  faceHappy[0] +
                  "\n"),
          pw.Header(level: 1, child: pw.Text("2)" + domande[1].toString())),
          pw.Paragraph(text: risposte[1].toString()),
          pw.Paragraph(
              text: "Analisi tono vocale su risposta aperta:\n"
                  + "Angry: " +
                  voceAngry[1] +
                  "\n" +
                  "Neutral: " +
                  voceNeutral[1] +
                  "\n" +
                  "Fear: " +
                  voceFear[1] +
                  "\n" +
                  "Surprise: " +
                  voceSurprise[1] +
                  "\n" +
                  "Sad: " +
                  voceSad[1] +
                  "\n" +
                  "Disgust: " +
                  voceDisgust[1] +
                  "\n" +
                  "Happy: " +
                  voceHappy[1] +
                  "\n"),
          pw.Paragraph(
              text: "Analisi espressione facciale su risposta aperta:\n"
                  + "Angry: " +
                  faceAngry[1] +
                  "\n" +
                  "Neutral: " +
                  faceNeutral[1] +
                  "\n" +
                  "Fear: " +
                  faceFear[1] +
                  "\n" +
                  "Surprise: " +
                  faceSurprise[1] +
                  "\n" +
                  "Sad: " +
                  faceSad[1] +
                  "\n" +
                  "Disgust: " +
                  faceDisgust[1] +
                  "\n" +
                  "Happy: " +
                  faceHappy[1] +
                  "\n"),
          pw.Header(level: 1, child: pw.Text("3)" + domande[2].toString())),
          pw.Paragraph(text: risposte[2].toString()),
          pw.Paragraph(
              text: "Analisi tono vocale su risposta aperta:\n"
                  + "Angry: " +
                  voceAngry[2] +
                  "\n" +
                  "Neutral: " +
                  voceNeutral[2] +
                  "\n" +
                  "Fear: " +
                  voceFear[2] +
                  "\n" +
                  "Surprise: " +
                  voceSurprise[2] +
                  "\n" +
                  "Sad: " +
                  voceSad[2] +
                  "\n" +
                  "Disgust: " +
                  voceDisgust[2] +
                  "\n" +
                  "Happy: " +
                  voceHappy[2] +
                  "\n"),
          pw.Paragraph(
              text: "Analisi espressione facciale su risposta aperta:\n"
                  + "Angry: " +
                  faceAngry[2] +
                  "\n" +
                  "Neutral: " +
                  faceNeutral[2] +
                  "\n" +
                  "Fear: " +
                  faceFear[2] +
                  "\n" +
                  "Surprise: " +
                  faceSurprise[2] +
                  "\n" +
                  "Sad: " +
                  faceSad[2] +
                  "\n" +
                  "Disgust: " +
                  faceDisgust[2] +
                  "\n" +
                  "Happy: " +
                  faceHappy[2] +
                  "\n"),
          pw.Header(level: 2, child: pw.Text("Punteggio ottenuto: ")),
          pw.Paragraph(text: punteggio.toString()),
        ];
      },
    ));
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
