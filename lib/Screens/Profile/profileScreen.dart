import 'package:depression_screening_app/Screens/Profile/components/body.dart';
import 'package:depression_screening_app/components/bottomBar.dart';
import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Body(),
      bottomNavigationBar: bottomBar(),
    );
  }

}