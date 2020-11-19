import 'package:depression_screening_app/ScreenPsicologo/Visualizza/PdfPreviewScreen.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/Questionario.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';



class DetailPazienti extends StatefulWidget{
  final Users user;

  const DetailPazienti({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailPazientiState(user);
  }
}

class DetailPazientiState extends State<DetailPazienti> {
  Users user;
  DetailPazientiState(this.user);

  Future userFuture;
  List<Questionario> questionari;

  @override
  void initState() {
    super.initState();
    userFuture = _getQuestionari();

  }
  _getQuestionari() async {
    return await readListQuestionari(user);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
              color: KPrimaryColor,
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 30,right: 30,top: 75),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/pic.png")
                              )
                          ),
                        ),
                        SizedBox(width: 50),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(user.nome +" "+user.cognome, style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                            ]
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
          Padding(
            padding:  EdgeInsets.only(top: 175),
            child: FutureBuilder(
              future: userFuture,
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  questionari = snapshot.data;

                  return displayInformation(context, snapshot);
                }else{
                  return CircularProgressIndicator();
                }
              },
            ),
          )
        ],
      ),
    );
  }
  Widget displayInformation(context,snapshot) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: questionari.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      _buildQuestionarioItem(questionari[index]),
                      SizedBox(height: 15.0),
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
  Widget  _buildQuestionarioItem(Questionario questionario) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => PdfScreen(path: questionario.path)
              ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(
                        children: [
                          Image(
                              image: AssetImage("assets/images/questionario.png"),
                              fit: BoxFit.cover,
                              height: 75.0,
                              width: 75.0
                          ),
                          SizedBox(width: 10.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                    questionario.titoloPdf,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ]
                          )
                        ]
                    )
                ),
              ],
            )
        ));
  }
}
