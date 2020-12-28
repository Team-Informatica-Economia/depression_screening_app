import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:depression_screening_app/tflite/src/tensor.dart';
import '../classesEmotionsFace.dart';
import '../tflite/tflite.dart' as tfl;
import 'package:image/image.dart' as img;




import 'package:flutter/services.dart';

import '../utils.dart';


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
  tfl.Interpreter _interpreter;


  @override
  void initState(){
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.low,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();


    Future.microtask(() async {
      try {
        await _initializeInterpreter();
      } catch (e) {
        print(e);
      }
    });
  }


  Future<void> _initializeInterpreter() async {
    String appDirectory = (await getApplicationDocumentsDirectory()).path;
    String srcPath = "assets/espressioniFacciali.tflite";
    String destPath = "$appDirectory/modelDue.tflite";

    /// Read the model as bytes and write it to a file in a location
    /// which can be accessed by TFLite native code.
    ByteData modelData = await rootBundle.load(srcPath);
    await File(destPath).writeAsBytes(modelData.buffer.asUint8List());

    /// Initialise the interpreter
    _interpreter = tfl.Interpreter.fromFile(destPath);
    _interpreter.allocateTensors();
  }

  img.Image grayscale(img.Image src) {
  var p = src.getBytes();
    for (var i = 0, len = p.length; i < len; i += 4) {
      var l = img.getLuminanceRgb(p[i], p[i + 1], p[i + 2]);
      p[i] = l;
      p[i + 1] = l;
      p[i + 2] = l;
    }
    return src;
  }

  Future<void> _performPrediction(File file) async {
    try {
      img.Image image = img.decodeImage(File(file.path).readAsBytesSync());

      image = grayscale(image);
      image = img.copyResize(image, width: 24, height: 24);

      List<num> x = image.getBytes();

      List<double> nuoviEl = new List<double>();

      for (int i = 0; i < x.length; i++){
        nuoviEl.add(x[i]/255);
      }

      print(nuoviEl.length);
      print(nuoviEl);

      Int8List inputData = spectrogramToTensor(nuoviEl);

      // The data is passed into the interpreter, which runs inference for loaded graph.
      List<Tensor> inputTensors = _interpreter.getInputTensors();
      inputTensors[0].data = inputData;
      _interpreter.invoke();

      List<Tensor> outputTensors = _interpreter.getOutputTensors();
      Float32List outputData = outputTensors[0].data.buffer.asFloat32List();
      List<Prediction> predictions =
      processPredictions(outputData, classesEmotionsFace);

      predictions.forEach((element) {
        print("Classname: " + element.className);
        print((element.confidence * 100).toStringAsFixed(2) + "%");

      });

      // Retrieves the tensor data for the last recording.
      /*List<num> signalData = await getSignalFromFile(_recording?.path ?? '');
      List<double> spectrogram = signalToSpectrogram(signalData);
      print(spectrogram.length);
      Int8List inputData = spectrogramToTensor(spectrogram);

      // The data is passed into the interpreter, which runs inference for loaded graph.
      List<Tensor> inputTensors = _interpreter.getInputTensors();
      inputTensors[0].data = inputData;
      _interpreter.invoke();

      // Get results and parse them into relations of confidences to classes.
      List<Tensor> outputTensors = _interpreter.getOutputTensors();
      Float32List outputData = outputTensors[0].data.buffer.asFloat32List();
      List<Prediction> predictions =
      processPredictions(outputData, classesEmotions);

      predictions.forEach((element) {
        print("Classname: " + element.className);
        print((element.confidence * 100).toStringAsFixed(2) + "%");

      });
*/

    } catch (e) {
      print(e);
    }
  }


  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    Tflite.close();
    _interpreter.delete();
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

           //await classifyImage(file.path);
            await _performPrediction(File(file.path));
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