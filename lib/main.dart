import 'package:flutter/material.dart';

import 'pages/pages.dart';

void main() {
  runApp(const GADC());
}

class GADC extends StatelessWidget {
  const GADC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GADC",
      darkTheme: ThemeData.dark(),
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        Homepage.routeName: (context) => const Homepage(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
