import 'package:depression_screening_app/services/Users.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  Future<String> sigUp({String email, String password,Users u}) async{
    print("entro in sigUP");
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then(
              (value) => {
              writeNewUser(u)
              });
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}