import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:gadc/pages/navigation_page/navigation_page.dart';
import 'package:gadc/widgets/custom_map/custom_map_selector.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  UnityWidgetController? _unityWidgetController;
  File? yourImageFile; // Variable to store selected image file
  String? name;

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;

    _unityWidgetController!.postMessage(
      'UnityMessageHandler', // The GameObject name in Unity
      'OnUnityMessage', // The method name in UnityMessageHandler
      'editor', // The message to send
    );
  }

  // Callback to handle messages from Unity
  void onUnityMessageHandler(message) {
    // Show bottom sheet to select location on map
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Enable to make the sheet full height
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: FractionallySizedBox(
          heightFactor: 0.9, // 90% of screen height
          child: LocationSelectorMap(
            onTextSubmitted: (String n) {
              name = n;
            },
            onLocationSelected: (LatLng location) async {
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null && yourImageFile != null) {
                try {
                  // Upload image to Firebase Storage
                  String imageUrl = await uploadImage(yourImageFile!);

                  // Combine Unity data, image URL, and location data
                  Map<String, dynamic> dataToSave = {
                    'unityData': message,
                    'latitude': location.latitude,
                    'longitude': location.longitude,
                    'name': name,
                    'imageUrl': imageUrl,
                    'uid': user.uid,
                    'timestamp': FieldValue.serverTimestamp(),
                  };

                  // Save data to Firestore
                  await saveDataToFirestore(dataToSave);

                  // Save data to shared preferences
                  await saveMarkerDataToPrefs({
                    'unityData': message,
                    'latitude': location.latitude,
                    'longitude': location.longitude,
                    'name': name,
                    'imageUrl': imageUrl,
                    'uid': user.uid,
                  });

                  showToast('Data saved to Firestore and local storage');

                  Navigator.pop(context); // Close bottom sheet
                  Navigator.of(context).push(
                    fromBottomRoute(const NavigationPage(
                      initialIndex: 1,
                    )),
                  );
                } catch (error) {
                  showToast('Failed to perform operation: $error');
                  print('Failed to perform operation: $error');
                }
              } else {
                showToast("Sign In first or select an image");
              }
            },
            onImageSelected: (File? imageFile) {
              // Handle image selection here
              setState(() {
                yourImageFile = imageFile!;
              });
            },
          ),
        ),
      ),
    );
  }

  // Function to upload image to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      return await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      throw error;
    }
  }

  // Function to save data to Firestore
  Future<void> saveDataToFirestore(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('your_collection').add(data);
    } catch (error) {
      throw error;
    }
  }

  // Function to save marker data to shared preferences
  Future<void> saveMarkerDataToPrefs(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> markers = prefs.getStringList('markers') ?? [];

    markers.add(jsonEncode(data));
    await prefs.setStringList('markers', markers);
  }

  // Function to retrieve marker data from shared preferences
  Future<List<Map<String, dynamic>>> getMarkerDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> markers = prefs.getStringList('markers') ?? [];

    return markers
        .map((marker) => jsonDecode(marker) as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMessageHandler,
            ),
          ],
        ),
      ),
    );
  }
}
