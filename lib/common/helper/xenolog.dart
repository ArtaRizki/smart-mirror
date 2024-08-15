/*
  Version: 1.0.0
  Last Update: 21 Feb 2022
  
  class untuk mencatat log
  log disimpan per tanggal, maksimal penyimpanan hanya 2 hari
  pengiriman log hanya untuk 1 hari ini saja 
  log disimpan dengan urutan terbaru paling atas 
  
  cara pemakaian :
  cara 1 : sendLog ->
           langsung kirim setiap kali sendLog
           jika tidak terkirim, akan disimpan di local, dan terkirim ulang setiap kali sendLog dipanggil 
           (def 1 hari kebelakang)
           jika terkirim, akan hapus semua data log di local 
           contoh:
              XenoLog("admin").sendLog('Trial from Apps');
  cara 2 : save, sendAll, clearAll 
           save untuk simpan log ke local
           sendAll untuk kirim data log local, default 1 hari saja ->
           clearAll untuk hapus semua data log di local -> jika tidak ingin data local terhapus, jangan dipanggil
           contoh:
              XenoLog log = XenoLog("admin");
              log.save('Trial from Apps');
              log.sendAll().then((success) {
                if (success) {
                  log.clearAll();
                }
              });
  cara 3 : showLogDialog
           menampilkan log dialog, yg sudah lengkap dengan clear log, show log, dan send log
           contoh:
              XenoLog log = XenoLog("admin");
              log.save('Trial from Apps');
              log.showLogDialog(context);

  gunakan 3 cara ini secara terpisah
*/

// dio: ^3.0.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl: ^0.15.0
// import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences: ^0.5.7+3
// import 'package:get/get.dart' as g;
// import 'package:esys_flutter_share/esys_flutter_share.dart'; // esys_flutter_share: ^1.0.2
// import 'package:share/share.dart'; // share: ^0.6.5+
// import 'package:mailer/mailer.dart'; // mailer: ^3.3.0
// import 'package:mailer/smtp_server.dart'; // mailer: ^3.3.0 // share: 0.6.5+4
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'constant.dart';

enum XenoLogType {
  Database,
  Discord,
  // Email // belum bisa, dicoba dengan SMTP masih fail
}

class XenoLog {
  String projectName = ""; // bedakan untuk tiap project
  String version = "";
  String id = "0"; // id, nama user / device
  XenoLogType logType = XenoLogType.Database;
  String setDatabaseURL = "";
  String getDatabaseURL = "";
  String webHookURL = "";
  String emailAddress = "";

  String projectNameDef = "HY TUTORIAL";
  XenoLogType logTypeDef = XenoLogType.Database;
  // Endpoint Dev
  String setDatabaseURLDef = 'http://47.74.214.215:82/mg-log/log/ceklog?';
  // Contoh param : kode=KDE2 & log=tes2 & versi=3 & device=laptop & tgl_log=2022-05-15 & note=gapapa
  String getDatabaseURLDef = 'http://47.74.214.215:82/mg-log/log/cekgetlog?';
  // Contoh param : kode=KDE2 & tgl_awal=2022-05-12 & tgl_akhir=2022-05-31
  String webHookURLDef =
      'https://discord.com/api/webhooks/943699876951261204/drIDDI6zY81pR2EzqRl6wBU5G34cUe_TofqPasEGraGfSDrs5kVQ0MtBHQigBv39Ifuk';
  String emailAddressDef = 'mgelog@mgesolution.com';
  // Endpoint Live
  // belum ada

  String keySharedPreferences = 'MgeLog';
  final String _keyAlwaysLog = 'MgeAlwaysLog';
  final int _connectTimeOut = 30000; // timeout connect ke server
  final int _sendTimeout = 30000; // timeout send data ke server
  final int _receiveTimeOut = 30000; // timeout receive data dari server

  // Dio dio;
  // FormData formData;
  XenoLog(String id,
      {String projectName = "",
      String version = "",
      XenoLogType logType = XenoLogType.Database,
      String webHookURL = "",
      String emailAddress = ""}) {
    this.projectName = (projectName ?? "") != "" ? projectName : projectNameDef;
    this.version = version;
    this.id = id;
    this.logType = logType;
    setDatabaseURL = setDatabaseURL;
    getDatabaseURL = getDatabaseURL;
    this.webHookURL = webHookURL;
    this.emailAddress = emailAddress;

    // dio = Dio(BaseOptions(
    //     connectTimeout: _connectTimeOut,
    //     sendTimeout: _sendTimeout,
    //     receiveTimeout: _receiveTimeOut));
  }

  // kirim log langsung (unsendLog + log)
  // jika gagal, log + error tersimpan di local
  // jika berhasil, clear local
  void sendLog(String log) async {
    if (logType == XenoLogType.Database) {
      String unsendLog = await _getUnsendLog();
      String formattedLog = _formatLog(id.toString(), log);
      Map<String, dynamic> param = {
        "kode": projectName.toString().toUpperCase(),
        "device": id.toString(),
        "versi": version,
        "tgl_log": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "log": "tes123"
      }; // unsendLog + formattedLog};

      bool result = false;
      // _dioPost(setDatabaseURL, param).then((response) {
      //   if (response != null) {
      //     Map<String, dynamic> json = jsonDecode(response.toString());
      //     if (json['status'].toString() == 'true') {
      //       result = true;
      //     }
      //   }
      //   if (!result) {
      //     _saveUnsendLog(formattedLog);
      //     _saveUnsendLog(
      //         _formatLog(id.toString(), "Error send log : " + response));
      //   } else {
      //     _clearLog();
      //   }
      // });
    } else if (logType == XenoLogType.Discord) {
      String unsendLog = await _getUnsendLog();
      String title = "PROJECT LOG: ${projectName.toString().toUpperCase()} < $version >\r\n";
      String formattedLog = _formatLog(id.toString(), log);
      // _dioPost(webHookURL, {"content": title + unsendLog + formattedLog})
      //     .then((response) {
      //   if (response != "") {
      //     _saveUnsendLog(formattedLog);
      //     _saveUnsendLog(
      //         _formatLog(id.toString(), "Error send log : " + response));
      //   } else {
      //     _clearLog();
      //   }
      // });

      // } else if (this.logType == XenoLogType.Email) {
      //   String subject = "MGE Log " + projectName.toString();
      //   String body = "Sent by: " + id.toString() + "\r\n" +
      //                 "at [" + DateTime.now().toString() + "]" + "\r\n" +
      //                 log;
      //   _sendEmail(emailAddress, subject, body);
    }
  }

  // save + sendAll/shareAll + clearAll
  // <save> simpan log dulu, <sendAll> kirimkan log, <clearAll> clear local
  void save(String log, {bool alwaysLog = true}) async {
    bool doLog = true;
    if (!alwaysLog) {
      doLog = await _getAlwaysLog();
    }

    if (doLog) {
      //   if (this.logType == XenoLogType.Database) {
      String formattedLog = _formatLog(id.toString(), log);
      _saveUnsendLog(formattedLog, date: DateTime.now());
      //   } else if (this.logType == XenoLogType.Discord) {
      //     String formattedLog = _formatLog(id.toString(), log);
      //     _saveUnsendLog(formattedLog, date: DateTime.now());
      //     // } else if (this.logType == XenoLogType.Email) {
      //   }
    }
  }

  Future<bool> sendAll() async {
    if (logType == XenoLogType.Database) {
      String unsendLog = await _getUnsendLog();
      if ((unsendLog ?? "") == "") {
        unsendLog = _formatLog(id.toString(), 'No Data');
      }
      Map<String, dynamic> param = {
        "kode": projectName.toString().toUpperCase(),
        "device": id.toString(),
        "versi": version,
        "tgl_log": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "log": unsendLog
      };

      bool result = false;
      // _dioPost(setDatabaseURL, param).then((response) {
      //   if (response != null) {
      //     Map<String, dynamic> json = jsonDecode(response.toString());
      //     if (json['status'].toString() == 'true') {
      //       result = true;
      //     }
      //   }
      //   if (!result) {
      //     _saveUnsendLog(
      //         _formatLog(id.toString(), "Error send l0og : " + response));
      //   } else {
      //     _clearLog();
      //   }
      // });
    } else if (logType == XenoLogType.Discord) {
      String unsendLog = await _getUnsendLog();
      String title = "PROJECT LOG: ${projectName.toString().toUpperCase()} < $version >\r\n";
      if ((unsendLog ?? "") == "") {
        unsendLog = 'No Data';
      }

      // _dioPost(webHookURL, {"content": title + unsendLog}).then((response) {
      //   // print('Debug: ' + 'response = ' + response.toString());
      //   if (response != "") {
      //     _saveUnsendLog("Error send log : " + response);
      //     return false;
      //   } else {
      //     return true;
      //   }
      // });

      // } else if (this.logType == XenoLogType.Email) {
    }
    return true;
  }

  Future<bool> shareAll() async {
    String unsendLog = await _getUnsendLog(days: 2);
    String title = "< PROJECT LOG: ${projectName.toString().toUpperCase()} >\r\n";
    if ((unsendLog ?? "") == "") {
      unsendLog = 'No Data';
    }
    String fileName = await _writeToFile("$title\r\n$unsendLog");

    if (fileName != '') {
      // await Share.shareXFiles([XFile(fileName)]);
      // await Share.shareFiles([fileName]);
    } else {
      // await Share.share(title + "\r\n" + unsendLog);
    }
    return true;
  }

  void clearAll() async {
    if (logType == XenoLogType.Database) {
      _clearLog();
    } else if (logType == XenoLogType.Discord) {
      _clearLog();

      // } else if (this.logType == XenoLogType.Email) {
    }
  }

  // Future<String> _dioPost(String url, Map<String, dynamic> param) async {
  //   formData = FormData.fromMap(param);
  //   try {
  //     // print('Debug: ' + 'Post URL = ' + url );
  //     // print('Debug: ' + 'Param = ' + param.toString());
  //     Response response = await dio.post(url, data: formData);
  //     // print('Debug: ' + 'Response = ' + (response ?? "").toString());
  //     return (response ?? "").toString();
  //   } on DioError catch (error) {
  //     // print('Debug: ' + 'Error = ' + error.message.toString());
  //     return error.toString();
  //   }
  // }

  Future<String> _writeToFile(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/logfile.txt');
    await file.writeAsString(text);
    return '${directory.path}/logfile.txt';
  }

  void _sendEmail(String emailAddress, String subject, String body) async {
    // String username = 'username@gmail.com';
    // String password = 'password';

    // final smtpServer = gmail(username, password);

    // final message = Message()
    // ..from = Address(username, 'Your Name')
    // ..recipients.add('destination@example.com')
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    // ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    // try {
    //   final sendReport = await send(message, smtpServer);
    //   print('Message sent: ' + sendReport.toString());
    // } on MailerException catch (e) {
    //   print('Message not sent.');
    //   for (var p in e.problems) {
    //     print('Problem: ${p.code}: ${p.msg}');
    //   }
    // }
  }

  // save log ke local + clear log lama
  void _saveUnsendLog(String logg, {required DateTime date}) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // .subtract(Duration(days: 2))
    String dateKey = DateFormat("yyyy-MM-dd").format(date ?? DateTime.now());
    var data = prefs.getString("${keySharedPreferences}_$dateKey") ?? "";
    if (data != "") {
      data = "\r\n$data";
    }
    data = logg + data;
    prefs.setString("${keySharedPreferences}_$dateKey", data);
    String currData =
        prefs.getString("${keySharedPreferences}_$dateKey") ?? "";
    // log("SAVE LOG : $currData");

    // _clearOldLog();
  }

  // get semua log dari local sebanyak 'days' hari
  Future<String> _getUnsendLog({int days = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String data = prefs.getString("${keySharedPreferences}_$dateKey") ?? "";

    for (int i = 2; i <= days; i++) {
      dateKey = DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: i - 1)));
      String currData =
          prefs.getString("${keySharedPreferences}_$dateKey") ?? "";
      // log("CURR DATA : $currData");
      if (data != "" && currData != "") {
        data = "$data\r\n";
      }
      data = data + currData;
    }

    return data;
  }

  // hapus semua log
  void _clearLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Set<String> list = prefs.getKeys();
    for (var element in list) {
      if (element.toString().substring(0, keySharedPreferences.length) ==
          keySharedPreferences) {
        prefs.remove(element);
      }
    }
  }

  // hapus semua log , kecuali 'days' hari terakhir
  void _clearOldLog({int days = 2}) async {
    List<String> listDate = [];
    String dateKey;

    for (int i = 1; i <= days; i++) {
      dateKey = DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: i - 1)));
      listDate.add("${keySharedPreferences}_$dateKey");
      // print('Debug: ' + 'listDate = ' + keySharedPreferences + "_" + dateKey);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Set<String> list = prefs.getKeys();
    for (var element in list) {
      // log("ELEMENT LENGTH : ${element.length}");
      // log("KEYSHARED LENGTH : ${keySharedPreferences.length}");
      if (element.length >= keySharedPreferences.length &&
          element.toString().substring(0, keySharedPreferences.length) ==
              keySharedPreferences) {
        if (!listDate.contains(element.toString())) {
          prefs.remove(element);
          // print('Debug: ' + element.toString() + ' hapus');
        } else {
          // print('Debug: ' + element.toString() + ' tidak hapus');
        }
      }
    }
  }

  // format message sesuai format log
  String _formatLog(String id, String message) {
    if (logType == XenoLogType.Database) {
      return "Id: " +
          id.toString() +
          ' ' +
          DateFormat("[yyyy-MM-dd HH:mm:ss]").format(DateTime.now()) +
          ' ' +
          message;
    } else if (logType == XenoLogType.Discord) {
      return "Id: " +
          id.toString() +
          ' ' +
          DateFormat("[yyyy-MM-dd HH:mm:ss]").format(DateTime.now()) +
          "\r\n" +
          message;

      // } else if (this.logType == XenoLogType.Email) {
    } else {
      return '';
    }
  }

  Future<bool> _getAlwaysLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAlwaysLog) ?? false;
  }

  void _setAlwaysLog(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyAlwaysLog, value);
  }

  // menampilkan log dialog
  Future<dynamic> showLogDialog({@required context}) async {
    bool alwaysLog = await _getAlwaysLog();
    // print('Debug: ' + 'alwaysLog = ' + alwaysLog.toString());

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.all(24),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("Log File",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              buttonDialog(
                  context, "CLEAR", Colors.red, Colors.white, Colors.red, () {
                clearAll();
                Navigator.of(context).pop(true);
              }),
              buttonDialog(
                  context, "SHOW", Colors.green, Colors.white, Colors.green,
                  () {
                Navigator.of(context).pop(true);
                showLogContentDialog(context: context).then((value) {});
              }),
              buttonDialog(
                  context, "SHARE", Colors.green, Colors.green, Colors.blue,
                  () {
                shareAll();
                // sendAll();
                Navigator.of(context).pop(true);
              }),
              alwaysLog
                  ? buttonDialog(context, "ALWAYS LOG - ON", Colors.green,
                      Colors.white, Colors.green, () {
                      _setAlwaysLog(false);
                      Navigator.of(context).pop(true);
                    })
                  : buttonDialog(context, "ALWAYS LOG - OFF", Colors.red,
                      Colors.white, Colors.red, () {
                      _setAlwaysLog(true);
                      Navigator.of(context).pop(true);
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonDialog(BuildContext context, String caption, Color buttonColor,
      Color borderColor, Color textColor, Function() onClick) {
    return ElevatedButton(
      // minWidth: (MediaQuery.of(context).size.width / 2),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     side: BorderSide(color: buttonColor)),
      // color: borderColor,

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                side: BorderSide(color: Constant.primaryColor),
                borderRadius: BorderRadius.circular(16))),
        elevation: WidgetStateProperty.all<double>(0),
      ),
      onPressed: onClick,
      child: Text(caption, style: TextStyle(color: textColor, fontSize: 16)),
    );
  }

  // menampilkan + share isi log
  Future<dynamic> showLogContentDialog({@required context}) async {
    String unsendLog = await _getUnsendLog(days: 1);
    String title = "PROJECT LOG: ${projectName.toString().toUpperCase()}";
    if ((unsendLog ?? "") == "") {
      unsendLog = 'No Data';
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.all(12),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        title: const Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Text("Log File",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          // Align(
          //     alignment: Alignment.topRight,
          //     child: InkWell(
          //         onTap: () async {
          //           shareAll();
          //         },
          //         child: Icon(Icons.share))),
        ]),
        content: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title), const SizedBox(height: 8), Text(unsendLog)],
            ),
          ),
        ),
      ),
    );
  }
}
