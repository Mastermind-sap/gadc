import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class SpacePage extends StatelessWidget {
  SpacePage({super.key});

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
                                'Floor',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                ),
                              ),
                              SizedBox(
                                width: 26,
                                child: Divider(
                                  thickness: 1,
                                  //   color: Theme.of(context)
                                  //       .textTheme
                                  //       .bodyText1!
                                  //       .color,
                                  // ),
                                ),
                              ),
                              for (var floor in [
                                '8',
                                '7',
                                '6',
                                '5',
                                '4',
                                '3',
                                '2',
                                '1',
                                'GND'
                              ])
                                Text(
                                  floor,
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    fontSize: floor == '5' ? 36 : null,
                                  ),
                                ),
                              SizedBox(
                                width: 26,
                                child: Divider(
                                  thickness: 1,
                                  // color: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText1!
                                  //     .color,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  // color: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText2!
                                  //     .color,
                                  size: 24,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  // color: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText2!
                                  //     .color,
                                  size: 24,
                                ),
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
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   children: [
        //     Expanded(
        //       child: Padding(
        //         padding: EdgeInsets.all(8),
        //         child: TextFormField(
        //           // controller: _textController,
        //           // focusNode: _textFieldFocusNode,
        //           autofocus: false,
        //           obscureText: false,
        //           decoration: InputDecoration(
        //             isDense: true,
        //             labelText: 'Ask Gemini',
        //             labelStyle: TextStyle(
        //               fontFamily: 'Readex Pro',
        //               color: Theme.of(context).secondaryHeaderColor,
        //             ),
        //             hintStyle: TextStyle(
        //               fontFamily: 'Readex Pro',
        //             ),
        //             enabledBorder: UnderlineInputBorder(
        //               borderSide: BorderSide(
        //                 color: Theme.of(context).colorScheme.secondary,
        //                 width: 2,
        //               ),
        //               borderRadius: BorderRadius.circular(24),
        //             ),
        //             focusedBorder: UnderlineInputBorder(
        //               borderSide: BorderSide(
        //                 color: Theme.of(context).primaryColor,
        //                 width: 2,
        //               ),
        //               borderRadius: BorderRadius.circular(24),
        //             ),
        //             errorBorder: UnderlineInputBorder(
        //               borderSide: BorderSide(
        //                 // color: Theme.of(context).errorColor,
        //                 width: 2,
        //               ),
        //               borderRadius: BorderRadius.circular(24),
        //             ),
        //             focusedErrorBorder: UnderlineInputBorder(
        //               borderSide: BorderSide(
        //                 // color: Theme.of(context).errorColor,
        //                 width: 2,
        //               ),
        //               borderRadius: BorderRadius.circular(24),
        //             ),
        //             filled: true,
        //             // fillColor: Theme.of(context).textTheme.bodyText1!.color,
        //             prefixIcon: Icon(
        //               Icons.notes,
        //               color: Theme.of(context).secondaryHeaderColor,
        //             ),
        //             suffixIcon: Icon(
        //               Icons.keyboard_voice,
        //               color: Theme.of(context).secondaryHeaderColor,
        //             ),
        //           ),
        //           style: TextStyle(
        //             fontFamily: 'Readex Pro',
        //           ),
        //           validator: (value) {
        //             // Your validator logic here
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );

    //  Center(
    //   child: Container(
    //     color: Colors.transparent,
    //     child: UnityWidget(
    //       onUnityCreated: onUnityCreated,
    //     ),
    //   ),
    // );
  }
}
