import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minima/routers/loading.dart';
import 'package:minima/routers/login.dart';
import 'package:minima/routers/main.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

final routes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => const LoginPage(),
  '/main': (BuildContext context) => const MainPage(),
  '/': (BuildContext context) => const LoadingPage()
};

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: '2ee4d13ab260eb610cf7ae9a2a3d57d3');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF54CF8A),
        accentColor: Colors.black12,
        splashColor: Colors.black12,
        splashFactory: InkSparkle.splashFactory,
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0x10000000)),
                splashFactory: InkSparkle.splashFactory)),
        fontFamily: 'SpoqaHanSansNeo',
      ),
      routes: routes,
    ),
  );
}
