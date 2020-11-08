import 'dart:math';

import 'package:depression_screening_app/ScreenPaziente/Quiz/resultpage.dart';
import 'package:depression_screening_app/components/title_question.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:flutter_sound/flutter_sound.dart';


class quizpageopen extends StatefulWidget {
  final bool microfono;
  final String risposta;
  quizpageopen({Key key, this.microfono, this.risposta}): super(key: key);

  @override
  _quizpageopen createState() => _quizpageopen(microfono, risposta);
}

class _quizpageopen extends State<quizpageopen>{
  var microfono, risposta;
  _quizpageopen(this.microfono, this.risposta);
  bool _isMicrophoneActive = false;

  void _disabilitaNextDomanda(){
    setState(()  {
      if(_isMicrophoneActive == false) {
        _isMicrophoneActive = true;
      }
      else
        _cambiaPage();
    });
  }


  void _cambiaPage(){
    setState(() {
      if (microfono) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => resultpage()));
      } else {
        Navigator.pop(context);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Title_question(testo: "Cosa significa per te: \n"+"\""+risposta+"\"?"),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              width: 200,
              height: 200,
              child: FloatingActionButton(
                child: _isMicrophoneActive ? Icon(Icons.stop, size: 110,) : Icon(Icons.mic, size: 110,),
                backgroundColor: _isMicrophoneActive ? Colors.red : Colors.purple,
                elevation: 20,
                onPressed: (){

                  _disabilitaNextDomanda();
                  print("ciao" + _isMicrophoneActive.toString());


                  /*if(microfono){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => resultpage()));
                } else {
                  Navigator.pop(context);
                }*/
                },
              ),
            ),

          ),
          Expanded(
            flex: 1,
            child: RaisedButton(
              color: Color( 0xffb8cae7),

              elevation: 4,
              child: Text("Preferisco non rispondere", style: Theme.of(context).textTheme.title.copyWith(color: Colors.black),),
              onPressed: _isMicrophoneActive ? null : _cambiaPage,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]
      )
    );

  }


}




