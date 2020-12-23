import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';


import 'package:flutter/services.dart';


class CameraProva extends StatefulWidget{
  final CameraDescription camera;
  const CameraProva({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return CameraProvaState();
  }
}
class CameraProvaState extends State<CameraProva>{
  bool _loading = true;
  File _image;
  List _output;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  XFile file;

  @override
  void initState(){
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    loadModel().then((value) {
      setState(() {});
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/espressioniFacciali.tflite", labels: 'assets/labels.txt');

    print("Ho caricato il modello!!!!!!!!");
  }

  classifyImage(String image) async {
    print("Ho letto l'immagine"+image);
    File file= new File(image);
    var output = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 7,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
    );

    setState(() {
      _output = output;
      _loading = false;
    });

    print("OUTPUT "+_output.toString());
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("happy"),
              ],
            ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            // Attempt to take a picture and log where it's been saved.
            print(path);
           file = await _controller.takePicture();
           print("Foto scattata "+file.path);

           await classifyImage(file.path);
            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(file: file),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}
class DisplayPictureScreen extends StatelessWidget {
  final XFile file;

  const DisplayPictureScreen({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(file.path)),
    );
  }
}