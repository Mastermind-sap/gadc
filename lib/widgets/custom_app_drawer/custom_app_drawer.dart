import 'package:flutter/material.dart';
import '../../config/assets.dart';

class CustomAppDrawer extends StatefulWidget {
  final List<Map<String, String>>? drawerItems;
  const CustomAppDrawer({super.key, this.drawerItems});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  late List<Map<String, String>> _drawerItems;

  @override
  void initState() {
    super.initState();
    _drawerItems = widget.drawerItems ??
        [
          {'title': 'Home', 'route': '/homescreen'},
          {'title': 'Profile', 'route': '/profile'},
          {'title': 'Settings', 'route': '/settings'},
          {'title': 'Help', 'route': '/help'},
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage(Assets.logo),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 10),
                Text(
                  'Aura',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ..._drawerItems.map((item) {
            return ListTile(
              title: Text(item['title']!),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  item['route']!,
                  (Route<dynamic> route) => false,
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
