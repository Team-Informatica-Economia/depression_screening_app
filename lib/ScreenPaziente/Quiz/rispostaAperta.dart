import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:depression_screening_app/ScreenPaziente/Quiz/resultpage.dart';
import 'package:depression_screening_app/components/title_question.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:depression_screening_app/tflite/src/tensor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import '../../classesEmotions.dart';
import '../../utils.dart';
import '../../tflite/tflite.dart' as tfl;

class quizpageopen extends StatefulWidget {
  final bool microfono;
  final String risposta;
  final String numeroDomanda;

  quizpageopen({Key key, this.microfono, this.risposta, this.numeroDomanda})
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

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {

      try {
        await _prepare();
        await _initializeInterpreter();
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> _initializeInterpreter() async {
    String appDirectory = (await getApplicationDocumentsDirectory()).path;
    String srcPath = "assets/modelVoice.tflite";
    String destPath = "$appDirectory/model.tflite";

    /// Read the model as bytes and write it to a file in a location
    /// which can be accessed by TFLite native code.
    ByteData modelData = await rootBundle.load(srcPath);
    await File(destPath).writeAsBytes(modelData.buffer.asUint8List());

    /// Initialise the interpreter
    _interpreter = tfl.Interpreter.fromFile(destPath);
    _interpreter.allocateTensors();
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
      Int8List inputData = spectrogramToTensor(spectrogram);

      // The data is passed into the interpreter, which runs inference for loaded graph.
      List<Tensor> inputTensors = _interpreter.getInputTensors();

      print("prima " + inputTensors.length.toString());

      inputTensors[0].data = inputData;

      print("dopo" + inputTensors[0].data.toString());

      _interpreter.invoke();

      // Get results and parse them into relations of confidences to classes.
      List<Tensor> outputTensors = _interpreter.getOutputTensors();
      Float32List outputData = outputTensors[0].data.buffer.asFloat32List();
      List<Prediction> predictions =
          processPredictions(outputData, classesEmotions);

      print(predictions.toString());

      setState(() {
        _predictions = predictions;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
        flex: 3,
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
            backgroundColor: _isMicrophoneActive ? Colors.red : KColorIcon,
            elevation: 20,
            onPressed: () {
              _disabilitaNextDomanda();
              print("ciao" + _isMicrophoneActive.toString());

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
        child: RaisedButton(
          color: Color(0xffb8cae7),
          elevation: 4,
          child: Text(
            "Preferisco non rispondere",
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.black),
          ),
          onPressed: _isMicrophoneActive ? null : _cambiaPage,
        ),
      ),
      SizedBox(
        height: 10,
      )
    ]));
  }
}
