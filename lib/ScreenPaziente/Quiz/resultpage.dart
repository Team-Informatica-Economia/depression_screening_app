import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:flutter/material.dart';

class resultpage extends StatelessWidget {
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
                  press: (){Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context){
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