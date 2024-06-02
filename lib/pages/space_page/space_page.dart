import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class SpacePage extends StatelessWidget {
  SpacePage({super.key});

  UnityWidgetController? _unityWidgetController;

  // Callback that connects the created controller to the unity controller, (Need to Work on this)
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
            alignment: const AlignmentDirectional(0, -1),
            child: Padding(
              padding: const EdgeInsets.all(8),
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
                      alignment: const AlignmentDirectional(1, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Theme.of(context).secondaryHeaderColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Floor',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                ),
                              ),
                              const SizedBox(
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
                              const SizedBox(
                                width: 26,
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 24,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.arrow_drop_down,
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
      ],
    );
  }
}
