import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadc/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';
import 'package:gadc/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';

import '../pages.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();

  static const String routeName = "/homescreen";
}

class _HomepageState extends State<Homepage> {
  int currentBottomIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavBarVisible = false;

  void openDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void toggleNavBar() {
    setState(() {
      isNavBarVisible = !isNavBarVisible;
    });
  }

  Widget getPage() {
    switch (currentBottomIndex) {
      case 0:
        return ExplorePage(
          drawer_key: openDrawer,
          nav_key: toggleNavBar,
        );
      case 1:
        return SpacePage();
      case 2:
        return CreatePage();
      default:
        return ExplorePage(
          drawer_key: openDrawer,
          nav_key: toggleNavBar,
        );
    }
  }

  PreferredSizeWidget getAppBar() {
    switch (currentBottomIndex) {
      case 0:
        return const CustomAppBar(
          subtitle: "Explore",
        );
      case 1:
        return const CustomAppBar(
          subtitle: "3D",
        );
      case 2:
        return const CustomAppBar(
          subtitle: "Create",
        );
      default:
        return const CustomAppBar(
          subtitle: "Explore",
        );
    }
  }

  void bottomNavigator(int index) {
    setState(() {
      currentBottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: getAppBar(),
      endDrawer: const CustomAppDrawer(),
      body: getPage(),
      bottomNavigationBar: CustomBottomNavbar(
        onTap: bottomNavigator,
        selected: currentBottomIndex,
        isVisible: isNavBarVisible,
      ),
    );
  }
}
