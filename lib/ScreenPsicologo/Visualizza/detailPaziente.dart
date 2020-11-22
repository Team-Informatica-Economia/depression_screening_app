import 'package:depression_screening_app/ScreenPsicologo/Visualizza/PdfPreviewScreen.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/AppuntamentoObj.dart';
import 'package:depression_screening_app/services/Questionario.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DetailPazienti extends StatefulWidget {
  final Users user;

  const DetailPazienti({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailPazientiState(user);
  }
}

class DetailPazientiState extends State<DetailPazienti> {
  Users user;
  DateTime giorno;
  TimeOfDay orario;
  DetailPazientiState(this.user);

  Future userFuture;
  List<Questionario> questionari;

  @override
  void initState() {
    super.initState();
    userFuture = _getQuestionari();
    giorno = DateTime.now();
    orario = TimeOfDay.now();
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
              padding: EdgeInsets.only(left: 40.0, top: 70),
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
              height: MediaQuery.of(context).size.height - 129,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 45.0),
                    InkWell(
                      child: Container(
                        //height: 135,

                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.4,
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
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Nuovo appuntamento",
                                      style: Theme.of(context)
                                          .textTheme
                                          .title
                                          .copyWith(color: Colors.white)),
                                ]),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: SvgPicture.asset("assets/icons/nurse.svg"),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Alert(
                            context: context,
                            title: "Nuovo appuntamento",
                            content: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                      "Giorno: ${giorno.day}/${giorno.month}/${giorno.year}"),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                  onTap: _pickGiorno,
                                ),
                                ListTile(
                                  title: Text(
                                      "Orario: ${orario.hour}:${orario.minute}"),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                  onTap: _pickOrario,
                                ),
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  String orarioString =
                                      "${orario.hour}:${orario.minute}";
                                  addAppuntamento(
                                      user.email,
                                      AppuntamentoObj(
                                          giorno.day.toString(),
                                          monthsInYear[giorno.month],
                                          giorno.year.toString(),
                                          dayInWeek[giorno.weekday],
                                          orarioString));
                                  Navigator.pop(context);
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Appuntamento",
                                    desc: "Appuntamento creato con successo.",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Chiudi",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                },
                                child: Text(
                                  "Crea appuntamento",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Appuntamento(emailPaziente: user.email,),));
                      },
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Lista dei questionari eseguiti",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FutureBuilder(
                      future: userFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          questionari = snapshot.data;

                          return displayInformation(context, snapshot);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget displayInformation(context, snapshot) {
    return ConstrainedBox(
        constraints: new BoxConstraints(
          maxHeight: 420.0,
        ),
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
            }));
  }

  Widget _buildQuestionarioItem(Questionario questionario) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PdfScreen(path: questionario.path)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Image(
                      image: AssetImage("assets/images/questionario.png"),
                      fit: BoxFit.cover,
                      height: 75.0,
                      width: 75.0),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(questionario.titoloPdf,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                      ])
                ])),
              ],
            )));
  }

  _pickGiorno() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDate: giorno,
    );
    if (date != null) {
      setState(() {
        giorno = date;
      });
    }
  }

  _pickOrario() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: orario,
    );
    if (t != null) {
      setState(() {
        orario = t;
      });
    }
  }
}
