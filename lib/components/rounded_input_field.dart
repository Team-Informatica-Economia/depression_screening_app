import 'package:flutter/material.dart';
import 'package:depression_screening_app/components/text_fiels_container.dart';
import 'package:depression_screening_app/constants.dart';
class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: KPrimaryColor,
            ),
            hintText: hintText,
            border: InputBorder.none
        ),
      ),
    );
  }
}