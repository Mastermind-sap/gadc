import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class CreatePage extends StatelessWidget {
  CreatePage({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Align(
            alignment: AlignmentDirectional(0, -1),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: UnityWidget(
                        onUnityCreated: onUnityCreated,
                      ),
                    ),
                    // Align(
                    //   alignment: AlignmentDirectional(0, 1),
                    //   child: Padding(
                    //     padding: EdgeInsets.all(8),
                    //     child: Text(
                    //       'Made with\nUNITY',
                    //       textAlign: TextAlign.center,
                    //       // style: Theme.of(context)
                    //       //     .textTheme
                    //       //     .bodyText2
                    //       //     ?.copyWith(
                    //       //       fontFamily: 'Readex Pro',
                    //       //       color: Theme.of(context).secondaryHeaderColor,
                    //       //       fontSize: 14,
                    //       //     ),
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Theme.of(context).secondaryHeaderColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tools',
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText2
                                //     ?.copyWith(
                                //       fontFamily: 'Readex Pro',
                                //       fontSize: 24,
                                //     ),
                              ),
                              SizedBox(
                                width: 36,
                                child: Divider(
                                  thickness: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                'Start',
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText2
                                //     ?.copyWith(
                                //       fontFamily: 'Readex Pro',
                                //       fontSize: 16,
                                //     ),
                              ),
                              Text(
                                'Floor',
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText2
                                //     ?.copyWith(
                                //       fontFamily: 'Readex Pro',
                                //       fontSize: 20,
                                //     ),
                              ),
                              Text(
                                'Stairs',
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText2
                                //     ?.copyWith(
                                //       fontFamily: 'Readex Pro',
                                //       fontSize: 16,
                                //     ),
                              ),
                              Text(
                                'End',
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText2
                                //     ?.copyWith(
                                //       fontFamily: 'Readex Pro',
                                //       fontSize: 16,
                                //     ),
                              ),
                            ],
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
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Align(
                alignment: AlignmentDirectional(1, 0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Theme.of(context).secondaryHeaderColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Floor',
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText2
                              //     ?.copyWith(
                              //       fontFamily: 'Readex Pro',
                              //       fontSize: 24,
                              //     ),
                            ),
                            SizedBox(
                              height: 24,
                              child: VerticalDivider(
                                thickness: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'GND',
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText2
                                  //     ?.copyWith(
                                  //       fontFamily: 'Readex Pro',
                                  //       fontSize: 16,
                                  //     ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  '1',
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText2
                                  //     ?.copyWith(
                                  //       fontFamily: 'Readex Pro',
                                  //       fontSize: 22,
                                  //     ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  '2',
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText2
                                  //     ?.copyWith(
                                  //       fontFamily: 'Readex Pro',
                                  //       fontSize: 16,
                                  //     ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.add,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
