import 'package:flutter/material.dart';

// for testing purposes
class TestingPage extends StatefulWidget {
  const TestingPage({
    super.key,
  });

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HELLO "),
      ),
    );
  }
}
