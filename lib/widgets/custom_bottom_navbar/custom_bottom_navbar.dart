import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selected;
  final Function onTap;
  const CustomBottomNavbar(
      {super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color.fromARGB(255, 0, 45, 82),
        selectedItemColor: Colors.purple,
        backgroundColor: Color.fromARGB(192, 1, 255, 56),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: selected,
        onTap: (index) => onTap(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: "Space",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_location_alt),
            label: "Create",
          ),
        ]);
  }
}
