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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isNavBarVisible = ValueNotifier<bool>(false);

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void toggleNavBar() {
    isNavBarVisible.value = !isNavBarVisible.value;
  }

  Widget getPage() {
    switch (currentBottomIndex) {
      case 0:
        return ExplorePage(
          drawer_key: openDrawer,
        );
      case 1:
        return SpacePage();
      case 2:
        return CreatePage();
      default:
        return ExplorePage(
          drawer_key: openDrawer,
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
      drawer: getDrawer(),
      body: getPage(),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: isNavBarVisible,
        builder: (context, value, child) {
          return CustomBottomNavbar(
            onTap: bottomNavigator,
            selected: currentBottomIndex,
            isVisible: false,
          );
        },
      ),
    );
  }
}
