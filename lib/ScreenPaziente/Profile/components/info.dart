import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../constants.dart';
import '../../../constants.dart';
import '../../../constants.dart';
import '../../../constants.dart';
import '../../../size_config.dart';



class Info extends StatelessWidget {
    const Info({
    Key key,
    this.name,
    this.email,
    this.image,
    this.eta,
    this.regione,
    this.provincia,
    this.scuola,
    this.sesso,
    this.statoCivile,
  }) : super(key: key);
  final String name, email, image, eta, regione, provincia, scuola, sesso, statoCivile;

  @override
  Widget build(BuildContext context) {
    SizeConfig sc = new SizeConfig();
    sc.init(context);
    double defaultSize = SizeConfig.defaultSize;
    return SizedBox(
      height: defaultSize * 45, // 240
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 20, //150
              color: KPrimaryColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: defaultSize), //10
                  height: defaultSize * 18, //140
                  width: defaultSize * 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.8, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image),
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: defaultSize * 2.9, // 22
                    color: Color(0xff4e4b44),
                  ),
                ),
                SizedBox(height: defaultSize / 2), //5
                Text(
                  email,
                  style: TextStyle(
                    fontSize: defaultSize * 2.1,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8492A2),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Fascia di età: ",
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: Color(0xff4e4b44),
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      eta,
                      style: TextStyle(
                        fontSize: defaultSize * 1.8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8492A2),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Regione: ",
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: Color(0xff4e4b44),
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      regione,
                      style: TextStyle(
                        fontSize: defaultSize * 1.8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8492A2),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Provincia: ",
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: Color(0xff4e4b44),
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      provincia,
                      style: TextStyle(
                        fontSize: defaultSize * 1.8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8492A2),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Scuola: ",
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: Color(0xff4e4b44),
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      scuola,
                      style: TextStyle(
                        fontSize: defaultSize * 1.8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8492A2),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sesso: ",
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: Color(0xff4e4b44),
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      sesso,
                      style: TextStyle(
                        fontSize: defaultSize * 1.8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8492A2),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Stato civile: ",
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: Color(0xff4e4b44),
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      statoCivile,
                      style: TextStyle(
                        fontSize: defaultSize * 1.8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8492A2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}