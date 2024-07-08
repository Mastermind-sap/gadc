import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadc/functions/gemini/categories/fetchTourismPlaces.dart';
import 'package:gadc/functions/gemini/categories/imageSearch.dart';
import 'package:gadc/functions/location/locate_me.dart';
import 'package:gadc/widgets/custom_category_card/custom_category_card.dart';
import 'package:gadc/widgets/custom_grid_card/custom_grid_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class FavPage extends StatefulWidget {
  const FavPage({
    super.key,
  });

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        "assets/no_result.json",
        repeat: false,
        frameRate: const FrameRate(120),
      ),
    );
  }
}
