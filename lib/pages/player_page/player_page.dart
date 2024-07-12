import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class PlayerPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const PlayerPage({super.key, required this.data});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<PlayerPage> {
  UnityWidgetController? _unityWidgetController;

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;

    _unityWidgetController!.postMessage(
      'UnityMessageHandler', // The GameObject name in Unity
      'OnUnityMessage', // The method name in UnityMessageHandler
      widget.data['unityData'], // The message to send
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          UnityWidget(
            onUnityCreated: onUnityCreated,
          ),
        ],
      ),
    );
  }
}
