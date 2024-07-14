import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/functions/location/calculateDistance.dart';
import 'package:gadc/functions/shared_pref/past_location.dart';
import 'package:gadc/pages/navigation_page/navigation_page.dart';
import 'package:gadc/provider/SharedDataProvider.dart';
import 'package:gadc/widgets/custom_map/custom_map.dart';
import 'package:gadc/widgets/location_fetch_bottom_sheet/multiple_fetch_bottom_sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();

  static const String routeName = "/mappage";
}

class MapPageState extends State<MapPage> with TickerProviderStateMixin {
  double currLat = 21, currLong = 78; // default location coordinates of India
  bool firstTimeStart =
      true; // to set zoom and animation for 1st time initialization of the map
  late final _animatedMapController = AnimatedMapController(vsync: this);
  ValueNotifier<LatLng> _mapCenterNotifier =
      ValueNotifier<LatLng>(const LatLng(21, 78));
  ValueNotifier<LatLng> mapCenterValueNotifier =
      ValueNotifier<LatLng>(LatLng(0, 0));

  LatLng center = LatLng(21, 78);

  @override
  void initState() {
    super.initState();
    startLocationUpdates();
    startListeningToMapCenterChanges();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<SharedDataProvider>(context, listen: false)
            .fetchUserData(context);
      },
    );
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  void _showBottomSheetWithNearByData(
      BuildContext context, List<Map<String, dynamic>> data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return multipleLocationBottomSheet(context, data);
      },
    );
  }

  Future<void> startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      _mapCenterNotifier.value = LatLng(
        position.latitude,
        position.longitude,
      );

      PastLocation().writeMyLastLocation(
          position.latitude, position.longitude); // update last location
    });
  }

// Function to get the current map center
  LatLng _updateMapCenter() {
    return _animatedMapController.mapController.camera.center;
  }

// Function to update another variable when _updateMapCenter changes
  void updateAnotherVariable() {
    LatLng newCenter = _updateMapCenter();

    // Check if the center has changed
    if (mapCenterValueNotifier.value != newCenter) {
      mapCenterValueNotifier.value = newCenter;
      center = newCenter;
    }
  }

// Example of using a listener or a periodic check to detect changes
  void startListeningToMapCenterChanges() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      updateAnotherVariable();
    });
  }

  void animateMapView(double lat, double long, double zoom) {
    _animatedMapController.animateTo(
      dest: LatLng(lat, long),
      zoom: zoom,
      rotation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: PastLocation().readMyLastLocation(),
          builder: (context, snapshot) {
            bool appFirstTimeLaunch = false;
            if (snapshot.data != null) {
              _mapCenterNotifier = ValueNotifier<LatLng>(
                LatLng(
                  double.parse(snapshot.data![0]),
                  double.parse(snapshot.data![1]),
                ),
              );
              if (firstTimeStart) {
                animateMapView(double.parse(snapshot.data![0]),
                    double.parse(snapshot.data![1]), 17.5);
                firstTimeStart = false;
              }
            } else {
              appFirstTimeLaunch = true;
            }
            return ValueListenableBuilder<LatLng>(
              valueListenable: _mapCenterNotifier,
              builder: (context, mapCenter, child) {
                currLat = mapCenter.latitude;
                currLong = mapCenter.longitude;
                return ValueListenableBuilder<LatLng>(
                  valueListenable: mapCenterValueNotifier,
                  builder: (context, value, child) {
                    if (appFirstTimeLaunch) {
                      return Consumer<SharedDataProvider>(
                        builder: (context, markerValue, child) {
                          return CustomMap(
                            myLat: currLat,
                            myLong: currLong,
                            centerLat: value.latitude,
                            centerLong: value.longitude,
                            mapController: _animatedMapController.mapController,
                            updateMapCenter: _updateMapCenter,
                            context: context,
                            zoom: 4.5,
                            markers: markerValue.markers,
                          );
                        },
                      );
                    }
                    return Consumer<SharedDataProvider>(
                      builder: (context, markerValue, child) {
                        return CustomMap(
                          myLat: currLat,
                          myLong: currLong,
                          centerLat: value.latitude,
                          centerLong: value.longitude,
                          mapController: _animatedMapController.mapController,
                          updateMapCenter: _updateMapCenter,
                          context: context,
                          zoom: 17.5,
                          markers: markerValue.markers,
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
        Align(
          alignment: const AlignmentDirectional(1, 1),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _animatedMapController.animateTo(
                      dest: LatLng(currLat, currLong),
                      zoom: 17.5,
                      rotation: 0,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.my_location_rounded,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? const Color.fromARGB(255, 29, 36, 40)
                      : Colors.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (calculateDistance(
                                    LatLng(currLat, currLong),
                                    LatLng(_updateMapCenter().latitude,
                                        _updateMapCenter().longitude)) <
                                60000) {
                              // to get new data get out of the town
                              Navigator.of(context).push(
                                fromBottomRoute(
                                  const NavigationPage(
                                    initialIndex: 0,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                fromBottomRoute(
                                  NavigationPage(
                                    initialIndex: 0,
                                    latitude: _updateMapCenter().latitude,
                                    longitude: _updateMapCenter().longitude,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.near_me_rounded,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () async {
                            // await Provider.of<SharedDataProvider>(context,
                            //         listen: false)
                            //     .getNearbyData();
                            Provider.of<SharedDataProvider>(context,
                                    listen: false)
                                .getNearbyData(center);
                            var nearByData = Provider.of<SharedDataProvider>(
                                    context,
                                    listen: false)
                                .nearByToCenterData;
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return multipleLocationBottomSheet(
                                    context, nearByData);
                              },
                            );
                          },
                          child: const Icon(
                            Icons.view_in_ar_rounded,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
