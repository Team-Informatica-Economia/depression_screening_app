import 'package:depression_screening_app/ScreenPsicologo/Visualizza/Appuntamento.dart';
import 'package:depression_screening_app/ScreenPsicologo/Visualizza/PdfPreviewScreen.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/Questionario.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: KPrimaryColor,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 40.0,top: 70),
            child: Row(
              children: <Widget>[
                Text(user.nome,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text(user.cognome,
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
                            right: 20,

                          ),
                          height: 120,

                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                KColorButtonLight,
                                KColorButtonDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Nuovo appuntamento",
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Appuntamento(emailPaziente: user.email,),));
                  },
                ),
                SizedBox(height: 20.0),
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text("Lista dei questionari eseguiti",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                    ),
                ),

                FutureBuilder(
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
              ],
            ),
          ),
        ],
      )
    );
  }
  Widget displayInformation(context,snapshot) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0),
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
        padding: EdgeInsets.only(top: 5.0),
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
