import 'package:depression_screening_app/Screens/Quiz/quiz.dart';
import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:flutter/material.dart';

class quizpageopen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RoundedButtonQuiz(
            text: "Schermata dove inserire la risposta aperta....",
            press: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
