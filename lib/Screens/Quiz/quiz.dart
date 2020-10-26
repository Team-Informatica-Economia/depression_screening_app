import 'dart:async';
import 'dart:convert';
import 'package:depression_screening_app/Screens/Quiz/resultpage.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class getjson extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
     future: DefaultAssetBundle.of(context).loadString("assets/questionario.json"),
     builder: (context,snapshot){
       List mydata = json.decode(snapshot.data.toString());
       if(mydata == null){
         return Scaffold(
           body: Center(
             child: Text(
               "Caricamento..."
             ),
           ),
         );
       }else{
         return quizpage( mydata : mydata);
       }
     },
   );
  }
}

class quizpage extends StatefulWidget{
  List mydata;
  quizpage({
    Key key,
    @required this.mydata})
      : super (key : key);

  @override
  _quizpageState createState() => _quizpageState( mydata);
}
class _quizpageState extends State<quizpage>{

  int punteggio = 0;
  int iDomanda = 1;
  var mydata;
  _quizpageState(this.mydata);

  void nextQuestion() {
    setState(() {
      if (iDomanda <3) {
        iDomanda++;
        print(iDomanda);
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => resultpage(),
        ));
      }
    });

  }

  void checkanswer(int i){
    punteggio += i;
    nextQuestion();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,DeviceOrientation.portraitUp
    ]);
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  mydata[0][iDomanda.toString()],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundedButton(
                      text: mydata[1][iDomanda.toString()]["a"],
                      press: (){
                        checkanswer(0);
                      },
                    ),
                    RoundedButton(
                      text: mydata[1][iDomanda.toString()]["b"],
                      press: (){
                        checkanswer(1);
                      },
                    ),
                    RoundedButton(
                      text: mydata[1][iDomanda.toString()]["c"],
                      press: (){
                        checkanswer(2);
                      },
                    ),
                    RoundedButton(
                      text: mydata[1][iDomanda.toString()]["d"],
                      press: (){
                        checkanswer(3);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

