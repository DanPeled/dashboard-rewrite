import 'dart:async';

import 'package:flutter/material.dart';
import 'package:elastic_dashboard/services/Record.dart';


class RecordingButton extends StatefulWidget {
  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRecording = false;
  List<Record> TopicRecord = [];
  Stopwatch stopwatch = Stopwatch();


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _animationController.repeat(reverse: true);
    });
    stopwatch.reset();
    stopwatch.start();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _animationController.stop();
      _animationController.reset();
    });
    stopwatch.stop();
  }

  void recordpridi (String Topic,String date){
    if (_isRecording){
      for (Record element in TopicRecord) {
         if (element.getTopic() == Topic){
            element.addTimeCode(TimeCode(sender: date, time: stopwatch.elapsed.inMicroseconds));
         }
      }
    }
    
  } 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ElevatedButton.icon(
            style: ButtonStyle(
              iconColor: WidgetStateProperty.all(
                _isRecording
                    ? ColorTween(
                        begin: Colors.red,
                        end: Colors.black,
                      ).animate(_animationController).value
                    : Colors.white,
              ),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            icon: _isRecording
                ? const Icon(Icons.circle)
                : const Icon(Icons.circle_outlined),
            onPressed: _isRecording ? _stopRecording : _startRecording,
            label: Text(_isRecording ? 'Recording' : 'Record'),
          );
        },
      ),
    );
  }
}
