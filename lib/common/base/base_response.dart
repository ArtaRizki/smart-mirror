import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

class BaseResponse {
  String message;
  int statusCode;
  bool success;
  dynamic map;
  BaseResponse(this.message, this.statusCode, this.success, this.map);

  static BaseResponse from(Response response) {
    dynamic data, error;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      log('BASE RESPONSE BODY : ${response.body}');
      error = e;
      log("BASE RESPONSE ERROR $e");
    }
    return BaseResponse(
      (data['Message'] != null)
          ? data['Message']
          : error?.toString() ?? 'Unknown Error!',
      data['StatusCode'],
      (data['Success'] != null) ? data['Success'] : false,
      data,
    );
  }
}
