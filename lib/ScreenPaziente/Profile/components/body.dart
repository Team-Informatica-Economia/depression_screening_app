
import 'package:depression_screening_app/ScreenPaziente/Profile/components/info.dart';
import 'package:flutter/material.dart';



class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Info(
            image: "assets/images/pic.png",
            name: "Mario inglese",
            email: "test1@gmail.com",
          ),
        ],
      ),
    );
  }
}

