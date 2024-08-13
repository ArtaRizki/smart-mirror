import 'package:flutter/material.dart';

import '../helper/constant.dart';

class CustomLoadingIndicator {
  /// main circular indicator
  static Widget buildIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Constant.primaryColor,
      ),
    );
  }

  static Widget buildLinearIndicator() {
    return Center(
      child: LinearProgressIndicator(
        color: Constant.primaryColor,
      ),
    );
  }
}
