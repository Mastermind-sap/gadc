import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:gadc/functions/location/calculateDistance.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:gadc/widgets/location_fetch_bottom_sheet/single_location_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';

class SharedDataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> nearByToCenterData = [];
  List<Marker> markers = [];

  void addData(Map<String, dynamic> data) async {
    allData.add(data);
    notifyListeners();
  }

  void fetchUserData(
    BuildContext context,
  ) async {
    try {
      allData = [];
      markers = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('your_collection')
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          allData.add(data);

          // add all markers
          markers.add(
            Marker(
              point: LatLng(data['latitude'], data['longitude']),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  _showBottomSheetWithFetchedData(context, data);
                },
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          );
        }
      }

      notifyListeners();
    } catch (error) {
      print("Error fetching user data: $error");
      showToast('Failed to fetch data: $error');
    }
  }

  void getNearbyData(LatLng center) async {
    nearByToCenterData = [];
    for (var data in allData) {
      double distance = calculateDistance(
          LatLng(data['latitude'], data['longitude']), center);
      if (distance <= 1000) {
        nearByToCenterData.add(data);
      }
    }
    notifyListeners();
  }
}

void _showBottomSheetWithFetchedData(
    BuildContext context, Map<String, dynamic> data) {
  UnityWidgetController? _unityWidgetController;
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child:
              singleLocationBottomSheet(context, data, _unityWidgetController));
    },
  );
}
