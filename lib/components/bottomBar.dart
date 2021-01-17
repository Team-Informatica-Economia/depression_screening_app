import 'package:depression_screening_app/ScreenPaziente/Message/ChatScreen.dart';
import 'package:depression_screening_app/ScreenPaziente/Profile/profileScreen.dart';
import 'package:depression_screening_app/ScreenPaziente/Questionario/questionarioPage.dart';
import 'package:depression_screening_app/ScreenPaziente/homePaziente.dart';
import 'package:depression_screening_app/ScreenPsicologo/homePsicologo.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class bottomBarPaziente extends StatefulWidget {
  int numPage;

  bottomBarPaziente({Key key, this.numPage}) : super(key: key);

  @override
  bottomBarPazienteState createState() =>
      bottomBarPazienteState(this.numPage);
}

class bottomBarPazienteState extends State<bottomBarPaziente> {

  int _selectedItemPosition;
  bottomBarPazienteState(this._selectedItemPosition);

  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );

  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;

  Color selectedColor = KPrimaryColor;
  Gradient selectedGradient =
  const LinearGradient(colors: [Colors.red, Colors.amber]);

  Color unselectedColor = Colors.blueGrey;
  Gradient unselectedGradient =
  const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

  Color containerColor;
  List<Color> containerColors = [
    const Color(0xFFFDE1D7),
    const Color(0xFFE4EDF5),
    const Color(0xFFE7EEED),
    const Color(0xFFF4E4CE),
  ];

  @override
  Widget build(BuildContext context) {


    return SnakeNavigationBar.color(
      backgroundColor: KColorBottomBar,
      behaviour: snakeBarStyle,
      snakeShape: snakeShape,
      shape: bottomBarShape,
      padding: padding,

      ///configuration for SnakeNavigationBar.color
      snakeViewColor: selectedColor,
      selectedItemColor:
          snakeShape == SnakeShape.indicator ? selectedColor : null,
      unselectedItemColor: Colors.blueGrey,

      ///configuration for SnakeNavigationBar.gradient
      // snakeViewGradient: selectedGradient,
      // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
      // unselectedItemGradient: unselectedGradient,

      showUnselectedLabels: showUnselectedLabels,
      showSelectedLabels: showSelectedLabels,

      currentIndex: _selectedItemPosition,
      onTap: (index) => setState(() {
        //_selectedItemPosition = index;
        _onPageChanged(index);
      }),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedLabelStyle: const TextStyle(fontSize: 14),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
    );
  }

  void _onPageChanged(int page) {
    containerColor = containerColors[page];


    switch (page) {
      case 0:
        setState(() {
          snakeBarStyle = SnakeBarBehaviour.floating;
          snakeShape = SnakeShape.circle;
          padding = const EdgeInsets.all(12);
          bottomBarShape =
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
          showSelectedLabels = true;
          showUnselectedLabels = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatScreen();
            },
          ),
        );
        break;
      case 1:
        setState(() {
          snakeBarStyle = SnakeBarBehaviour.floating;
          snakeShape = SnakeShape.circle;
          padding = const EdgeInsets.all(12);
          bottomBarShape =
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
          showSelectedLabels = true;
          showUnselectedLabels = true;
        });


        if(_selectedItemPosition != 1){

          Navigator.pop(
            context
          );
        }
        break;

      case 2:
        setState(() {
          snakeBarStyle = SnakeBarBehaviour.floating;
          snakeShape = SnakeShape.circle;
          padding = const EdgeInsets.all(12);
          bottomBarShape =
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
          showSelectedLabels = true;
          showUnselectedLabels = true;
        });
        print(_selectedItemPosition);
        if(_selectedItemPosition != 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProfileScreen();
              },
            ),
          );
        }
        break;
    }
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
              child: ClipPath(
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
                      ])),
                ),
              )),
          Positioned(
            bottom: 45,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePagePsicologo()));
                  },
                  child: _buildNavItem(Icons.notifications),
                ),
                SizedBox(
                  width: 1,
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePagePsicologo()));
                  },
                  child: _buildNavItem(Icons.home),
                ),
                SizedBox(
                  width: 1,
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePagePsicologo()));
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
                Text("Notifiche",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 1,
                ),
                Text("Home",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 2,
                ),
                Text("Profilo",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

_buildNavItem(IconData icon) {
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

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
