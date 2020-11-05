import 'package:depression_screening_app/Screens/Questionario/components/customInputBoxName.dart';
import 'package:depression_screening_app/Screens/Questionario/components/customInputBoxSurname.dart';
import 'package:depression_screening_app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionarioPage extends StatefulWidget{
  QuestionarioPage({Key key}): super(key: key);

  @override
  _QuestionarioPageState createState() => _QuestionarioPageState();

}

class _QuestionarioPageState extends State<QuestionarioPage> {
  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  //
                  MyCustomInputBoxName(
                    label: 'Nome',
                    inputHint: 'Mario',
                  ),
                  //
                  SizedBox(
                    height: 15,
                  ),
                  //
                  MyCustomInputBoxSurname(
                    label: 'Cognome',
                    inputHint: 'Rossi',
                  ),
                  //
                  SizedBox(
                    height: 30,
                  ),

                new GestureDetector(
                      onTap: (){

                      },

                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context){
                                print("Dati compilati");
                                return HomePage();
                              }
                          )
                      ); */


                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: scrWidth * 0.85,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Color(0xff0962ff),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Neu_button(
                        char: "Completa il questionario",
                      )
                  )

                ),

                ],
              ),
             /* ClipPath(
                clipper: OuterClippedPart(),
                child: Container(
                  color: Color(0xff0962ff),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
              //
              ClipPath(
                clipper: InnerClippedPart(),
                child: Container(
                  color: Color(0xff0c2551),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),*/
            ],
          ),
        ),
      );
  }


}

class Neu_button extends StatelessWidget {
  Neu_button({this.char});
  String char;
  @override
  Widget build(BuildContext context) {
    return Container(

      width: 100,
      height: 300,
      decoration: BoxDecoration(

        //color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            offset: Offset(30, 30),
            blurRadius: 26,
            color: Color(0xff1e90ff).withOpacity(0.1),
          )
        ],
      ),
      //
      child: Center(

        child: Text(
          char,
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffFF),
          ),
        ),

      ),

    );

  }

}
/*
class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    //
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
} */