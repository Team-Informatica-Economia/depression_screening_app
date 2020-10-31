import 'package:depression_screening_app/Screens/Quiz/quiz.dart';
import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:flutter/material.dart';

class quizpageopen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          FloatingActionButton(
            child: Icon(Icons.mic),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
      ),
    );
  }
}
