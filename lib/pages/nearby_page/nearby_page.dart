import 'package:flutter/material.dart';
import 'package:gadc/functions/gemini/categories/fetchTourismPlaces.dart';
import 'package:gadc/functions/gemini/categories/imageSearch.dart';
import 'package:gadc/widgets/custom_category_card/custom_category_card.dart';
import 'package:gadc/widgets/custom_grid_card/custom_grid_card.dart';

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

  @override
  void initState() {
    super.initState();
    loadTourismPlaces();
  }

  Future<void> loadTourismPlaces() async {
    try {
      List<dynamic> fetchedPlaces = await fetchTourismPlaces();
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
                height: 50,
                decoration: const BoxDecoration(),
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryCard(
                      icon: Icons.tour_outlined,
                      label: 'Tourism',
                    ),
                    CategoryCard(
                      icon: Icons.school_rounded,
                      label: 'Educational',
                    ),
                    CategoryCard(
                      icon: Icons.place_rounded,
                      label: 'Historical',
                    ),
                  ],
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
                    : GridView.builder(
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
                          return FutureBuilder<String?>(
                            future: getPlaceImageUrl(place['name']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final imageUrl = snapshot.data!;

                              return Stack(
                                children: [
                                  GridCard(
                                    title: place['name'],
                                    location:
                                        '${place['latitude']}, ${place['longitude']}',
                                    imageUrl: imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                      child: Icon(Icons.error),
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
          ],
        ),
      ),
    );
  }
}
