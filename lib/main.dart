import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/init/theme/dark_app_theme.dart';
import 'view/base/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR & Barcode Scanner',
      theme: DarkTheme.instance.theme,
      home: SplashView(),
    );
  }
}
