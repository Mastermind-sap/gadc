import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gadc/functions/locate_me.dart';
import 'package:gadc/functions/shared_pref/location.dart';
import 'package:gadc/functions/show_toast.dart';
import 'package:gadc/widgets/custom_map/custom_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();

  static const String routeName = "/homescreen";
}

class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  // final MapController _mapController = MapController();
  double curr_lat = 0, curr_long = 0;
  LatLng _mapCenter = LatLng(0, 0);
  late final _animatedMapController = AnimatedMapController(vsync: this);
  final ValueNotifier<LatLng> _mapCenterNotifier =
      ValueNotifier<LatLng>(LatLng(0, 0));

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    List<String>? pastData = await readMyLastLocation();
    if (pastData != null && pastData.length >= 2) {
      curr_lat = double.tryParse(pastData[0]) ?? 0;
      curr_long = double.tryParse(pastData[1]) ?? 0;
    }
    _mapCenterNotifier.value = LatLng(curr_lat, curr_long);
  }

  // Function to update the map center
  void _updateMapCenter() {
    LatLng center = _animatedMapController.mapController.camera.center;
    _mapCenter = center;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: _mapCenterNotifier,
          builder: (context, mapCenter, child) {
            return map(
                mapCenter.latitude,
                mapCenter.longitude,
                _animatedMapController.mapController,
                _updateMapCenter,
                context);
          },
        ),
        // to update the curr_loc
        Visibility(
          visible: false,
          child: FutureBuilder(
              future: locateMe(),
              builder: (context, snapshot) {
                // Update pref
                showToast(snapshot.data!.latitude.toString());
                writeMyLastLocation(
                    snapshot.data!.latitude, snapshot.data!.longitude);
                return Container();
              }),
        ),
        Align(
          alignment: const AlignmentDirectional(1, 1),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16 * 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _animatedMapController.animateTo(
                      dest: LatLng(curr_lat, curr_long),
                      zoom: 17.5,
                      rotation: 0,
                      customId: null,
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.my_location_rounded,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.create_rounded,
                          size: 36,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Icon(
                          Icons.threed_rotation_rounded,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
