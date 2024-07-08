import 'package:flutter/material.dart';
import 'package:gadc/pages/create_page/create_page.dart';
import 'package:gadc/pages/profile_page/profile_page.dart';
import 'package:gadc/pages/nearby_page/nearby_page.dart';
import 'package:gadc/widgets/custom_app_drawer/custom_app_drawer.dart';
import 'package:gadc/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';

class NavigationPage extends StatefulWidget {
  final int initialIndex;
  final double? latitude;
  final double? longitude;

  const NavigationPage({
    Key? key,
    this.initialIndex = 0,
    this.latitude,
    this.longitude,
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
        return SurroundingPage(
          latitude: widget.latitude,
          longitude: widget.longitude,
        );
      case 1:
        return CreatePage();
      case 2:
        return const ProfilePage();
      default:
        return SurroundingPage(
          latitude: widget.latitude,
          longitude: widget.longitude,
        );
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
          pageName: 'CREATE',
        );
      case 2:
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
