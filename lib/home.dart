import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'Screens/Quiz/quiz.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser == null){
      return LoginScreen();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KPrimaryColor,
      extendBody: true,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: Colors.white,
                          onPressed: () {
                            context.read<AuthenticationService>().signOut();
                          },
                        ),
                      ],
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Depression',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('Screening',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 30.0),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height-165,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                /*Padding(
                   padding: EdgeInsets.only(top: 45.0),
               ),*/
                SizedBox(height: 55.0),
                InkWell(
                  child: Container(
                    //height: 135,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width*0.4,
                            top: 40,
                            right: 30,
                          ),
                          height: 120,
                          width: double.infinity,
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
                                      text: "Completa il quiz",
                                      style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)
                                  ),
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SvgPicture.asset("assets/icons/nurse.svg"),
                        ),

                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context){
                          return getjson();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _getNavBar(context),
    );
  }
  _getNavBar(context) {
    return Container(
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
              bottom: 0,
              child:ClipPath(
                clipper: NavBarClipper(),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.deepPurpleAccent,
                            Colors.deepPurple,
                          ]
                      )
                  ),
                ),
              )
          ),
          Positioned(
            bottom: 45,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildNavItem(Icons.notifications),
                SizedBox(width: 1,),
                _buildNavItem(Icons.home),
                SizedBox(width: 1,),
                _buildNavItem(Icons.account_circle),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Notifiche",style: TextStyle(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w500)),
                SizedBox(width: 1,),
                Text("Home",style: TextStyle(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w500)),
                SizedBox(width: 2,),
                Text("Profilo",style: TextStyle(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
_buildNavItem(IconData icon){
  return CircleAvatar(
    radius: 30,
    backgroundColor: Colors.amber,
    child: CircleAvatar(
      radius: 25,
      backgroundColor: Colors.transparent,
      child: Icon(
        icon,
        color: Colors.black,
      ),
    ),
  );
}
class NavBarClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw/12, 0, sw/12, 2*sh/5, 2*sw/12, 2*sh/5);
    path.cubicTo(3*sw/12, 2*sh/5, 3*sw/12, 0, 4*sw/12, 0);
    path.cubicTo(5*sw/12, 0, 5*sw/12, 2*sh/5, 6*sw/12, 2*sh/5);
    path.cubicTo(7*sw/12, 2*sh/5, 7*sw/12, 0, 8*sw/12, 0);
    path.cubicTo(9*sw/12, 0, 9*sw/12, 2*sh/5, 10*sw/12, 2*sh/5);
    path.cubicTo(11*sw/12, 2*sh/5, 11*sw/12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
