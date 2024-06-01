import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/pages/map_page/map_page.dart';

import '../../controllers/global_notifiers.dart';

class ExplorePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  final VoidCallback toggleNavBar;

  const ExplorePage({
    super.key,
    required this.drawerKey,
    required this.toggleNavBar,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  void openDrawer() {
    widget.drawerKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                            const MapPage(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 48, 8, 0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      openDrawer();
                                    },
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.notes,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      autofocus: false,
                                      obscureText: false,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Search Aura',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0.1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0.1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0.1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0.1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.keyboard_voice,
                                            color: Colors.black,
                                            size: 24,
                                          ),
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
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: Colors.white,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  widget.toggleNavBar();
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: isNavBarVisible,
                  builder: (context, isVisible, child) {
                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isVisible
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
