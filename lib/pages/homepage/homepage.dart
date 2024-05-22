import 'package:flutter/material.dart';
import 'package:gadc/widgets/custom_app_bar/custom_app_bar.dart';
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

  Widget getPage() {
    switch (currentBottomIndex) {
      case 0:
        return const ExplorePage();
      case 1:
        return const CreatePage();
      case 2:
        return const SpacePage();
      default:
        return const ExplorePage();
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
      appBar: CustomAppBar(),
      body: getPage(),
      bottomNavigationBar: CustomBottomNavbar(
        onTap: bottomNavigator,
        selected: currentBottomIndex,
      ),
    );
  }
}
