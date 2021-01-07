

import 'package:depression_screening_app/ScreenPsicologo/Visualizza/detailPaziente.dart';
import 'package:depression_screening_app/services/Messaggio.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ChatPsicologo extends StatefulWidget{
  final Users user;

  const ChatPsicologo({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatPsicologoState(user);
  }
}
class _ChatPsicologoState extends State<ChatPsicologo>{
  Users user;
  _ChatPsicologoState(this.user);

  Future userFuture;
  Future messaggiFuture;
  List<Messaggio> listaMessaggi;
  TextEditingController messaggioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
    messaggiFuture = _getMessaggi();
  }
  _getUser() async {
    return await readUser();
  }
  _getMessaggi() async {
    return await readListMessaggioPsicologo(user.email);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sc = new SizeConfig();
    sc.init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      backgroundColor: KPrimaryColor,
      extendBody: true,
      body: Container(
        child: FutureBuilder(
          future: userFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return displayInformation(context, snapshot);
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
  Widget displayInformation(BuildContext context,snapshot){
    Users utenteLoggato = snapshot.data;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: KPrimaryColor,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          iconSize: 50,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailPazienti(user: user,);
                                },
                              ),
                            ); */
                          },
                        ),
                        Text(
                          user.nome + " " + user.cognome,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: FutureBuilder(
                    future: messaggiFuture,
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        listaMessaggi = snapshot.data;
                        return chatDisplay(context, snapshot);
                      } else{
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.84,
                        child: TextField(
                          decoration: InputDecoration(
                            focusColor: KPrimaryColor,
                            hoverColor: KPrimaryLightColor,
                            border: OutlineInputBorder(),
                            labelText: 'Message...',
                          ),
                          controller: messaggioController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: (){
                          DateTime time = DateTime.now();
                          addMessaggioByPsicologo(Messaggio(messaggioController.text.trim(), "0", time.toString()), user.email);
                          setState(() {
                            messaggiFuture = _getMessaggi();
                          });
                          messaggioController.clear();
                        },
                      )
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMessaggio(Messaggio messaggio) {
    if(messaggio.isPaziente=="0"){
      return ChatBubble(
        clipper:  ChatBubbleClipper10(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 10),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text( messaggio.messaggio,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      );
    }else {
      return  ChatBubble(
        clipper: ChatBubbleClipper10(type: BubbleType.receiverBubble),
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            messaggio.messaggio,
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ),
      );
    }
  }
  Widget chatDisplay(context,snapshot) {
    return Padding(
        padding: EdgeInsets.only(left: 7.0, right: 7.0,),
        child: Container(
          height: SizeConfig.defaultSize * 52,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: listaMessaggi.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      _buildMessaggio(listaMessaggi[index]),
                      SizedBox(height: 10.0),
                    ],
                  ),
                );
              }
          ),
        )
    );
  }

}