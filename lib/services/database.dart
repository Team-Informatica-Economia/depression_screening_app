import 'package:firebase_database/firebase_database.dart';
import 'package:depression_screening_app/services/Users.dart';

var databaseReference = FirebaseDatabase.instance.reference();

Future<void> writeNewUser(String userId, Users users) {
  databaseReference.child("users").child(userId).push().set(users.toJson());
}

Future<void> readUser(String userId) async{
  /*String result = (databaseReference.child("users").child(userId).once()).value;
  print(result);
  return result;*/
  DataSnapshot dataSnapshot = await databaseReference.child('users').child(userId).once();
  //print(dataSnapshot.value.toString());

  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      list.add(value);
    });
  }
  Users utenteLoggato = new Users(list[0]['nome'], list[0]['cognome'], list[0]['email']);
  print("-----------------------------------------" + utenteLoggato.toString());
}