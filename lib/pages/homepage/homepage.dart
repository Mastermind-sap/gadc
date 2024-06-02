import 'package:flutter/material.dart';
import 'package:gadc/functions/drawer/open_drawer.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';

import '../pages.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();

  static const String routeName = "/homescreen";
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomAppDrawer(
        pageName: 'EXPLORE',
      ),
      body: ExplorePage(drawerKey: () {
        openDrawer(_scaffoldKey);
      }),
    );
  }
}
