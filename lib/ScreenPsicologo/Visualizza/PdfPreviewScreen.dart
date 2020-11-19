import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class PdfScreen extends StatefulWidget{
  String path;

  PdfScreen({Key key, this.path}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PdfScreenState(path);
  }

}
class PdfScreenState extends State<PdfScreen>{
  String  path;
  PdfScreenState(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PDF(
        ).cachedFromUrl(path),
      ),
    );
  }

}