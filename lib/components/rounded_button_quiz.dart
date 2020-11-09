import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedButtonQuiz extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButtonQuiz({
    Key key,
    this.text,
    this.press,
    this.color = KPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width*0.92,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20 ),
          color: KPrimaryColor,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

