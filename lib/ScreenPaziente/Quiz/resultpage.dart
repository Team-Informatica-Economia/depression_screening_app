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

  List<String> domande = new List(3);
  List<String> risposte = new List(3);
  int punteggio;

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  readSharedPreferences() async {
    SharedPreferences sharedPrefs = await getSharedPreferencesInstance();
    setState(() {
      for(int i = 1; i <= 3; i++){
        domande[i-1] = sharedPrefs.getString("domanda"+i.toString());
        risposte[i-1] = sharedPrefs.getString("risposta"+i.toString());
      }
      punteggio = sharedPrefs.getInt("punteggio");
    });
  }

  writePDF() {
    pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(50),
          build: (pw.Context context){
            return <pw.Widget>  [
              pw.Header(
                  level: 0,
                  child: pw.Text("Risultati questionario ")
              ),
              pw.Paragraph(
                  text: "Di seguito i risultati del questionario compilato: " + generaNome()
              ),
              pw.Header(
                  level: 1,
                  child: pw.Text(domande[0].toString())
              ),
              pw.Paragraph(
                  text: risposte[0].toString()
              ),
              pw.Header(
                  level: 1,
                  child: pw.Text(domande[1].toString())
              ),
              pw.Paragraph(
                  text: risposte[1].toString()
              ),
              pw.Header(
                  level: 1,
                  child: pw.Text(domande[2].toString())
              ),
              pw.Paragraph(
                  text: risposte[2].toString()
              ),
              pw.Header(
                  level: 2,
                  child: pw.Text("Punteggio ottenuto: ")
              ),
              pw.Paragraph(
                  text: punteggio.toString()
              ),
            ];
          },
        )
    );
  }

  String generaNome(){
    DateTime dateTime = DateTime.now();
    return dateTime.toString() + ".pdf";
  }

  Future saveLocalPDF() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    String nomeFile = generaNome();
    File file = File("$documentPath/$nomeFile");
    file.writeAsBytes(pdf.save());
    savePdf(file, nomeFile);
  }

  savePdf(File asset, String name) async{
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putFile(asset);
    String url = await (await uploadTask).ref.getDownloadURL();
    print("url " + url);
    Questionario quest = new Questionario(name, url);
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
