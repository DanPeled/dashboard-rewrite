import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  }

  Map<String, dynamic> toJson() {
    return {
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
}