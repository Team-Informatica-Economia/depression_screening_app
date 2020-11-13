import 'package:depression_screening_app/ScreenPsicologo/homePsicologo.dart';
import 'package:depression_screening_app/components/text_fiels_container.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:depression_screening_app/Screens/Login/components/background.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/components/rounded_input_field.dart';
import 'package:depression_screening_app/components/rounded_password_field.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
    String _password;
    String _email;
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
              TextFieldContainer(
                child: TextField(
                  onChanged: (val){
                    _email=val;
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: KPrimaryColor,
                      ),
                      hintText: "Your Email",
                      border: InputBorder.none
                  ),
                ),
              ),
            TextFieldContainer(
              child: TextFormField(
                obscureText: _obscureText,
                onChanged: (val){
                    _password=val;
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    icon: Icon(
                      Icons.lock,
                      color: KPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      color: KPrimaryColor,
                      onPressed: _toggle,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),

            RoundedButton(
              text: "LOGIN",
              press: (){
                print(_email);
                print(_password);
                context.read<AuthenticationService>().sigIn(
                  email: _email,
                  password: _password
                );
              },
            ),
          ],
        ),
      ),

    );
  }
}




