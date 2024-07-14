import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/pages/player_page/player_page.dart';

Widget singleLocationBottomSheet(BuildContext context,
    Map<String, dynamic> data, UnityWidgetController? _unityWidgetController) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Opacity(
                    opacity: 0.6,
                    child: CachedNetworkImage(
                      imageUrl: data['imageUrl'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1, -1),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${data['latitude'].toStringAsFixed(4)}, ${data['longitude'].toStringAsFixed(4)}',
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                          child: Text(
                            data['name'],
                            style: TextStyle(
                              fontSize: 36,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  fromBottomRoute(PlayerPage(data: data)),
                                );
                              },
                              child: const Icon(
                                Icons.view_in_ar_rounded,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
