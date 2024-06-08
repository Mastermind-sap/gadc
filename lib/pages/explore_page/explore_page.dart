import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/pages/map_page/map_page.dart';
import 'package:gadc/pages/navigation_page/navigation_page.dart';

class ExplorePage extends StatefulWidget {
  final VoidCallback drawerKey;
  const ExplorePage({super.key, required this.drawerKey});

  @override
  State createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<MapPageState> _mapPageKey = GlobalKey<MapPageState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // To navigate to Navigation Page
  void navigateToNavigationPage(BuildContext context) {
    Navigator.of(context).push(
      fromBottomRoute(const NavigationPage()),
    );
  }

  // To perform the search and update the MapPage
  void _performSearch(BuildContext context) {
    final searchQuery = _searchController.text;
    if (searchQuery.isNotEmpty) {
      _mapPageKey.currentState?.searchLocation(searchQuery);
    }
  }

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
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      MapPage(key: _mapPageKey),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 48, 8, 0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.drawerKey();
                              },
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: (Theme.of(context).brightness == Brightness.dark)
                                    ? const Color.fromARGB(255, 29, 36, 40)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.notes,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                autofocus: false,
                                obscureText: false,
                                style: const TextStyle(
                                    // color: Colors.black,
                                    ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Search Aura',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  filled: true,
                                  fillColor: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? const Color.fromARGB(255, 29, 36, 40)
                                      : Colors.white,
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      _performSearch(context);
                                    },
                                    child: const Icon(
                                      Icons.search,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                    },
                                    child: const Icon(
                                      Icons.keyboard_voice,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  _performSearch(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: (Theme.of(context).brightness == Brightness.dark)
                                  ? const Color.fromARGB(255, 29, 36, 40)
                                  : Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/icon.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-1, 1),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                          child: GestureDetector(
                            onTap: () {
                              navigateToNavigationPage(context);
                            },
                            child: Card(
                              color: (Theme.of(context).brightness == Brightness.dark)
                                  ? const Color.fromARGB(255, 29, 36, 40)
                                  : Colors.white,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
