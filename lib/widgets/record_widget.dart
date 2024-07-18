import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:elastic_dashboard/services/Record.dart';

class RecordingButton extends StatefulWidget {
  void Function()? initState;
  void Function()? dispose;
  void Function()? startRecording;
  void Function()? stopRecording;
  Stopwatch stopwatch;

  RecordingButton(
      {required this.stopwatch,
      this.initState,
      this.dispose,
      this.startRecording,
      this.stopRecording});

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    widget.initState;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    widget.dispose;
  }

  void _startRecording() {
    setState(() {
      RecordingManger.isRecording = true;
      _animationController.repeat(reverse: true);
    });
    widget.stopwatch.reset();
    widget.stopwatch.start();
    widget.startRecording;
  }

  void _stopRecording() {
    setState(() {
      RecordingManger.isRecording = false;
      _animationController.stop();
      _animationController.reset();
    });
    widget.stopwatch.stop();
    widget.stopRecording?.call();
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
                RecordingManger.isRecording
                    ? ColorTween(
                        begin: Colors.red,
                        end: Colors.black,
                      ).animate(_animationController).value
                    : Colors.white,
              ),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            icon: RecordingManger.isRecording
                ? const Icon(Icons.circle)
                : const Icon(Icons.circle_outlined),
            onPressed:
                RecordingManger.isRecording ? _stopRecording : _startRecording,
            label: Text(RecordingManger.isRecording ? 'Recording' : 'Record'),
          );
        },
      ),
    );
  }
}

class RecordingManger extends StatelessWidget {
  static List<Record> TopicRecord = [];
  static Stopwatch stopwatch = Stopwatch();
  static bool _isRecording = false;

  static bool get isRecording {
    return _isRecording;
  }

  static void set isRecording(bool value) {
    _isRecording = value;
  }

  RecordingButton? recordingbutton;

  RecordingManger({super.key}) {
    recordingbutton = RecordingButton(
        stopwatch: stopwatch, stopRecording: this.stopRecording);
  }

  void stopRecording() {
    print(jsonEncode(TopicRecord));
    // print(TopicRecord.first.toJson());
    TopicRecord.clear();
  }

  static void recordPeriodically(String Topic, String data) {
    if (_isRecording) {
      if (TopicRecord.isEmpty) {
        TopicRecord.add(Record(Topic: Topic, timecode: []));
        TopicRecord.last.addTimeCode(
            TimeCode(sender: data, time: stopwatch.elapsed.inMicroseconds));
      }
      iterate(Topic, data);
    }
  }

  static void iterate(String topic, String data) {
    Record? rec =
        TopicRecord.firstWhereOrNull((element) => element.getTopic() == topic);

    if (rec == null) {
      TopicRecord.add(Record(Topic: topic, timecode: [
        TimeCode(sender: data, time: stopwatch.elapsed.inMilliseconds)
      ]));
    } else {
      rec.addTimeCode(
          TimeCode(sender: data, time: stopwatch.elapsed.inMilliseconds));
    }
  }

  @override
  Widget build(BuildContext context) {
    return recordingbutton!;
  }
}


class Play extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
      children: [
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.play_arrow_outlined),
        ),
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.play_arrow_outlined),
        ),
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.stop_circle_outlined),
        ),
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.pause_circle_outline),
        ),
      ],
    ));
  }
}

