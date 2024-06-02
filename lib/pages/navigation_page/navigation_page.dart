import 'package:flutter/material.dart';
import 'package:gadc/pages/create_page/create_page.dart';
import 'package:gadc/pages/space_page/space_page.dart';
import 'package:gadc/pages/surrounding_page/surrounding_page.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';
import 'package:gadc/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({
    super.key,
  });

  @override
  State<NavigationPage> createState() => _NavigationPage();
}

class _NavigationPage extends State<NavigationPage> {
  int currentBottomIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Widget getPage() {
    switch (currentBottomIndex) {
      case 0:
        return const SurroundingPage();
      case 1:
        return SpacePage();
      case 2:
        return CreatePage();
      default:
        return const SurroundingPage();
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
      drawer: getDrawer(),
      bottomNavigationBar: CustomBottomNavbar(
        onTap: bottomNavigator,
        selected: currentBottomIndex,
        isVisible: true,
      ),
      body: getPage(),
    );
  }
}
