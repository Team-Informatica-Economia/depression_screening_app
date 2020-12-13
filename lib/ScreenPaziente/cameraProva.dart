import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
class CameraProva extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return CameraProvaState();
  }
}
class CameraProvaState extends State<CameraProva>{
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {

   return new MaterialApp(title: "mario",
    home: new Scaffold(
      body: new Center( child: _image == null ? new Text("No mario"):new Image.file(_image),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: getImage,tooltip: "pick mario",child: new Icon(Icons.camera),),
    ),
   );
  }
  
}
