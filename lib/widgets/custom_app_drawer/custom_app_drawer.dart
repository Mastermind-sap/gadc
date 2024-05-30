import 'package:flutter/material.dart';

class CustomAppDrawer extends StatefulWidget {
  final List<Map<String, String>>? drawerItems;
  const CustomAppDrawer({super.key, this.drawerItems});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 29, 36, 40),
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
                  const Column(
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
                            Align(
                              alignment: AlignmentDirectional(1, 1),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
                                child: Text(
                                  'A\nU\nR\nA',
                                  style: TextStyle(
                                      fontSize: 32, fontFamily: "aura"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: VerticalDivider(
                                thickness: 1,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 36,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 4),
                                  child: Text(
                                    'EXPLORE',
                                    style: TextStyle(
                                      fontSize: 36,
                                    ),
                                  ),
                                ),
                                Text(
                                  '26.1158, 91.7086',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
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
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Text(
                                'Gaurav',
                                style: TextStyle(
                                  fontSize: 36,
                                ),
                              ),
                            ),
                            Container(
                              width: 45,
                              height: 45,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icon.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Text(
                            'Favs',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Text(
                            'Recent',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.person,
                              size: 36,
                            ),
                            Icon(
                              Icons.home_rounded,
                              size: 36,
                            ),
                            Icon(
                              Icons.feedback_outlined,
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
                TextFormField(
                  autofocus: false,
                  obscureText: false,
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
                    prefixIcon: Icon(
                      Icons.notes,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_voice,
                      color: Theme.of(context).scaffoldBackgroundColor,
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
    );
  }
}
