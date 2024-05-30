import 'package:flutter/material.dart';

class CustomAppDrawer extends StatefulWidget {
  final List<Map<String, String>>? drawerItems;
  const CustomAppDrawer({super.key, this.drawerItems});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  @override
  Widget build(BuildContext context) {
    // Get the amount of space occupied by the keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(150, 29, 36, 40) // Dark mode drawer color
          : const Color.fromARGB(
              150, 255, 255, 255), // Light mode drawer color,
      child: Padding(
        // Adjust the padding of the drawer to move it up when the keyboard is visible
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Align(
                                alignment: AlignmentDirectional(1, 1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 8, 0),
                                  child: Text(
                                    'A\nU\nR\nA',
                                    style: TextStyle(
                                        fontSize: 32, fontFamily: "aura"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 175,
                                child: VerticalDivider(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-1, 0),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 36,
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 4),
                                    child: Text(
                                      'EXPLORE',
                                      style: TextStyle(
                                        fontSize: 36,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '26.1158, 91.7086',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Text(
                                    'Guwahati',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Text(
                                  'Gaurav',
                                  style: TextStyle(
                                    fontSize: 36,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.person,
                                size: 36,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              '• Favs',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              '• Recent',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              '• FeedBack',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.home_rounded,
                                size: 36,
                              ),
                              Icon(
                                Icons.location_city,
                                size: 36,
                              ),
                              Icon(
                                Icons.info_outline_rounded,
                                size: 36,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still Queries ?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    autofocus: false,
                    obscureText: false,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Ask Gemini',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
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
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.notes,
                        color: Colors.black,
                      ),
                      suffixIcon: const Icon(
                        Icons.keyboard_voice,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // for AI Animation
            // Align(
            //   alignment: AlignmentDirectional(-1, 1),
            //   child: Lottie.asset(
            //     'assets/loading_gradient.json',
            //     width: 100,
            //     height: 100,
            //     fit: BoxFit.cover,
            //     frameRate: const FrameRate(144),
            //     animate: true,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
