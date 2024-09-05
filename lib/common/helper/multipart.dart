import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';
import 'package:async/async.dart';

Future<http.MultipartFile> getMultipart(String field, File image) async {
  var imageFile = image;
  // ignore: deprecated_member_use
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await image.length();

  var multipartFile = http.MultipartFile(
    field,
    stream,
    length,
    filename: basename(imageFile.path),
  );
  return multipartFile;
}
