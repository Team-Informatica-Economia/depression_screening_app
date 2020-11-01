import 'package:flutter/material.dart';

class Title_question extends StatelessWidget {
  final String testo;
  const Title_question({
    Key key,
    this.testo
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 180,
      width: MediaQuery.of(context).size.width*0.98,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF60BE93),
            Color(0xFF1B8D59),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        text: TextSpan(
            children: [
              TextSpan(
                  text: testo,
                  style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)
              ),
            ]
        ),
      ),
    );
  }
}
