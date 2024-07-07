import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadc/functions/gemini/categories/fetchTourismPlaces.dart';
import 'package:gadc/functions/gemini/categories/imageSearch.dart';
import 'package:gadc/functions/location/locate_me.dart';
import 'package:gadc/widgets/custom_category_card/custom_category_card.dart';
import 'package:gadc/widgets/custom_grid_card/custom_grid_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class SurroundingPage extends StatefulWidget {
  const SurroundingPage({
    super.key,
  });

  @override
  State<SurroundingPage> createState() => _SurroundingPageState();
}

class _SurroundingPageState extends State<SurroundingPage> {
  List<dynamic> places = [];
  bool isLoading = true;
  String category = "Tourism";
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.tour_outlined, 'label': 'Tourism'},
    {'icon': Icons.school_rounded, 'label': 'Educational'},
    {'icon': Icons.place_rounded, 'label': 'Historical'},
  ];

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  Future<void> loadCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCategory = prefs.getString('selected_category');
    setState(() {
      category = savedCategory ?? "Tourism";
      categories.sort((a, b) => a['label'] == category
          ? -1
          : b['label'] == category
              ? 1
              : 0);
    });
    loadTourismPlaces();
  }

  Future<void> loadTourismPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Attempt to retrieve cached data
    String? cachedData = prefs.getString('tourism_places');

    if (cachedData != null) {
      // Use cached data if available
      setState(() {
        places = json.decode(cachedData);
        isLoading = false;
      });
      return;
    }

    // Fetch new data if cached data is not available
    Position pos = await locateMe();
    try {
      List<dynamic> fetchedPlaces =
          await fetchTourismPlaces(category, pos.latitude, pos.longitude);

      // Save fetched data to SharedPreferences for future use
      await prefs.setString('tourism_places', json.encode(fetchedPlaces));

      setState(() {
        places = fetchedPlaces;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
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
    await prefs.remove('tourism_places');
    await loadTourismPlaces();
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
      categories.sort((a, b) => a['label'] == category
          ? -1
          : b['label'] == category
              ? 1
              : 0);
    });
    _refreshPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? const Color.fromARGB(255, 29, 36, 40)
                          : Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: TextFormField(
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Search for Categories',
                          labelStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                          hintStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: !(Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black38
                                  : Colors.white38,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: !(Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black38
                                  : Colors.white38,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: !(Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black38
                                  : Colors.white38,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: !(Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black38
                                  : Colors.white38,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.search_outlined),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
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
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
              child: Text(
                'Searches for location: Current',
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

                            // Assuming getWikipediaImageUrls returns a Future<List<String>>
                            Future<List<String>> imageUrlsFuture =
                                getImageUrls(place['name']);

                            return FutureBuilder<List<String>>(
                              future: imageUrlsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Replace CircularProgressIndicator with Shimmer effect
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: GridCard(
                                      // Adjust the size and layout as needed
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

                                final imageUrls = snapshot.data!;

                                return Stack(
                                  children: [
                                    GridCard(
                                      title: place['name'],
                                      location:
                                          '${place['latitude']}, ${place['longitude']}',
                                      imageUrls: imageUrls,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
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
