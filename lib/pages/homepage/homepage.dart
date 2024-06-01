import 'package:flutter/material.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';
import 'package:gadc/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';

import '../../controllers/global_notifiers.dart';
import '../pages.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();

  static const String routeName = "/homescreen";
}

class _HomepageState extends State<Homepage> {
  int currentBottomIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void toggleNavBar() {
    isNavBarVisible.value = !isNavBarVisible.value;
  }

  Widget getPage() {
    switch (currentBottomIndex) {
      case 0:
        return ExplorePage(
          drawerKey: _scaffoldKey,
          toggleNavBar: toggleNavBar,
        );
      case 1:
        return SpacePage();
      case 2:
        return CreatePage();
      default:
        return ExplorePage(
          drawerKey: _scaffoldKey,
          toggleNavBar: toggleNavBar,
        );
    }
  }

  Widget getDrawer() {
    switch (currentBottomIndex) {
      case 0:
        return const CustomAppDrawer(
          pageName: 'EXPLORE',
        );
      case 1:
        return const CustomAppDrawer(
          pageName: '3D',
        );
      case 2:
        return const CustomAppDrawer(
          pageName: 'CREATE',
        );
      default:
        return const CustomAppDrawer(
          pageName: 'EXPLORE',
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
      drawer: getDrawer(),
      body: getPage(),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: isNavBarVisible,
        builder: (context, value, child) {
          return CustomBottomNavbar(
            onTap: bottomNavigator,
            selected: currentBottomIndex,
            isVisible: value,
          );
        },
      ),
    );
  }
}
