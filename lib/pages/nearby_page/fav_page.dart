import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gadc/functions/location/calculateDistance.dart';
import 'package:gadc/widgets/custom_grid_card/custom_grid_card.dart';
import 'package:gadc/widgets/location_fetch_bottom_sheet/multiple_fetch_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class FavPage extends StatefulWidget {
  final List<Map<String, dynamic>> allData;
  const FavPage({super.key, required this.allData});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  List<Map<String, dynamic>> favoritePlaces = [];

  List<Map<String, dynamic>> nearData = [];

  void getNearbyData(LatLng center) {
    nearData = [];
    for (var data in widget.allData) {
      double distance = calculateDistance(
          LatLng(data['latitude'], data['longitude']), center);
      if (distance <= 100) {
        nearData.add(data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveFavorites();
  }

  Future<void> retrieveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesJson = prefs.getStringList('favorites');

    if (favoritesJson != null) {
      List<Map<String, dynamic>> favorites = favoritesJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      setState(() {
        favoritePlaces = favorites;
      });
    }
  }

  Future<void> removeFromFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesJson = prefs.getStringList('favorites');

    if (favoritesJson != null) {
      List<Map<String, dynamic>> favorites = favoritesJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      if (index >= 0 && index < favorites.length) {
        favorites.removeAt(index);

        List<String> updatedFavoritesJson =
            favorites.map((place) => jsonEncode(place)).toList();

        await prefs.setStringList('favorites', updatedFavoritesJson);

        setState(() {
          favoritePlaces = favorites;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return favoritePlaces.isEmpty
        ? Center(
            child: LottieBuilder.asset(
              "assets/no_result.json",
              repeat: false,
              frameRate: const FrameRate(120),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: favoritePlaces.length,
            itemBuilder: (context, index) {
              final place = favoritePlaces[index];

              // Ensure imageUrls is treated as List<String>
              List<String> imageUrls =
                  (place['imageUrls'] as List<dynamic>).cast<String>();

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      getNearbyData(
                          LatLng(place['latitude'], place['longitude']));
                      _showBottomSheetWithNearByData(context, nearData);
                    },
                    child: GridCard(
                      title: place['name'],
                      location: '${place['latitude']}, ${place['longitude']}',
                      imageUrls: imageUrls,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://picsum.photos/seed/${place['name']}/600',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        removeFromFavorites(index);
                      },
                      child: Icon(Icons.delete),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
