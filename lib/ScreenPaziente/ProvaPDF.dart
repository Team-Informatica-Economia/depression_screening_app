import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProvaPDF extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ProvaPDFState();
  }
}
class ProvaPDFState extends State<ProvaPDF>{
  final pdf = pw.Document();

  writePDF(){
    pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(50),
          build: (pw.Context context){
            return <pw.Widget>  [
              pw.Header(
                  level: 0,
                  child: pw.Text("Easy Approach Document")
              ),
              pw.Paragraph(
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
              ),
              pw.Paragraph(
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
              ),
              pw.Header(
                  level: 1,
                  child: pw.Text("Second Heading")
              ),
              pw.Paragraph(
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
              ),
              pw.Paragraph(
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
              ),
              pw.Paragraph(
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
              ),
            ];
          },
        )
    );
  }

  Future saveLocalPDF() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/prova.pdf");
    file.writeAsBytes(pdf.save());
    savePdf(file.readAsBytesSync(),"prova.pdf");
  }

  savePdf(List<int> asset, String name) async{
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putData(asset);
    //String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    //documentFileUpload(url);
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FloatingActionButton(
          onPressed: () async{
           writePDF();
           await saveLocalPDF();
          },
        ),
      )
    );
  }


}
