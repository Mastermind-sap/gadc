import 'package:flutter/material.dart';
import 'package:gadc/pages/create_page/create_page.dart';
import 'package:gadc/pages/explore_page/explore_page.dart';
import 'package:gadc/pages/space_page/space_page.dart';
import 'package:gadc/pages/testing_page/testing_page.dart';
import 'package:gadc/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';
import 'package:gadc/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';

// for testing purposes
class NavigationPage extends StatefulWidget {
  const NavigationPage({
    super.key,
  });

  @override
  State<NavigationPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<NavigationPage> {
  int currentBottomIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Widget getPage() {
    switch (currentBottomIndex) {
      case 0:
        return TestingPage();
      case 1:
        return SpacePage();
      case 2:
        return CreatePage();
      default:
        return TestingPage();
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
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: CustomBottomNavbar(
        onTap: bottomNavigator,
        selected: currentBottomIndex,
        isVisible: true,
      ),
      body: getPage(),
    );
  }
}
