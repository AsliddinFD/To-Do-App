import 'package:flutter/material.dart';
import 'package:frontend/screens/register.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (fn) {
      runApp(
        const MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const Register(),
    );
  }
}
