import 'dart:async';
import 'dart:convert';
import 'package:depression_screening_app/ScreenPaziente/Quiz/rispostaAperta.dart';
import 'package:depression_screening_app/components/rounded_button_quiz.dart';
import 'package:depression_screening_app/components/title_question.dart';
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
  bool microfono=false;

  var mydata;
  _quizpageState(this.mydata);

  void nextQuestion(String let) {
    setState(() {
      if (iDomanda < 3) {
        iDomanda++;
        print(iDomanda);
      } else {
          microfono=true;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => quizpageopen(microfono: microfono, risposta: mydata[1][iDomanda.toString()][let],)));

      }



    });

  }

  void checkanswer(int i, String let){
    punteggio += i;
    print(iDomanda);
    String yDomanda = iDomanda.toString();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => quizpageopen(microfono: microfono, risposta: mydata[1][yDomanda][let])),
   );

    nextQuestion(let);
    
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
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Title_question(testo: mydata[0][iDomanda.toString()]+":"),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundedButtonQuiz(
                      text: mydata[1][iDomanda.toString()]["a"],
                      press: (){
                        checkanswer(0, "a");
                      },
                    ),
                    RoundedButtonQuiz(
                      text: mydata[1][iDomanda.toString()]["b"],
                      press: (){
                        checkanswer(1, "b");
                      },
                    ),
                    RoundedButtonQuiz(
                      text: mydata[1][iDomanda.toString()]["c"],
                      press: (){
                        checkanswer(2, "c");
                      },
                    ),
                    RoundedButtonQuiz(
                      text: mydata[1][iDomanda.toString()]["d"],
                      press: (){
                        checkanswer(3, "d");
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

