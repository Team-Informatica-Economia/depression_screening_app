import 'package:depression_screening_app/Screens/Quiz/quiz.dart';
import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:depression_screening_app/Screens/Quiz/resultpage.dart';

class quizpageopen extends StatelessWidget {
  Recording _recording = new Recording();
  final bool microfono;

  quizpageopen({Key key, this.microfono}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          FloatingActionButton(
            child: Icon(Icons.mic),
            onPressed: (){
              Recording _recording = new Recording();
              print("Registro");



              if(microfono){
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => resultpage()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
      ),
    );
  }
}
