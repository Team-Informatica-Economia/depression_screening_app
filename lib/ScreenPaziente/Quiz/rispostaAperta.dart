import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:depression_screening_app/ScreenPaziente/Quiz/resultpage.dart';
import 'package:depression_screening_app/components/title_question.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/tflite/src/tensor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;


import '../../classesEmotions.dart';
import '../../classesEmotionsFace.dart';
import '../../utils.dart';
import '../../tflite/tflite.dart' as tfl;
import 'package:image/image.dart' as img;

import 'package:mfcc/mfcc.dart';
import 'package:t_stats/t_stats.dart';

class quizpageopen extends StatefulWidget {
  final bool microfono;
  final String risposta;
  final String numeroDomanda;
  final CameraDescription camera;

  quizpageopen({Key key, this.microfono, this.risposta, this.numeroDomanda, this.camera})
      : super(key: key);

  @override
  _quizpageopen createState() =>
      _quizpageopen(microfono, risposta, numeroDomanda);
}

class _quizpageopen extends State<quizpageopen> {
  var microfono, risposta, numeroDomanda;

  _quizpageopen(this.microfono, this.risposta, this.numeroDomanda);

  bool _isMicrophoneActive = false;

  tfl.Interpreter _interpreter;
  List<Prediction> _predictions = [];

  FlutterAudioRecorder _recorder;
  Recording _recording;
  String _alert;
  String customPath;

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _textRiconosciuto = '';
  double _confidence = 1.0;

  CameraController _controller;
  Future<void> _initializeControllerFuture;
  XFile file;
  tfl.Interpreter _interpreterFace;

  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();

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
        await _prepare();
        await _initializeInterpreter();
        await _initializeInterpreterFace();
      } catch (e) {
        print(e);
      }
    });


  }

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  static void saveKV(String numeroDomanda, List<Prediction> predictions) async {

    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();

    predictions.forEach((element) {
      sharedPreferences.setString("voce" + element.className + numeroDomanda, (element.confidence * 100).toStringAsFixed(2) + "%");
    });
  }

  static void saveKVFace(String numeroDomanda, List<Prediction> predictions) async {
    double somma = 0;
    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();

    predictions.forEach((element) {
      //print("---------------------------------------------------------------" + element.className + " " + (element.confidence * 100).toStringAsFixed(2) + "%");
      sharedPreferences.setString("face" + element.className + numeroDomanda, (element.confidence * 100).toStringAsFixed(2) + "%");

      if(element.className == "angry" || element.className == "disgust" || element.className == "fear" || element.className == "sad")
        somma+=element.confidence;
    });

    sharedPreferences.setDouble("face"  + numeroDomanda, somma);


    print("Somma è "+somma.toString());

  }

  static void saveKVPrefNonRispondere(String numeroDomanda) async {

    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();

    sharedPreferences.setString("voceangry" + numeroDomanda, "Preferisco non rispondere");
    sharedPreferences.setString("voceneutral" + numeroDomanda, "Preferisco non rispondere");
    sharedPreferences.setString("vocefear" + numeroDomanda, "Preferisco non rispondere");
    sharedPreferences.setString("vocesurprise" + numeroDomanda, "Preferisco non rispondere");
    sharedPreferences.setString("vocesad" + numeroDomanda, "Preferisco non rispondere");
    sharedPreferences.setString("vocedisgust" + numeroDomanda, "Preferisco non rispondere");
    sharedPreferences.setString("vocehappy" + numeroDomanda, "Preferisco non rispondere");

  }

  void _listen() async {
    print("sono in listen");
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
          onResult: (val) => setState(() {
            _textRiconosciuto = val.recognizedWords;
            print("-----------------------------------------Testo riconosciuto: " + _textRiconosciuto);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
    }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _initializeInterpreterFace() async {
    String appDirectory = (await getApplicationDocumentsDirectory()).path;
    String srcPath = "assets/espressioniFacciali.tflite";
    String destPath = "$appDirectory/modelDue.tflite";

    /// Read the model as bytes and write it to a file in a location
    /// which can be accessed by TFLite native code.
    ByteData modelData = await rootBundle.load(srcPath);
    await File(destPath).writeAsBytes(modelData.buffer.asUint8List());

    /// Initialise the interpreter
    _interpreterFace = tfl.Interpreter.fromFile(destPath);
    _interpreterFace.allocateTensors();
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

  Future<void> _performPredictionFace(File file) async {
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
      List<Tensor> inputTensors = _interpreterFace.getInputTensors();
      inputTensors[0].data = inputData;
      _interpreterFace.invoke();

      List<Tensor> outputTensors = _interpreterFace.getOutputTensors();
      Float32List outputData = outputTensors[0].data.buffer.asFloat32List();
      List<Prediction> predictions =
      processPredictions(outputData, classesEmotionsFace);

      predictions.forEach((element) {
        print("Classname: " + element.className);
        print((element.confidence * 100).toStringAsFixed(2) + "%");

      });

      await saveKVFace(numeroDomanda, predictions);

    } catch (e) {
      print(e);
    }
  }

  Future<void> _initializeInterpreter() async {
    String appDirectory = (await getApplicationDocumentsDirectory()).path;
    String srcPath = "assets/tonoVoce.tflite";
    String destPath = "$appDirectory/model.tflite";

    /// Read the model as bytes and write it to a file in a location
    /// which can be accessed by TFLite native code.
    ByteData modelData = await rootBundle.load(srcPath);
    await File(destPath).writeAsBytes(modelData.buffer.asUint8List());

    /// Initialise the interpreter
    _interpreter = tfl.Interpreter.fromFile(destPath);
    _interpreter.allocateTensors();
  }


  @override
  void dispose() {
    // Friendly deletion of interpreter instance
    // and shutting down of audio player.
    _interpreter.delete();
    super.dispose();
  }

  Future _init() async {
    customPath = '/risposta';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }
// can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();
// .wav <---> AudioFormat.WAV
// .mp4 .m4a .aac <---> AudioFormat.AAC
// AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  void _opt() async {
    print("Recording status " + _recording.status.toString());
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        //_buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();

    setState(() {
      _recording = result;
    });
  }

  Future<void> _performPrediction() async {
    try {
      // Retrieves the tensor data for the last recording.
      List<num> signalData = await getSignalFromFile(_recording?.path ?? '');
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

      await saveKV(numeroDomanda, predictions);

    } catch (e) {
      print(e);
    }
  }

  void _disabilitaNextDomanda() async {

    if (_isMicrophoneActive == false) {
      _recording.status = RecordingStatus.Initialized;
      await _opt();
      _predictions.clear();
    } else {
      _recording.status = RecordingStatus.Recording;
      await _opt();

      //predict
      await _performPrediction();

      File file = File(customPath + ".wav");

      file.deleteSync();
      print("cancello audio " + numeroDomanda);

    }

    setState(() {
      if (_isMicrophoneActive == false) {
        _isMicrophoneActive = true;
      } else {
        _cambiaPage();
      }
    });
  }

  void _cambiaPage() {
    setState(() {
      if (microfono) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => resultpage()));
      } else {
        Navigator.pop(context);
        print("Visualizzo domanda");
      }
    });
  }

  void _cambiaPagePrefNonRispondere() async{
    await saveKVPrefNonRispondere(numeroDomanda);

    setState(() {
      if (microfono) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => resultpage()));
      } else {
        Navigator.pop(context);
        print("Visualizzo domanda");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
        flex: 5,
        child: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Title_question(
                  testo: "Cosa significa per te: \n" + "\"" + risposta + "\"?"),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 6,
        child: SizedBox(
          width: 200,
          height: 200,
          child: FloatingActionButton(
            child: _isMicrophoneActive
                ? Icon(
                    Icons.stop,
                    size: 110,
                  )
                : Icon(
                    Icons.mic,
                    size: 110,
                  ),
            backgroundColor: _isMicrophoneActive ? Colors.redAccent : KColorIcon,
            elevation: 20,
            onPressed: () async {
              //per lo speech to text
              //_listen();

              try {
                await _initializeControllerFuture;

                file = await _controller.takePicture();
                print("Foto scattata "+file.path);

                await _performPredictionFace(File(file.path));
              } catch (e) {
                print(e);
              }

              _disabilitaNextDomanda();
              //print("ciao" + _isMicrophoneActive.toString());

              /*if(microfono){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => resultpage()));
                } else {
                  Navigator.pop(context);
                }*/
            },
          ),
        ),
      ),
       Expanded(
        flex: 1,
          child:
          Text(
           "Puoi decidere di non giustificare la risposta dicendo:",
           style: TextStyle(
             fontFamily: 'Montserrat',
             color: Colors.black45,
             fontWeight: FontWeight.normal,
             fontSize: 18,
           ),
            textAlign: TextAlign.center,
         ),

      ),
          Expanded(
            flex: 1,
            child:
            Text(
              "Preferisco non rispondere",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),

          ),
      SizedBox(
        height: 10,
      )
    ]));
  }
}
