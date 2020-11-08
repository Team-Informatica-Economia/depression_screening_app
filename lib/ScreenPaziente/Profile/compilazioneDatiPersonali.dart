
import 'package:depression_screening_app/ScreenPaziente/Profile/components/bodyDatiPersonali.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DatiPersonali extends StatefulWidget{
  DatiPersonali({Key key, this.title}):super(key: key);
  final String title;


  @override
  _DatiPersonali createState() => _DatiPersonali();
}

class _DatiPersonali extends State<DatiPersonali> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyDatiPersonali(),

    );



  }






  }




