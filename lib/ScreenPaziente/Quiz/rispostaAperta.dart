import 'dart:async';
import 'dart:math';

import 'package:depression_screening_app/ScreenPaziente/Quiz/resultpage.dart';
import 'package:depression_screening_app/components/title_question.dart';
import 'package:depression_screening_app/constants.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';


class quizpageopen extends StatefulWidget {
  final bool microfono;
  final String risposta;
  quizpageopen({Key key, this.microfono, this.risposta}): super(key: key);

  @override
  _quizpageopen createState() => _quizpageopen(microfono, risposta);
}

class _quizpageopen extends State<quizpageopen>{
  var microfono, risposta;
  _quizpageopen(this.microfono, this.risposta);
  bool _isMicrophoneActive = false;

  FlutterAudioRecorder _recorder;
  Recording _recording;
  String _alert;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  Future _init() async {
    String customPath = '/risposta';
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
    print("Recording status "+_recording.status.toString());
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


  void _disabilitaNextDomanda(){
    setState(()  {
      if(_isMicrophoneActive == false) {
        _isMicrophoneActive = true;
        _recording.status=RecordingStatus.Initialized;
        _opt();
      }
      else{
        _recording.status=RecordingStatus.Recording;
        _opt();
        _cambiaPage();
      }

    });
  }


  void _cambiaPage(){
    setState(() {
      if (microfono) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => resultpage()));
      } else {
        Navigator.pop(context);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Title_question(testo: "Cosa significa per te: \n"+"\""+risposta+"\"?"),
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
                child: _isMicrophoneActive ? Icon(Icons.stop, size: 110,) : Icon(Icons.mic, size: 110,),
                backgroundColor: _isMicrophoneActive ? Colors.red : KColorIcon,
                elevation: 20,
                onPressed: (){

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
              color: Color( 0xffb8cae7),

              elevation: 4,
              child: Text("Preferisco non rispondere", style: Theme.of(context).textTheme.title.copyWith(color: Colors.black),),
              onPressed: _isMicrophoneActive ? null : _cambiaPage,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]
      )
    );

  }


}




