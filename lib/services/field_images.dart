import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldImages {
  static List<Field> fields = [];

  static Field? getFieldFromGame(String game) {
    if (fields.isEmpty) {
      return null;
    }

    return fields.firstWhere((element) => element.game == game);
  }

  static Future loadFields(String directory) async {
    List<String> filePaths = jsonDecode(
            await rootBundle.loadString('AssetManifest.json'))
        .keys
        .where((String key) => key.contains(directory) && key.contains('.json'))
        .toList();

    for (String file in filePaths) {
      await loadField(file);
    }
  }

  static Future loadField(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);

    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    fields.add(Field(jsonData: jsonData));
  }
}

class Field {
  final Map<String, dynamic> jsonData;

  late String? game;

  int? fieldImageWidth;
  int? fieldImageHeight;

  late double fieldWidthMeters;
  late double fieldHeightMeters;

  late Offset topLeftCorner;
  late Offset bottomRightCorner;

  late Offset fieldCenter;

  late Image fieldImage;

  late int pixelsPerMeterHorizontal;
  late int pixelsPerMeterVertical;

  Field({required this.jsonData}) {
    init();
  }

  void init() {
    fieldImage = Image.asset(jsonData['field-image']);
    fieldImage.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      fieldImageWidth = image.image.width;
      fieldImageHeight = image.image.height;
    }));

    // fieldImageWidth = 100;
    // fieldImageHeight = 100;

    game = jsonData['game'];

    fieldWidthMeters = jsonData['field-size'][0];
    fieldHeightMeters = jsonData['field-size'][1];

    topLeftCorner = Offset(
        (jsonData['field-corners']['top-left'][0] as int).toDouble(),
        (jsonData['field-corners']['top-left'][1] as int).toDouble());

    bottomRightCorner = Offset(
        (jsonData['field-corners']['bottom-right'][0] as int).toDouble(),
        (jsonData['field-corners']['bottom-right'][1] as int).toDouble());

    double fieldWidthPixels = bottomRightCorner.dx - topLeftCorner.dx;
    double fieldHeightPixels = bottomRightCorner.dy - topLeftCorner.dy;

    pixelsPerMeterHorizontal = (fieldWidthPixels / fieldWidthMeters).round();
    pixelsPerMeterVertical = (fieldHeightPixels / fieldHeightMeters).round();
  }
}