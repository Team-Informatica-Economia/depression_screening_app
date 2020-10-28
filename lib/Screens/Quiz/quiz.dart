import 'dart:async';
import 'dart:convert';
import 'package:depression_screening_app/Screens/Quiz/resultpage.dart';
import 'package:depression_screening_app/Screens/Quiz/rispostaAperta.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/components/rounded_button_quiz.dart';
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
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => quizpageopen()),
   );

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
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 180,
                      width: MediaQuery.of(context).size.width*0.98,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF60BE93),
                            Color(0xFF1B8D59),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: mydata[0][iDomanda.toString()]+":",
                                  style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)
                              ),
                            ]
                        ),
                      ),
                    ),
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
                        checkanswer(0);
                      },
                    ),
                    RoundedButtonQuiz(
                      text: mydata[1][iDomanda.toString()]["b"],
                      press: (){
                        checkanswer(1);
                      },
                    ),
                    RoundedButtonQuiz(
                      text: mydata[1][iDomanda.toString()]["c"],
                      press: (){
                        checkanswer(2);
                      },
                    ),
                    RoundedButtonQuiz(
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

