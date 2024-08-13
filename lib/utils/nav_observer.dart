import 'package:flutter/cupertino.dart';

class XNObsever extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
    super.didPush(route, previousRoute);
    // FirebaseAnalytics.instance.logScreenView(screenName: route.settings.name);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // TODO: implement didPop
    super.didPop(route, previousRoute);
  }
}
