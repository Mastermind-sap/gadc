import 'package:flutter/material.dart';

// for testing purposes
class SurroundingPage extends StatefulWidget {
  const SurroundingPage({
    super.key,
  });

  @override
  State<SurroundingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<SurroundingPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("HELLO "),
    );
  }
}
