import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// for testing purposes
class TestingPage extends StatefulWidget {
  final LatLng l;
  const TestingPage({
    super.key,
    required this.l,
  });

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Latitude: ${widget.l.latitude} \nLongitude ${widget.l.longitude} "),
      ),
    );
  }
}
