import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadc/functions/gemini/categories/fetchTourismPlaces.dart';
import 'package:gadc/functions/gemini/categories/imageSearch.dart';
import 'package:gadc/functions/location/calculateDistance.dart';
import 'package:gadc/functions/location/locate_me.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:gadc/widgets/custom_category_card/custom_category_card.dart';
import 'package:gadc/widgets/custom_grid_card/custom_grid_card.dart';
import 'package:gadc/widgets/location_fetch_bottom_sheet/multiple_fetch_bottom_sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class NearbyMainPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const NearbyMainPage({Key? key, this.latitude, this.longitude})
      : super(key: key);

  @override
  State<NearbyMainPage> createState() => _NearbyMainPageState();
}

class _NearbyMainPageState extends State<NearbyMainPage> {
  List<dynamic> places = [];
  bool isLoading = true;
  String category = "Tourism";
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.tour_outlined, 'label': 'Tourism'},
    {'icon': Icons.school_rounded, 'label': 'Educational'},
    {'icon': Icons.place_rounded, 'label': 'Historical'},
  ];

  List<Map<String, dynamic>> nearData = [];
  List<Map<String, dynamic>> allData = [];

  void getNearbyData(LatLng center) {
    nearData = [];
    for (var data in allData) {
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
    loadCategories();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('your_collection')
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          allData.add(data);
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
      // showToast('Failed to fetch data: $error'); // Uncomment if you have showToast function
    }
  }

  Future<void> loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCategory = prefs.getString('selected_category');
    setState(() {
      category = savedCategory ?? "Tourism";
    });

    // Prefetch data for all categories
    await Future.wait(
        categories.map((cat) => loadPlacesForCategory(cat['label'])));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadPlacesForCategory(String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.latitude != null && widget.longitude != null) {
      // Fetch new data if specific location is provided
      try {
        List<dynamic> fetchedPlaces = await fetchTourismPlaces(
            category, widget.latitude!, widget.longitude!);
        if (category == this.category) {
          setState(() {
            places = fetchedPlaces;
          });
        }
      } catch (e) {
        print('Error: $e');
      }
      return;
    }

    // Attempt to retrieve cached data
    String? cachedData = prefs.getString('places_$category');

    if (cachedData != null) {
      // Use cached data if available
      if (category == this.category) {
        setState(() {
          places = json.decode(cachedData);
        });
      }
      return;
    }

    // Fetch new data if cached data is not available
    Position pos = await locateMe();
    try {
      List<dynamic> fetchedPlaces =
          await fetchTourismPlaces(category, pos.latitude, pos.longitude);

      // Save fetched data to SharedPreferences for future use
      await prefs.setString('places_$category', json.encode(fetchedPlaces));

      if (category == this.category) {
        setState(() {
          places = fetchedPlaces;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<String>> getImageUrls(String placeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if image URLs are cached in SharedPreferences
    if (prefs.containsKey('imageUrls_$placeName')) {
      // If cached, retrieve and return the cached image URLs
      List<String>? cachedUrls = prefs.getStringList('imageUrls_$placeName');
      if (cachedUrls != null) {
        if (cachedUrls.isEmpty) {
          cachedUrls.add("");
        }
        return cachedUrls;
      }
    }

    // If not cached or cache is empty, fetch from your function
    List<String> fetchedUrls = await getWikipediaImageUrls(placeName);

    // Save fetched URLs to SharedPreferences
    await prefs.setStringList('imageUrls_$placeName', fetchedUrls);

    // Return fetched URLs
    if (fetchedUrls.isEmpty) {
      fetchedUrls.add("");
    }
    return fetchedUrls;
  }

  Future<void> _refreshPlaces() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('places_$category');
    await loadPlacesForCategory(category);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _changeCategory(String newCategory) async {
    if (category == newCategory)
      return; // Disable further selection if the category is already chosen

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_category', newCategory);

    setState(() {
      category = newCategory;
      isLoading = true;
      places = [];
    });

    // Load places for the selected category
    await loadPlacesForCategory(newCategory);
    setState(() {
      isLoading = false;
    });
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

  Future<void> saveFavorite(Map<String, dynamic> place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Convert place to a JSON string and add to the favorites list
    String placeJson = json.encode(place);
    if (!favorites.contains(placeJson)) {
      favorites.add(placeJson);
    }

    // Save the updated favorites list to SharedPreferences
    await prefs.setStringList('favorites', favorites);

    showToast('Added to favorites!');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: const BoxDecoration(),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return GestureDetector(
                      onTap: () {
                        _changeCategory(cat['label']);
                      },
                      child: CategoryCard(
                        icon: cat['icon'],
                        label: cat['label'],
                        isSelected: category == cat['label'],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
              child: (widget.latitude == null)
                  ? const Text(
                      'Searches for location: Current',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    )
                  : Text(
                      'Searches for location: ${widget.latitude}, ${widget.longitude}',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _refreshPlaces,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];

                            Future<List<String>> imageUrlsFuture =
                                getImageUrls(place['name']);

                            return FutureBuilder<List<String>>(
                              future: imageUrlsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: GridCard(
                                      title: '',
                                      location: '',
                                      imageUrls: [],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://picsum.photos/seed/${place['name']}/600',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final imageUrls = snapshot.data ?? [];

                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        getNearbyData(LatLng(place['latitude'],
                                            place['longitude']));
                                        _showBottomSheetWithNearByData(
                                            context, nearData);
                                      },
                                      child: GridCard(
                                        title: place['name'],
                                        location:
                                            '${place['latitude']}, ${place['longitude']}',
                                        imageUrls: imageUrls,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
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
                                          saveFavorite(place);
                                        },
                                        child: Icon(Icons.bookmark_border),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
