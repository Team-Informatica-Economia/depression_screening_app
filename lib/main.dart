import 'package:depression_screening_app/Screens/Login/login_screen.dart';
import 'package:depression_screening_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:depression_screening_app/Screens/Welcome/welcome_screen.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/authentication.dart';
import 'package:provider/provider.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
           create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AuthenticationService>().authStateChanges,
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: KPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: WelcomeScreen(),
        ),
    );
  }
}


