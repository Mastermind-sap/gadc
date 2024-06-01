import 'package:flutter/material.dart';
import 'package:gadc/functions/shared_pref/location.dart';
import 'package:gadc/services/location_service.dart';

import 'pages/pages.dart';

void main() {
  runApp(const GADC());
}

class GADC extends StatefulWidget {
  const GADC({super.key});

  @override
  State<GADC> createState() => _GADCState();
}

class _GADCState extends State<GADC> {
  @override
  void initState() {
    super.initState();
  }

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
