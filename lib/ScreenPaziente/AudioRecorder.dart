import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';


class Cronometro extends StatefulWidget {
  @override
  _Cronometro createState() => _Cronometro();
}
enum TimeFormat {
  second,
  centiSecond,
}
extension DoubleParsing on double {
  String timeFormat(TimeFormat format) {
    return sprintf("%02d", [
      format == TimeFormat.second ? this.toInt() : ((this % 1.0) * 100).toInt()
    ]);
  }
}

class _Cronometro extends State<Cronometro> {
  var _timerValueInSec = 0.0;
  TimeFormat _resetType;
  Timer _timer;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    if (_timer != null)
      _timer.cancel();
  }
  void _startTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _timerValueInSec += 0.01;
        });
      });
    } else {
      _timer.cancel();
      setState(() {
        _timer = null;
      });
    }
  }
  void _resetTimer() {
    setState(() {
      _timerValueInSec = _resetType == null ? 0 : _resetType == TimeFormat.second ? (_timerValueInSec % 1.0) : _timerValueInSec.floorToDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResetHint(),
          SizedBox(height: 12),
          _buildTimerCard(),
          SizedBox(height: 8),
          _buildActionsCard(),
        ],
      ),
    );
  }
  Widget _buildResetHint() {
    return Text(
      "Reset: ${_resetType == null ? "All" : _resetType == TimeFormat.second ? "Second" : "CentiSecond"}",
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black
      ),
    );
  }
  Widget _buildTimerCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTimer(),
        Text(
          ":",
          style: TextStyle(
              fontFamily: "NeuePixelSans",
              fontSize: 100,
              fontWeight: FontWeight.normal,
              color: Colors.black
          ),
        ),
        _buildTimer(format: TimeFormat.centiSecond),
      ],
    );
  }
  Widget _buildActionsCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAction(),
        _buildAction(isStart: false),
      ],
    );
  }
  Widget _buildAction({bool isStart = true}) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: isStart ? _startTimer : _resetTimer,
      child: Container(
        color: isStart ? Colors.green : Colors.orangeAccent,
        width: 140,
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Text(
          isStart ? (_timer == null ? "START" : "STOP") : "RESET",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
      ),
    );
  }
  Widget _buildTimer({TimeFormat format = TimeFormat.second}) {
    var _styleTimer = TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.normal,
        color: Colors.black
    );
    return Expanded(
      child: Row(
        mainAxisAlignment: format == TimeFormat.second ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Text(
                _timerValueInSec.timeFormat(format),
                style: _styleTimer,
              ),
            ),
            onPressed: () {
              setState(() {
                _resetType = _resetType  == format ? null : format;
              });
            },
          )
        ],
      ),
    );
  }
}