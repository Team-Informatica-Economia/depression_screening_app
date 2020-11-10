import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:depression_screening_app/services/Users.dart';

var databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> writeNewUser(Users users, String uidRegister) {
  final User user = auth.currentUser;
  final uid = user.uid;
  print("Utente loggato ${uid} Utente aggiunto ");
  databaseReference.child("users").child(uid).child("listaPazienti").child(uidRegister).push().set(users.toJson());
}

Future<void> updateUser(Users users) {
  final User user = auth.currentUser;
  final uid = user.uid;
  print("Utente loggato ${uid} Utente aggiornato ");
  databaseReference.child("users").child(users.uidPadre).child("listaPazienti").child(uid).update(users.toJson());
}

Future<Users> readUser() async{
  final User user = auth.currentUser;
  final uid = user.uid;

  DataSnapshot dataSnapshot = await databaseReference.child("users").once();


  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      print("primo for");
      value.forEach((key, valueFin) {
        print("secondo for");
        print(valueFin);
        valueFin.forEach((key, valueSec){
          print("terzo for");
          if(key==uid) {
            valueSec.forEach((key, valueTer){
              print("quarto for");
              list.add(valueTer);
              print(list);
            });
          }
        });
      });
    });
  }


  return new Users(list[0]['nome'], list[0]['cognome'], list[0]['email'], list[0]["uidPadre"]);
  }


Future<List<Users>> readListPazienti() async{
  final User user = auth.currentUser;
  final uid = user.uid;

  DataSnapshot dataSnapshot = await databaseReference.child('users').child(uid).child("listaPazienti").once();

  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      value.forEach((key, valueFin) {
        list.add(valueFin);
      });
    });
  }
  List<Users> listaPazienti = new List();
  for(int i = 0; i < list.length; i++) {
    listaPazienti.add(new Users(list[i]['nome'], list[i]['cognome'], list[i]['email'],  list[0]["uidPadre"]));
  }

  print(listaPazienti[0].toString());
  print(listaPazienti.toString());

  return listaPazienti;
}

