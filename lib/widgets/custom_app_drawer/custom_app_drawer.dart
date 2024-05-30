import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(1, 1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
                          child: Text(
                            'A\nU\nR\nA',
                            style: TextStyle(fontSize: 32, fontFamily: "aura"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: VerticalDivider(
                          thickness: 1,
                          // color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                        child: Text(
                          'EXPLORE',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Icon(
                          Icons.location_on,
                          // color: Theme.of(context).textTheme.bodyText2?.color,
                          size: 36,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              'Guwahati',
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText1
                              //     ?.copyWith(
                              //       fontFamily: 'Readex Pro',
                              //       fontSize: 24,
                              //     ),
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              '26.1158, 91.7086',
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText1
                              //     ?.copyWith(
                              //       fontFamily: 'Readex Pro',
                              //       fontSize: 24,
                              //     ),
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                        .expand((widget) => [widget, SizedBox(height: 24)])
                        .toList(),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
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
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText1
                                //     ?.copyWith(
                                //       fontFamily: 'Readex Pro',
                                //       fontSize: 36,
                                //     ),
                                style: TextStyle(
                                  fontSize: 36,
                                ),
                              ),
                            ),
                            Container(
                              width: 45,
                              height: 45,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icon.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Text(
                            'Favs',
                            // style:
                            //     Theme.of(context).textTheme.bodyText1?.copyWith(
                            //           fontFamily: 'Readex Pro',
                            //           fontSize: 24,
                            //         ),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Text(
                            'Recent',
                            // style:
                            //     Theme.of(context).textTheme.bodyText1?.copyWith(
                            //           fontFamily: 'Readex Pro',
                            //           fontSize: 24,
                            //         ),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.person,
                              // color:
                              // Theme.of(context).textTheme.bodyText2?.color,
                              size: 36,
                            ),
                            Icon(
                              Icons.home_rounded,
                              // color:
                              // Theme.of(context).textTheme.bodyText2?.color,
                              size: 36,
                            ),
                            Icon(
                              Icons.feedback_outlined,
                              // color:
                              //     Theme.of(context).textTheme.bodyText2?.color,
                              size: 36,
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Text(
                                  'Still Queries ?',
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText1
                                  //     ?.copyWith(
                                  //       fontFamily: 'Readex Pro',
                                  //       fontSize: 18,
                                  //     ),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 8, 8, 0),
                                        child: TextFormField(
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
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            prefixIcon: Icon(
                                              Icons.notes,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.keyboard_voice,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                          ),
                                          // style: Theme.of(context)
                                          //     .textTheme
                                          //     .bodyText1
                                          //     ?.copyWith(
                                          //       fontFamily: 'Readex Pro',
                                          //     ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]
                          .expand((widget) => [widget, SizedBox(height: 16)])
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-1, 1),
            child: Lottie.asset(
              'assets/loading_gradient.json',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              frameRate: const FrameRate(144),
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}
