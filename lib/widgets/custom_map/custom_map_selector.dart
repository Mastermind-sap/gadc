import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:latlong2/latlong.dart';
import 'package:gadc/functions/shared_pref/past_location.dart';
import 'package:image_picker/image_picker.dart';

class LocationSelectorMap extends StatefulWidget {
  final void Function(LatLng) onLocationSelected;
  final void Function(File?) onImageSelected; // Callback for image selection
  final void Function(String) onTextSubmitted; // Callback for text input

  const LocationSelectorMap(
      {super.key,
      required this.onLocationSelected,
      required this.onImageSelected,
      required this.onTextSubmitted});

  @override
  _LocationSelectorMapState createState() => _LocationSelectorMapState();
}

class _LocationSelectorMapState extends State<LocationSelectorMap>
    with TickerProviderStateMixin {
  late LatLng _selectedLocation;
  File? _imageFile;
  String _locationName = '';
  late final _animatedMapController = AnimatedMapController(vsync: this);
  ValueNotifier<LatLng> mapCenterValueNotifier =
      ValueNotifier<LatLng>(const LatLng(0, 0));

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        widget.onImageSelected(_imageFile); // Call the callback
      } else {
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
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "DETAILS",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: TextField(
              onChanged: (value) {
                _locationName = value;
              },
              decoration: const InputDecoration(
                labelText: '   Location Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.white10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
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
                        child: const CircleAvatar(
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
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                            },
                            child: const Icon(
                              Icons.image,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FlutterMap(
                        mapController: _animatedMapController.mapController,
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
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _selectedLocation,
                                child: const Icon(
                                  Icons.circle,
                                  color: Colors.blue,
                                  size: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
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
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onLocationSelected(_animatedMapController
                              .mapController.camera.center);
                          widget.onTextSubmitted(
                              _locationName); // Call the callback
                          Navigator.of(context).pop();
                        },
                        child: const Text('Select'),
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
