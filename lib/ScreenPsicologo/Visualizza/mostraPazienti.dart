import 'package:depression_screening_app/ScreenPsicologo/Visualizza/detailPaziente.dart';
import 'package:depression_screening_app/ScreenPsicologo/homePsicologo.dart';
import 'package:depression_screening_app/components/bottomBar.dart';
import 'package:depression_screening_app/components/searchBar.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';

class MostraPazienti extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MostraPazientiState();
  }
}

class MostraPazientiState extends State<MostraPazienti> {
  TextEditingController _searchBarController = TextEditingController();
  var flag = 1;
  Future userFuture;
  List<Users> pazienti;
  List<Users> pazientiView;

  @override
  void initState() {
    super.initState();
    userFuture = _getPazienti();
    _searchBarController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchBarController.removeListener(_onSearchChanged);
    _searchBarController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResult();
  }

  searchResult() {
    List<Users> users = [];
    if (_searchBarController.text != "") {
      users = pazienti.where((note) {
        var nome = note.nome.toLowerCase();
        var cognome = note.cognome.toLowerCase();
        String str = nome + " " + cognome;
        return str.contains(_searchBarController.text.toLowerCase());
      }).toList();
    } else {
      users = pazienti;
    }
    setState(() {
      pazientiView = users;
    });
  }

  _getPazienti() async {
    return await readListPazienti();
  }

  _searchBar() {
    return TextField(
      decoration: InputDecoration(
          hintText: 'Search...',
          icon: Icon(
            Icons.search,
            color: KPrimaryColor,
          ),
          border: InputBorder.none),
      controller: _searchBarController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryColor,
      extendBody: true,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 55.0, left: 40.0),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePagePsicologo();
                          },
                        ),
                      );
                    }
                ),
                Text('Lista',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('pazienti',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 155.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                    boxShadow: kElevationToShadow[6],
                  ),
                  child: _searchBar(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: FutureBuilder(
                    future: userFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        pazienti = snapshot.data;
                        if (flag == 1) {
                          pazientiView = pazienti;
                          flag = 2;
                        }
                        return displayInformation(context, snapshot);
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      //bottomNavigationBar: bottomBarPsicologo(),
    );
  }

  Widget _buildUserItem(String imgPath, Users user) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPazienti(user: user)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Image(
                      image: AssetImage(imgPath),
                      fit: BoxFit.cover,
                      height: 75.0,
                      width: 75.0),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.nome + " " + user.cognome,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold)),
                        Text(user.email,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey))
                      ])
                ])),
              ],
            )));
  }

  Widget displayInformation(context, snapshot) {
    return Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            maxHeight: 380.0,
          ),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: pazientiView.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      _buildUserItem(
                          "assets/images/pic.png", pazientiView[index]),
                      SizedBox(height: 15.0),
                    ],
                  ),
                );
              }),
        )
    );
  }
}
