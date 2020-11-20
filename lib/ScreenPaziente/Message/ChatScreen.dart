import 'package:depression_screening_app/components/customInputBox.dart';
import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/Messaggio.dart';
import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';

class ChatScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}
class _ChatScreenState extends State<ChatScreen>{
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
    return await readListMessaggio();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
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
                MyCustomInputBox(
                  label: '.....',
                  inputHint: 'Messaggio',
                  controller: messaggioController,
                ),
                //
                SizedBox(
                  height: 15,
                ),
                RoundedButton(
                  text: "Invia messaggio",
                  press: (){
                    DateTime time = DateTime.now();
                    addMessaggioByPaziente(Messaggio(messaggioController.text.trim(), "1", time.toString()));
                    setState(() {
                      messaggiFuture = _getMessaggi();
                    });
                    messaggioController.clear();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMessaggio(Messaggio messaggio) {
    if(messaggio.isPaziente=="1"){
      return ChatBubble(
        clipper:  ChatBubbleClipper10(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text( messaggio.messaggio,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }else {
      return  ChatBubble(
        clipper: ChatBubbleClipper10(type: BubbleType.receiverBubble),
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            messaggio.messaggio,
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }
  Widget chatDisplay(context,snapshot) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: listaMessaggi.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      _buildMessaggio(listaMessaggi[index]),
                      SizedBox(height: 15.0),
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}
