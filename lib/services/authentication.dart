import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);


  Stream <User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> sigIn({String email, String password}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }
  Future<String> sigUp({String email, String password,Users user}) async{
    FirebaseApp app = await FirebaseApp.configure(
        name: 'Secondary', options: await FirebaseApp.instance.options);
    try{
      FirebaseAuth register = FirebaseAuth.fromApp(app);
      await register.createUserWithEmailAndPassword(email: email, password: password).then(
              (value) => writeNewUser(user,register.currentUser.uid)
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    await app.delete();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}