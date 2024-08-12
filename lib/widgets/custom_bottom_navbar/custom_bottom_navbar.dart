import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selected;
  final Function onTap;

  const CustomBottomNavbar({
    Key? key,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if the device is in landscape mode
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Visibility(
      visible: !isLandscape, // Hide the navbar in landscape mode
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 60, // Adjust the height as needed
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
        child: NavigationBar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          indicatorColor: Colors.red.withOpacity(0.1),
          selectedIndex: selected,
          onDestinationSelected: (index) => onTap(index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "Nearby",
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
