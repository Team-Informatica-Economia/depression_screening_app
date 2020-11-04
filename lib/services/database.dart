import 'package:depression_screening_app/Screens/Profile/components/bodyDatiPersonali.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:depression_screening_app/services/Users.dart';

var databaseReference = FirebaseDatabase.instance.reference();

Future<void> writeNewUser(String userId, Users users) {
  databaseReference.child("users").child(userId).push().set(users.toJson());
}

Future<Users> readUser(String userId) async{
  /*String result = (databaseReference.child("users").child(userId).once()).value;
  print(result);
  return result;*/
  DataSnapshot dataSnapshot = await databaseReference.child('users').child(userId).once();
  print(dataSnapshot.value.toString());

  /*Users u;
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      u = value;
    });
  }
  print("-----------------------------------------" + u.nome);
  return u;*/
}