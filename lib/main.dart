import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gadc/functions/location/locate_me.dart';
import 'package:gadc/provider/SharedDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setStringList('markers', []);
  await askLocationPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SharedDataProvider()),
      ],
      child: const GADC(),
    ),
  );
}

class GADC extends StatefulWidget {
  const GADC({super.key});

  @override
  _GADCState createState() => _GADCState();
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
      // not completely removing the spash screen as later we can go beyound android
      initialRoute: Homepage.routeName,
    );
  }
}
