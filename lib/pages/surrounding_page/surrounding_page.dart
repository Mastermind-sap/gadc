import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadc/functions/toast/show_toast.dart';

class SurroundingPage extends StatefulWidget {
  const SurroundingPage({
    super.key,
  });

  @override
  State<SurroundingPage> createState() => _SurroundingPage();
}

class _SurroundingPage extends State<SurroundingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Surrounding Page"),
    );
  }
}
