import 'package:depression_screening_app/ScreenPaziente/Questionario/validazione.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class MyCustomInputBox extends StatefulWidget {
  final String label;
  final String inputHint;
  final TextEditingController controller;


  MyCustomInputBox( {this.label, this.inputHint,
    @required this.controller});
  @override
  _MyCustomInputBoxState createState() => _MyCustomInputBoxState(this.label);
}

class _MyCustomInputBoxState extends State<MyCustomInputBox> {
  int isSubmitted = 0;

  final checkBoxIcon = 'assets/icons/checkbox.svg';
  final xIcon='assets/icons/red-x.svg';

  String label;
  _MyCustomInputBoxState(this.label);




  @override
  Widget build(BuildContext context) {
  Validazione validazione=new Validazione();


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
            controller: widget.controller,
            onChanged: (value) {
              setState(() {
                if(label=="Email" && validazione.isValidEmail(value))
                  isSubmitted = 1;
                else if(label=="Password" && validazione.isValidPassword(value))
                  isSubmitted = 1;
                else if((label=="Nome" || label=="Cognome") && validazione.isValid(value))
                  isSubmitted = 1;
                else
                  isSubmitted = 2;

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
              suffixIcon: isSubmitted == 0
              // will turn the visibility of the 'checkbox' icon
              // ON or OFF based on the condition we set before
                  ? Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    checkBoxIcon,
                    height: 0.2,
                  ),
                ),
              )
                  : isSubmitted == 1 ?
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    checkBoxIcon,
                    height: 0.2,
                  ),
                ),
              )
              :
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    xIcon,
                    height: 0.2,
                  ),
                ),
              ),

            ),

          ),
        ),
        //
      ],
    );
  }
}