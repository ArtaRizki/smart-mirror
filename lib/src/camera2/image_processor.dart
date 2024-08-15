import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as i;

Future<Uint8List?> readFileByte(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = File.fromUri(myUri);
  Uint8List? bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:$onError');
  });
  return bytes;
}

Future<ui.Image> processBytes(List<int> bytes) {
  Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(
    Uint8List.fromList(bytes),
    (result) => completer.complete(result),
  );
  return completer.future;
}

// 856,
// 539
const ktpSize = Size(600, 378);

Future<Uint8List> cropKTP(ui.Image image) async {
  final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  final recorder = ui.PictureRecorder();
  final drawStartCoordinate = Offset(
      (imageSize.width / 2) - (ktpSize.width / 2),
      (imageSize.height / 2) - (ktpSize.height / 2));
  final paint = Paint();
  final canvas = Canvas(recorder,
      ui.Rect.fromPoints(const Offset(0, 0), Offset(ktpSize.width, ktpSize.height)));

  canvas.drawImageRect(
      image,
      ui.Rect.fromPoints(
          drawStartCoordinate,
          Offset(drawStartCoordinate.dx + ktpSize.width,
              drawStartCoordinate.dy + ktpSize.height)),
      ui.Rect.fromPoints(const Offset(0, 0), Offset(ktpSize.width, ktpSize.height)),
      paint);

  final picture = recorder.endRecording();
  final img =
      await picture.toImage(ktpSize.width.toInt(), ktpSize.height.toInt());
  final byte = i.encodeJpg(i.Image.fromBytes(
      width: ktpSize.width.toInt(),
      height: ktpSize.height.toInt(),
      bytes: (await img.toByteData())!.buffer /*.asUint8List()*/));

  return Uint8List.fromList(byte);
}
