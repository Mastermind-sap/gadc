import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: (Theme.of(context).brightness == Brightness.dark)
          ? const Color.fromARGB(255, 29, 36, 40)
          : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
