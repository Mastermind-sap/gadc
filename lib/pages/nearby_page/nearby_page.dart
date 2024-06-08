import 'package:flutter/material.dart';
import 'package:gadc/widgets/custom_category_card/custom_category_card.dart';
import 'package:gadc/widgets/custom_grid_card/custom_grid_card.dart';

class SurroundingPage extends StatefulWidget {
  const SurroundingPage({
    super.key,
  });

  @override
  State<SurroundingPage> createState() => _SurroundingPage();
}

class _SurroundingPage extends State<SurroundingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
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
                  children: [
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
                  // .divide(SizedBox(width: 8)),
                ),
              ),
            ),
            Padding(
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
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    GridCard(
                      title: 'National Institute of Technology Silchar',
                      location: '23.78, 91.93',
                      imageUrl: 'https://picsum.photos/seed/101/600',
                    ),
                    GridCard(
                      title: 'Assam University Silchar',
                      location: '23.78, 91.93',
                      imageUrl: 'https://picsum.photos/seed/101/600',
                    ),
                    GridCard(
                      title: 'Indian Institute of Technology Guwahati',
                      location: '23.78, 91.93',
                      imageUrl: 'https://picsum.photos/seed/101/600',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
