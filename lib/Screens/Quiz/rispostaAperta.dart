import 'package:depression_screening_app/Screens/Quiz/quiz.dart';
import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:depression_screening_app/Screens/Quiz/resultpage.dart';
import 'package:depression_screening_app/components/rounded_button.dart';


class quizpageopen extends StatefulWidget {
  final bool microfono;
  quizpageopen({Key key, this.microfono}): super(key: key);

  @override
  _quizpageopen createState() => _quizpageopen(microfono);
}

class _quizpageopen extends State<quizpageopen> {
  Recording _recording = new Recording();
  var microfono;
  _quizpageopen(this.microfono);
  bool _isMicrophoneActive = false;

  void _disabilitaNextDomanda() {
    setState(() {
      if(_isMicrophoneActive == false)
        _isMicrophoneActive = true;
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Text("Per registrare premi l'icona e quando hai terminato premila di nuovo",),
          Center(
            child: FloatingActionButton(
              child: Icon(Icons.mic),
              onPressed: (){
                Recording _recording = new Recording();
                print("Registro");
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
          RaisedButton(
            child: Text("Preferisco non rispondere"),
            onPressed: _isMicrophoneActive ? null : _cambiaPage,
          )
        ]
      )
    );
  }
}
