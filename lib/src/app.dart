import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yen/src/page/splash/splash_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff007EC4),
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YenDx',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff007EC4),
        splashColor: Color(0xff007EC4),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}
