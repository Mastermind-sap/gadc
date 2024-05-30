import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selected;
  final Function onTap;
  final bool isVisible;

  const CustomBottomNavbar({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 60, // Adjust the height as needed
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
        child: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) => onTap(index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "Explore",
            ),
            NavigationDestination(
              icon: Icon(Icons.my_location),
              label: "Space",
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_location_alt),
              label: "Create",
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
