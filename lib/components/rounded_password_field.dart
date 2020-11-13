import 'package:flutter/material.dart';
import 'package:depression_screening_app/components/text_fiels_container.dart';
import 'package:depression_screening_app/constants.dart';
class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: TextField(
        controller: controller,
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: "Password",
            icon: Icon(
              Icons.lock,
              color: KPrimaryColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility),
              color: KPrimaryColor,
              onPressed: () {},
            ),
            border: InputBorder.none
        ),
      ),
    );
  }
}