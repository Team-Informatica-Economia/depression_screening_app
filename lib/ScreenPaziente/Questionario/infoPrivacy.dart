import 'package:depression_screening_app/ScreenPaziente/Quiz/quiz.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoPrivacy extends StatefulWidget {
  InfoPrivacy({Key key}) : super(key: key);

  @override
  _InfoPrivacyState createState() => _InfoPrivacyState();
}

class _InfoPrivacyState extends State<InfoPrivacy> {
  bool selected = false;
  bool avvisaPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Leggi attentamente le seguenti istruzioni",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 30,
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Per favore legga attentamente le affermazioni di ciascun gruppo.Per ogni gruppo scelga quella che "
                              "meglio descrive come Lei si è sentito nelle ultime due settimane (incluso oggi).Faccia"
                              "una crocetta sul numero corrispondente all’affermazione da Lei scelta. Se più di una"
                              " affermazione dello stesso gruppo descrive ugualmente bene come Lei si sente, faccia"
                              "una crocetta sul numero più elevato per quel gruppo",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 20,
                            color: Color(0xff8f9db5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                      scale: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.5, color: avvisaPrivacy ? Colors.red : Colors.transparent),
                            left: BorderSide(width: 1.5, color: avvisaPrivacy ? Colors.red : Colors.transparent),
                            right: BorderSide(width: 1.5, color: avvisaPrivacy ? Colors.red : Colors.transparent),
                            bottom: BorderSide(width: 1.5, color: avvisaPrivacy ? Colors.red : Colors.transparent),
                          ),
                        ),
                        child: Transform.scale(
                          scale: 2.0,
                          child: Checkbox(
                              value: selected,
                              activeColor: KPrimaryColor,
                              onChanged:(bool newValue){
                                setState(() {
                                  selected = newValue;
                                });
                              }
                          ),
                        )
                      ),
                    ),
                    Text(
                        "Accetta informativa sulla privacy",
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 18,
                          color: Color(0xff8f9db5),
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: RoundedButton(
                text: "Inizia il quiz",
                press: () {
                  if(selected){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => getjson(),
                    ));
                  } else {
                    setState(() {
                      avvisaPrivacy = true;
                    });
                  }
                },
              )
            ),
          ]
        )
    ));
  }
}
