import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../questionarioPage.dart';

class MyCustomInputBoxSurname extends StatefulWidget {
  final String label;
  final String inputHint;

  MyCustomInputBoxSurname( {this.label, this.inputHint,});
  @override
  _MyCustomInputBoxSurnameState createState() => _MyCustomInputBoxSurnameState();
}

class _MyCustomInputBoxSurnameState extends State<MyCustomInputBoxSurname> {
  bool isSubmitted = false;
  TextEditingController textEditingController = TextEditingController();
  final checkBoxIcon = 'assets/icons/checkbox.svg';

  @override
  Widget build(BuildContext context) {

    bool isValid(String value) {
      final regex = RegExp("^[A-Za-z' ]{3,}\$");
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;

    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 15,
                color: Color(0xff8f9db5),
              ),
            ),
          ),
        ),
        //
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
          child: TextFormField(
            controller: textEditingController,
            onChanged: (value) {
              setState(() {
                if(isValid(value))
                  isSubmitted = true;
                else
                  isSubmitted=false;
              }

              );
            },



            style: TextStyle(
                fontSize: 19,
                color: Color(0xff0962ff),
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: widget.inputHint,
              hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[350],
                  fontWeight: FontWeight.w600),
              contentPadding:
              EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              focusColor: Color(0xff0962ff),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xff0962ff)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey[350],
                ),
              ),
              suffixIcon: isSubmitted == true
              // will turn the visibility of the 'checkbox' icon
              // ON or OFF based on the condition we set before
                  ? Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    checkBoxIcon,
                    height: 0.2,
                  ),
                ),
              )
                  : Visibility(
                visible: false,
                child: SvgPicture.asset(checkBoxIcon),
              ),
            ),



          ),
        ),
        //
      ],
    );
  }
}