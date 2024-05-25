import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  const CustomAppBar({super.key, this.title, this.subtitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String _displayedTitle;

  @override
  void initState() {
    super.initState();
    _displayedTitle = widget.title ?? "Aura-F";
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0x004B39EF),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            'Aura',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
              child: Text(
                widget.subtitle ?? "Explore",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [],
      centerTitle: false,
      elevation: 2,
    );
  }
}
