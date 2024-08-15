import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:smart_mirror/common/helper/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_mirror/src/camera2/camera_page2.dart';
import 'utils/nav_observer.dart';
part 'common/routes.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await requestPermission(Permission.camera);
    await requestPermission(Permission.audio);
    await requestPermission(Permission.microphone);
    await requestPermission(Permission.videos);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialRoute;

    if (kDebugMode) {
      log("[Bearer Token]");
      log(prefs.getString(Constant.kSetPrefToken) ?? "");
      log("[/Bearer Token]");
    }

    if (prefs.getString(Constant.kSetPrefToken) == null) {
      //not signed in
      initialRoute = '/';
    } else {
      //signed in
      initialRoute = '/';
    }

    log("INITIAL ROUTE : $initialRoute");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constant.primaryColor,
      systemNavigationBarColor: Constant.primaryColor,
      systemNavigationBarDividerColor: Constant.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    runApp(const MyApp());
  }, (error, stack) {
    // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

Future<bool> requestPermission(Permission permission) async {
  PermissionStatus status = await permission.request();
  return [PermissionStatus.granted, PermissionStatus.limited].contains(status);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // checkLang(context);
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'HY TUTORIAL',
          restorationScopeId: 'root',
          // localizationsDelegates: context.localizationDelegates,
          // supportedLocales: context.supportedLocales,
          // locale: context.locale,
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
          // supportedLocales: const [Locale('id', 'ID'), Locale('en')],
          // locale: const Locale('id'),
          navigatorObservers: [XNObsever()],
          navigatorKey: NavigationService.navigatorKey,
          theme: Constant.mainThemeData,
          color: Constant.primaryColor,
          initialRoute: '/',
          routes: _routes,
          builder: (context, child) {
            child = EasyLoading.init()(
                context, child); // assuming this is returning a widget
            log(MediaQuery.of(context).size.toString());
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child,
            );
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
