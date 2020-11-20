import 'package:depression_screening_app/components/rounded_button.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/services/AppuntamentoObj.dart';
import 'package:depression_screening_app/services/database.dart';
import 'package:flutter/material.dart';


class Appuntamento extends StatefulWidget{
  final String emailPaziente;

  Appuntamento({Key key, this.emailPaziente}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppuntamentoState(emailPaziente);
  }
}
class _AppuntamentoState extends State<Appuntamento>{

  String emailPAziente;
  _AppuntamentoState(this.emailPAziente);

  DateTime giorno;
  TimeOfDay orario;
  @override
  void initState(){
    super.initState();
    giorno = DateTime.now();
    orario = TimeOfDay.now();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           SizedBox(height: 150),
           ListTile(
             title: Text("Giorno: ${giorno.day}/${giorno.month}/${giorno.year}"),
             trailing: Icon(Icons.keyboard_arrow_down),
             onTap: _pickGiorno,
           ),
           ListTile(
             title: Text("Orario: ${orario.hour}:${orario.minute}"),
             trailing: Icon(Icons.keyboard_arrow_down),
             onTap: _pickOrario,
           ),
           RoundedButton(
             text: "Crea appuntamento",
             press: (){
               String orarioString = "${orario.hour}:${orario.minute}";
               addAppuntamento(emailPAziente,AppuntamentoObj(giorno.day.toString(),monthsInYear[giorno.month],giorno.year.toString(),dayInWeek[giorno.weekday],orarioString));
             },
           )
         ],
       ),
     ),
   );
  }

  _pickGiorno() async{
   DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-2),
      lastDate: DateTime(DateTime.now().year+2),
      initialDate: giorno,
    );
   if(date!= null){
     setState(() {
       giorno = date;
     });
   }
  }
  _pickOrario() async{
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: orario,
    );
    if(t!= null){
      setState(() {
        orario = t;
      });
    }
  }
}