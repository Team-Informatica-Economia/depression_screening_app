import 'package:depression_screening_app/ScreenPaziente/Message/ChatScreen.dart';
import 'package:depression_screening_app/ScreenPaziente/Profile/profileScreen.dart';
import 'package:depression_screening_app/ScreenPaziente/Questionario/questionarioPage.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:depression_screening_app/ScreenPsicologo/homePsicologo.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:flutter/material.dart';


class bottomBarPaziente extends StatelessWidget {
  const bottomBarPaziente({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            KColorButtonDark,
                            KColorButtonLight,
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
                new GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatScreen(),));
                  },
                  child: _buildNavItem(Icons.chat_bubble),
                ),
                SizedBox(width: 1,),
                new GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),));
                  },
                  child: _buildNavItem(Icons.home),
                ),
                SizedBox(width: 1,),
                new GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen(),));
                  },
                  child: _buildNavItem(Icons.account_circle),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Chat",style: TextStyle(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w500)),
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
class bottomBarPsicologo extends StatelessWidget {
  const bottomBarPsicologo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            KColorButtonDark,
                            KColorButtonLight,
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
                new GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePagePsicologo()));
                  },
                  child: _buildNavItem(Icons.notifications),
                ),
                SizedBox(width: 1,),
                new GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePagePsicologo()));
                  },
                  child: _buildNavItem(Icons.home),
                ),
                SizedBox(width: 1,),
                new GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePagePsicologo()));
                  },
                  child: _buildNavItem(Icons.account_circle),
                )
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
    backgroundColor: KColorIcon,
    child: CircleAvatar(
      radius: 25,
      backgroundColor: Colors.transparent,
      child: Icon(
        icon,
        color: Colors.white,
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