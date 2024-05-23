import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  const CustomAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String _displayedTitle;

  @override
  void initState() {
    // TODO: implement initState
    // init();
    super.initState();
    _displayedTitle = widget.title ?? "Aura-F";
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        _displayedTitle,
        style: const TextStyle(
          // color: Color(0xFF05354C),
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      backgroundColor: const Color.fromARGB(192, 1, 255, 56),
    );
  }
}
