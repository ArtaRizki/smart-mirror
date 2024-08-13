import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../library/firebase_manager.dart';
import 'base_controller.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  //FirebaseManager firebaseManager = FirebaseManager();
  BaseController? baseC;
  StreamSubscription? firebaseSubs;

  reload({VoidCallback? f}) {
    setState(() {
      if (f != null) f.call();
    });
  }

  void pop() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    ///
  }

  setController<C extends BaseController>(C controller) {
    baseC = controller;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (baseC != null) baseC!.dispose();
    if (EasyLoading.isShow) loading(false);
    if (firebaseSubs != null) firebaseSubs!.cancel();
  }

  dynamic args() {
    return ModalRoute.of(context)?.settings.arguments;
  }

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) => this._isLoading = value;

  bool checkIsLoading() => EasyLoading.isShow;

  loading(bool show) {
    if (show) {
      isLoading = true;
      EasyLoading.show(dismissOnTap: false);
    } else {
      isLoading = false;
      EasyLoading.dismiss();
    }
  }

  bool _isProcessing = false;

  isBusy() => _isProcessing;

  Future<void> handleTap(Future<void> Function() onTap) async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      await onTap();
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
