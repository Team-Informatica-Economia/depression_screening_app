import 'package:depression_screening_app/ScreenPsicologo/homePsicologo.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:depression_screening_app/Screens/Login/components/background.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/components/rounded_input_field.dart';
import 'package:depression_screening_app/components/rounded_password_field.dart';
import 'package:depression_screening_app/home.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {

  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      if(firebaseUser.email == "test@dep.it")
        return HomePagePsicologo();
      return HomePage();
    }
    Size size = MediaQuery.of(context).size;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController= TextEditingController();
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height*0.3,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: emailController,
              hintText: "Your Email",
              onChanged: (value){},
            ),
            RoundedPasswordField(
              onChanged: (value){},
              controller: passwordController,


            ),
            RoundedButton(
              text: "LOGIN",
              press: (){
                  context.read<AuthenticationService>().sigIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
              },
            ),
          ],
        ),
      ),

      );
    }
}



