
import 'package:flutter/material.dart';
import 'package:weather_forcast_project/pages/Splash_Screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'NanumGothic',
            primarySwatch: Colors.blue,
            textTheme:
                const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
          ),
          home: const SplashScreen(),
        ));
  }
}
