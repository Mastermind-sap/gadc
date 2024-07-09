import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast package
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class CreatePage extends StatelessWidget {
  CreatePage({Key? key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  // Callback to handle messages from Unity
  void onUnityMessageHandler(message) {
    // Display received data in a toast
    Fluttertoast.showToast(
      msg: "Received data from Unity: $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Align(
              alignment: AlignmentDirectional(0, -1),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: UnityWidget(
                    onUnityCreated: onUnityCreated,
                    onUnityMessage:
                        onUnityMessageHandler, // Pass the handler function here
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
