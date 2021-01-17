import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/Screens/Welcome/components/background.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: size.height * 0.05),
        Text(
          "Cadi sette volte, rialzati otto",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black54),
          textAlign: TextAlign.center,
      ),
      SizedBox(height: size.height * 0.04),
      Image.asset(
        "assets/icons/welcomeImage.png",
        height: size.height*0.5,
      ),
        RoundedButton(
          text: "Login",
          press: (){Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context){
                return LoginScreen();
                },
            ),
          );
          },
        )
      ],
    ),
    );
  }
}

