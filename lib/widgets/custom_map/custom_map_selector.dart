import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:latlong2/latlong.dart';
import 'package:gadc/functions/shared_pref/past_location.dart';
import 'package:image_picker/image_picker.dart';

class LocationSelectorMap extends StatefulWidget {
  final void Function(LatLng) onLocationSelected;
  final void Function(File?) onImageSelected; // New callback

  LocationSelectorMap(
      {required this.onLocationSelected, required this.onImageSelected});

  @override
  _LocationSelectorMapState createState() => _LocationSelectorMapState();
}

class _LocationSelectorMapState extends State<LocationSelectorMap> {
  late MapController _mapController;
  late LatLng _selectedLocation;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      List<String> position =
          await PastLocation().readMyLastLocation() ?? ['21', '78'];
      setState(() {
        _selectedLocation =
            LatLng(double.parse(position[0]), double.parse(position[1]));
      });
    } catch (e) {
      showToast('Error getting current location: $e');
    }
  }

  void _updateSelectedLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        widget.onImageSelected(_imageFile); // Call the callback
      } else {
        print('No image selected.');
        widget.onImageSelected(null); // Notify null if no image selected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    String tileLayerUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              "IMAGE",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
                border: Border.all(
                  color: Colors.white10,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_imageFile != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                      ),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 12,
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.camera);
                            },
                            child: Icon(Icons.camera_alt_rounded),
                          ),
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                            },
                            child: Icon(Icons.image),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              "LOCATION",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(24)),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: FlutterMap(
                      options: MapOptions(
                        cameraConstraint: CameraConstraint.contain(
                          bounds: LatLngBounds(
                            const LatLng(-90, -180),
                            const LatLng(90, 180),
                          ),
                        ),
                        keepAlive: true,
                        minZoom: 3.0,
                        maxZoom: 18.0,
                        enableScrollWheel: true,
                        interactiveFlags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.drag |
                            InteractiveFlag.doubleTapZoom |
                            InteractiveFlag.flingAnimation,
                        initialCenter: _selectedLocation,
                        initialZoom: 17.5,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: tileLayerUrl,
                          userAgentPackageName: 'com.example.app',
                        ),
                      ],
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onLocationSelected(_selectedLocation);
                          Navigator.of(context).pop();
                        },
                        child: Text('Select'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
