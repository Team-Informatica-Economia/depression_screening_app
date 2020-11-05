import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:depression_screening_app/services/Users.dart';

var databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> writeNewUser(String userId, Users users) {
  databaseReference.child("users").child(userId).push().set(users.toJson());
}

Future<Users> readUser() async{
  final User user = auth.currentUser;
  final uid = user.uid;

  DataSnapshot dataSnapshot = await databaseReference.child('users').child(uid).once();

  List list = new List();
  Map<dynamic, dynamic> values = dataSnapshot.value;

  if (dataSnapshot.value != null) {
    values.forEach((key, value) {
      list.add(value);
    });
  }
  return new Users(list[0]['nome'], list[0]['cognome'], list[0]['email']);
  }