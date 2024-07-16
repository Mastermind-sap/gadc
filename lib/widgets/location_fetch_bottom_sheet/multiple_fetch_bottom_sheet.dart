import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/pages/create_page/create_page.dart';
import 'package:gadc/pages/player_page/player_page.dart';
import 'package:lottie/lottie.dart';

Widget multipleLocationBottomSheet(
    BuildContext context, List<Map<String, dynamic>> data) {
  if (data.isEmpty) {
    return Stack(
      children: [
        Center(
          child: LottieBuilder.asset(
            "assets/question_lottie.json",
            repeat: false,
          ),
        ),
        Positioned(
          bottom: 32,
          right: 8,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                fromBottomRoute(const CreatePage()),
              );
            },
            child: const Text("Add New ?"),
          ),
        ),
      ],
    );
  }
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(16, 32, 8, 8),
        child: Row(
          children: [
            Icon(
              Icons.view_in_ar_rounded,
              size: 48,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "NEARBY",
              style: TextStyle(fontSize: 32),
            )
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final entry = data[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: entry['imageUrl'] != null
                              ? CachedNetworkImage(
                                  imageUrl: entry['imageUrl'],
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(1, 1),
                            child: Text(
                              entry['name'],
                              style: const TextStyle(
                                fontSize: 36,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${entry['latitude'].toStringAsFixed(4)}, ${entry['longitude'].toStringAsFixed(4)}',
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    fromBottomRoute(PlayerPage(data: entry)),
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
