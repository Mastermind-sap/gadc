import 'package:flutter/material.dart';
import 'package:gadc/pages/create_page/create_page.dart';
import 'package:gadc/pages/profile_page/profile_page.dart';
import 'package:gadc/pages/space_page/space_page.dart';
import 'package:gadc/pages/nearby_page/nearby_page.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';
import 'package:gadc/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';

class NavigationPage extends StatefulWidget {
  final int initialIndex;

  const NavigationPage({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late int currentBottomIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    currentBottomIndex = widget.initialIndex;
  }

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
      case 3:
        return const ProfilePage();
      default:
        return const SurroundingPage();
    }
  }

  Widget getDrawer() {
    switch (currentBottomIndex) {
      case 0:
        return const CustomAppDrawer(
          pageName: 'Nearby',
        );
      case 1:
        return const CustomAppDrawer(
          pageName: '3D',
        );
      case 2:
        return const CustomAppDrawer(
          pageName: 'CREATE',
        );
      case 3:
        return const CustomAppDrawer(
          pageName: 'PROFILE',
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
      bottomNavigationBar: CustomBottomNavbar(
        onTap: bottomNavigator,
        selected: currentBottomIndex,
        isVisible: true,
      ),
      body: getPage(),
    );
  }
}
