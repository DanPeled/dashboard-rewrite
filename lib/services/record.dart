import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

<<<<<<< HEAD
class Record {
  int time;
  String sender;
  String data;

  Record({
    required this.time,
    required this.sender,
    required this.data,
  });

  int getTime() {
    return time;
  }

  String getSender() {
    return sender;
  }

  String getData() {
    return data;
  }

  void setTime(int time) {
    this.time = time;
  }

  void setSender(String sender) {
    this.sender = sender;
  }

  void setData(String data) {
    this.data = data;
=======

class Record {
  List<TimeCode> timecode;
  String Topic;

  Record({
    required this.timecode,
    required this.Topic,
  });

  List<TimeCode> gettimecode() {
    return timecode;
  }

  String getTopic() {
    return Topic;
  }

  void addTimeCode(TimeCode dateAndtime) {
    timecode.add(dateAndtime);
  }

  void setTopic(String data) {
    this.Topic = data;
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
  }

  Map<String, dynamic> toJson() {
    return {
<<<<<<< HEAD
      'time': time,
      'sender': sender,
      'data': data,
    };
  }

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      time: json['time'],
      sender: json['sender'],
      data: json['data'],
=======
      'Topic': Topic,
      'timecode': timecode.map((tc) => tc.toJson()).toList(),
    };
  }

  factory Record.fromJson(Map<String, dynamic> json1) {
    List<dynamic> jsontimecode = json.decode(json1["timecode"]);
    return Record(
      Topic: json1['Topic'],
      timecode: jsontimecode.map((dateAndtime) => TimeCode.fromJson(dateAndtime)).toList(),
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
    );
  }

  Future<void> writeToFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$fileName');

    final jsonString = jsonEncode(toJson());
    await file.writeAsString(jsonString);
  }

  static Future<Record> readFromFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$fileName');

    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);
    return Record.fromJson(jsonMap);
  }

  static Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return '$path/$fileName';
  }
<<<<<<< HEAD
=======
}

class TimeCode {
  int time;
  String sender;

  TimeCode({
    required this.time,
    required this.sender,
  });

  int getTime() {
    return time;
  }

  String getSender() {
    return sender;
  }

  void setTime(int time) {
    this.time = time;
  }

  void setSender(String sender) {
    this.sender = sender;
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'sender': sender,
  };
  }

  factory TimeCode.fromJson(Map<String, dynamic> json) {
    return TimeCode(
      time: json['time'],
      sender: json['sender'],
    );
  }
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
}