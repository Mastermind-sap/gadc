import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gadc/functions/locate_me.dart';
import 'package:gadc/pages/test_page/test_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../config/assets.dart';

class ExplorePage extends StatefulWidget {
  final VoidCallback drawer_key;
  const ExplorePage({super.key, required this.drawer_key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  double my_lat = 0, my_long = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // void openDrawer() {
  //   widget.drawer_key.currentState!.openDrawer();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.85,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(24),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(24),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        child: FutureBuilder<Position>(
                          future: locateMe(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // later return here the previous stored map location
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return FlutterMap(
                              mapController: MapController(),
                              options: MapOptions(
                                cameraConstraint: CameraConstraint.contain(
                                  bounds: LatLngBounds(
                                    LatLng(-90,
                                        -180), // Southwest corner of the bounds
                                    LatLng(90,
                                        180), // Northeast corner of the bounds
                                  ),
                                ),
                                keepAlive:
                                    true, // so that it does not reset to initial position on changing pages
                                minZoom: 3.0,
                                maxZoom: 18.0,
                                enableScrollWheel:
                                    true, // Enable scroll wheel zoom
                                interactiveFlags: InteractiveFlag.pinchZoom |
                                    InteractiveFlag.drag |
                                    InteractiveFlag.doubleTapZoom |
                                    InteractiveFlag
                                        .flingAnimation, // Use specific flags
                                initialCenter: LatLng(snapshot.data!.latitude,
                                    snapshot.data!.longitude),
                                initialZoom: 15.0,
                                backgroundColor: Colors.black45,
                                onMapReady: () {},
                                onLongPress: (tapPosition, point) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TestingPage(l: point),
                                    ),
                                  );
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'dev.fleaflet.flutter_map.example',
                                  // errorImage: AssetImage(assetName), // set an image to load when map not load due to no network connection
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: const LatLng(24.7577, 92.7923),
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/pin.png"),
                                    ),
                                    Marker(
                                      point: LatLng(snapshot.data!.latitude,
                                          snapshot.data!.longitude),
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/pin.png"),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 36, 8, 36),
                        child: TextFormField(
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Search Aura',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            filled: true,
                            prefixIcon: GestureDetector(
                              onTap: () {
                                widget.drawer_key();
                              },
                              child: Icon(
                                Icons.notes,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            suffixIcon: Icon(
                              Icons.search_sharp,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text(
                    'EXPLORE',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
