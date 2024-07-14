import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:gadc/functions/location/calculateDistance.dart';
import 'package:gadc/widgets/location_fetch_bottom_sheet/single_location_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomMap extends StatefulWidget {
  final double myLat;
  final double myLong;
  final double centerLat;
  final double centerLong;
  final MapController mapController;
  final Function updateMapCenter;
  final BuildContext context;
  final double zoom;

  final dynamic markers;

  const CustomMap({
    Key? key,
    required this.myLat,
    required this.myLong,
    required this.centerLat,
    required this.centerLong,
    required this.mapController,
    required this.updateMapCenter,
    required this.context,
    required this.zoom,
    required this.markers,
  }) : super(key: key);

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  ValueNotifier<double> _currentRotation = ValueNotifier(0.0);
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _startListening();
    _loadMarkers(); // Load markers initially
    // Set up periodic update every 30 seconds (adjust as needed)
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadMarkers();
    });
  }

  Future<void> _loadMarkers() async {
    List<Marker> markers = await getMarkers();
    setState(() {
      _markers = markers;
    });
  }

  // Function to retrieve marker data from shared preferences
  Future<List<Map<String, dynamic>>> getMarkerDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> markers = prefs.getStringList('markers') ?? [];

    return markers
        .map((marker) => jsonDecode(marker) as Map<String, dynamic>)
        .toList();
  }

  // Function to convert saved data to Marker objects
  Future<List<Marker>> getMarkers() async {
    List<Map<String, dynamic>> markerData = await getMarkerDataFromPrefs();

    return markerData.map((data) {
      return Marker(
        point: LatLng(data['latitude'], data['longitude']),
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
      );
    }).toList();
  }

  void _showBottomSheetWithFetchedData(
      BuildContext context, Map<String, dynamic> data) {
    UnityWidgetController? _unityWidgetController;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: singleLocationBottomSheet(
                context, data, _unityWidgetController));
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  void _startListening() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate rotation angle based on accelerometer data
      double angle = event.y * 10.0; // Adjust sensitivity as needed
      _currentRotation.value = angle;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    String tileLayerUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                const LatLng(-90, -180), // Southwest corner of the bounds
                const LatLng(90, 180), // Northeast corner of the bounds
              ),
            ),
            keepAlive:
                true, // so that it does not reset to initial position on changing pages
            minZoom: 3.0,
            maxZoom: 18.0,
            enableScrollWheel: true, // Enable scroll wheel zoom
            interactiveFlags: InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.flingAnimation, // Use specific flags
            initialCenter: LatLng(widget.myLat, widget.myLong),
            initialZoom: widget.zoom,
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            onMapReady: () {
              // Get the initial map center when the map is ready
              widget.updateMapCenter();
            },
            onPositionChanged: (MapPosition position, bool hasGesture) {
              // Update map center whenever the position changes
              widget.updateMapCenter();
            },
            onLongPress: (tapPosition, point) {
              // Handle long press
            },
          ),
          children: [
            TileLayer(
              urlTemplate: tileLayerUrl,
              subdomains: ['a', 'b', 'c'],
              retinaMode: true,
            ),
            MarkerLayer(markers: widget.markers),
            MarkerLayer(markers: _markers),
            MarkerLayer(
              markers: [
                // My Location
                Marker(
                  point: LatLng(widget.myLat, widget.myLong),
                  width: 20,
                  height: 20,
                  child: const Opacity(
                    opacity: 0.5,
                    child: Icon(
                      Icons.location_history,
                      // color: Colors.blueAccent,
                      size: 36,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (calculateDistance(LatLng(widget.myLat, widget.myLong),
                LatLng(widget.centerLat, widget.centerLong)) >
            10.0)
          const Center(
            child: Icon(
              Icons.circle,
              // color: Color.fromARGB(130, 255, 64, 128),
              size: 10,
            ),
          ),
      ],
    );
  }
}
