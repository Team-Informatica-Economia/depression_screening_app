import 'package:depression_screening_app/ScreenPsicologo/Visualizza/Appuntamento.dart';
import 'package:depression_screening_app/services/Messaggio.dart';
import 'package:depression_screening_app/services/Questionario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:depression_screening_app/services/Users.dart';

import 'AppuntamentoObj.dart';

var databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> writeNewUser(Users users, String uidRegister) {
  final User user = auth.currentUser;
  final uid = user.uid;
  print("Utente loggato ${uid} Utente aggiunto ");
  databaseReference.child("users").child(uid).child("listaPazienti").child(uidRegister).set(users.toJson());
}

Future<void> updateUser(Users users) {
  final User user = auth.currentUser;
  final uid = user.uid;
  print("Utente loggato ${uid} Utente aggiornato ");
  databaseReference.child("users").child(users.uidPadre).child("listaPazienti").child(uid).update(users.toJsonCompleto());
}

Future<Users> readUser() async{
  final User user = auth.currentUser;
  final uid = user.uid;

  DataSnapshot dataSnapshot = await databaseReference.child("users").once();


  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {//psicologi
      value.forEach((key, valueFin) {//attributi
        if(key=="listaPazienti"){
          valueFin.forEach((key, valueSec){
            if(key==uid) {
                list.add(valueSec);
            }
          });
        }
      });
    });
  }
    return new Users.overloadedConstructor(list[0]['nome'], list[0]['cognome'], list[0]['email'], list[0]["statoCivile"], list[0]["sesso"], list[0]["scuola"], list[0]["regione"], list[0]["provincia"], list[0]["eta"], list[0]["uidPadre"]);
  }


Future<List<Users>> readListPazienti() async{
  final User user = auth.currentUser;
  final uid = user.uid;

  DataSnapshot dataSnapshot = await databaseReference.child('users').child(uid).child("listaPazienti").once();

  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      list.add(value);
    });
  }
  List<Users> listaPazienti = new List();
  for(int i = 0; i < list.length; i++) {
    listaPazienti.add(new Users(list[i]['nome'], list[i]['cognome'], list[i]['email'],  list[0]["uidPadre"]));
  }

  return listaPazienti;
}

Future<void> addPdfPaziente(Questionario questionario) async {
  final Users utenteLoggato = await readUser();
  final User user = auth.currentUser;
  final uid = user.uid;
  databaseReference.child("users").child(utenteLoggato.uidPadre).child("listaPazienti").child(uid).child("listaQuestionari").push().set(questionario.toJson());
}

Future<List<Questionario>> readListQuestionari(Users paziente) async{
  final User user = auth.currentUser;
  final uid = user.uid;
  DataSnapshot dataSnapshot = await databaseReference.child("users").child(uid).child("listaPazienti").once();

  Map<dynamic, dynamic> values = dataSnapshot.value;
  List list = new List();

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
        if(value["email"]==paziente.email){
          value.forEach((key, valueFin) {//attributi
            if(key=="listaQuestionari"){
              valueFin.forEach((key, value) {
                list.add(value);
              });
            }
          });
        }
    });
  }

  List<Questionario> listaQuestionari = new List();
  for(int i = 0; i < list.length; i++) {
    listaQuestionari.add(new Questionario(list[i]['titoloPdf'], list[i]['path']));
  }
  return listaQuestionari;
}

Future<void> addAppuntamento(String emailPaziente,AppuntamentoObj appuntamento) async {
  final User user = auth.currentUser;
  final uid = user.uid;
  DataSnapshot dataSnapshot = await databaseReference.child("users").child(uid).child("listaPazienti").once();
  Map<dynamic, dynamic> values = dataSnapshot.value;


  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      if(value["email"]==emailPaziente){
        databaseReference.child("users").child(uid).child("listaPazienti").child(key).child("appuntamento").set(appuntamento.toJson());
      }
    });
  }
}

Future<AppuntamentoObj> readAppuntamento( ) async{

  final Users utenteLoggato = await readUser();
  final User user = auth.currentUser;
  final uid = user.uid;
  AppuntamentoObj obj = AppuntamentoObj("", "", "", "", "");
  DataSnapshot dataSnapshot = await databaseReference.child("users").child(utenteLoggato.uidPadre).child("listaPazienti").child(uid).child("appuntamento").once();
  Map<dynamic, dynamic> values = dataSnapshot.value;
  if (dataSnapshot.value != null) {
    obj=  AppuntamentoObj(values["giorno"], values["mese"],values["anno"],values["giornoSettimana"],values["orario"]);

  }
  return(obj);
}
Future<void> addMessaggioByPaziente(Messaggio messaggio) async {

  final Users utenteLoggato = await readUser();
  final User user = auth.currentUser;
  final uid = user.uid;

  databaseReference.child("users").child(utenteLoggato.uidPadre).child("listaPazienti").child(uid).child("chat").push().set(messaggio.toJson());

}

Future<List<Messaggio>> readListMessaggio() async{
  final Users utenteLoggato = await readUser();
  final User user = auth.currentUser;
  final uid = user.uid;
  DataSnapshot dataSnapshot = await databaseReference.child("users").child(utenteLoggato.uidPadre).child("listaPazienti").child(uid).child("chat").once();

  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      list.add(value);
    });
  }
  List<Messaggio> listaMessaggi = new List();
  for(int i = 0; i < list.length; i++) {
    listaMessaggi.add(Messaggio(list[i]['messaggio'], list[i]['isPaziente'], list[i]['data']));
  }
  listaMessaggi.sort((a, b) => a.data.compareTo(b.data));
  print(listaMessaggi);
  return listaMessaggi;
}