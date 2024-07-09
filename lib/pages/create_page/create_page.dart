import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadc/functions/toast/show_toast.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  UnityWidgetController? _unityWidgetController;

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  // Callback to handle messages from Unity
  void onUnityMessageHandler(message) {
    // Display received data in a toast
    showToast(message);

    // Show bottom sheet to input latitude and longitude
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          LocationInputBottomSheet(), // Replace with your bottom sheet widget
    ).then((locationData) {
      if (locationData != null) {
        // Combine Unity data and location data
        Map<String, dynamic> dataToSave = {
          'unityData': message,
          'latitude': locationData['latitude'],
          'longitude': locationData['longitude'],
        };

        // Save data to Firestore
        FirebaseFirestore.instance
            .collection('your_collection')
            .add(dataToSave)
            .then((value) {
          showToast('Data saved to Firestore');
        }).catchError((error) {
          showToast('Failed to save data: $error');
        });
      }
    });
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
                    onUnityMessage: onUnityMessageHandler,
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

class LocationInputBottomSheet extends StatefulWidget {
  @override
  _LocationInputBottomSheetState createState() =>
      _LocationInputBottomSheetState();
}

class _LocationInputBottomSheetState extends State<LocationInputBottomSheet> {
  double? latitude;
  double? longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Latitude'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                latitude = double.tryParse(value);
              });
            },
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Longitude'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                longitude = double.tryParse(value);
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Validate inputs and return data
              if (latitude != null && longitude != null) {
                Navigator.of(context)
                    .pop({'latitude': latitude, 'longitude': longitude});
              } else {
                showToast('Please enter valid latitude and longitude');
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
