import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:minima/app/backend/notify/notify.dart';
import 'package:minima/routers/loading.dart';
import 'package:minima/routers/login.dart';
import 'package:minima/routers/main.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:minima/shared/number_format.dart';
import 'package:workmanager/workmanager.dart';

final routes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => const LoginPage(),
  '/main': (BuildContext context) => const MainPage(),
  '/': (BuildContext context) => const LoadingPage()
};

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: '2ee4d13ab260eb610cf7ae9a2a3d57d3');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  Workmanager().initialize(callbackDispatcher); //, isInDebugMode: kDebugMode);
  Workmanager().registerPeriodicTask(
    "background_notification",
    "background notification",
    frequency: const Duration(minutes: 15),
  );
  await (await Notify.instance.init()).requestPermission();

  await initializeDateFormatting(locale);

  runApp(
    MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF54CF8A),
          unselectedWidgetColor: Colors.grey[400],
          accentColor: Colors.black12,
          splashColor: Colors.black12,
          splashFactory: InkSparkle.splashFactory,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0x10000000)),
                  splashFactory: InkSparkle.splashFactory)),
          fontFamily: 'SpoqaHanSansNeo',
          appBarTheme: const AppBarTheme(
            elevation: 0,
          )),
      routes: routes,
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) =>
      Notify.instance.onBackgroundUpdate().then((_) => Future.value(true)));
}
