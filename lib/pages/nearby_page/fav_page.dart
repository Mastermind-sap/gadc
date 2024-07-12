import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  List<Map<String, dynamic>> favoritePlaces = [];

  @override
  void initState() {
    super.initState();
    retrieveFavorites();
  }

  Future<void> retrieveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesJson = prefs.getStringList('favorites');

    if (favoritesJson != null) {
      List<Map<String, dynamic>> favorites = favoritesJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      setState(() {
        favoritePlaces = favorites;
      });
    }
  }

  Future<void> removeFromFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesJson = prefs.getStringList('favorites');

    if (favoritesJson != null) {
      List<Map<String, dynamic>> favorites = favoritesJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      if (index >= 0 && index < favorites.length) {
        favorites.removeAt(index);

        List<String> updatedFavoritesJson =
            favorites.map((place) => jsonEncode(place)).toList();

        await prefs.setStringList('favorites', updatedFavoritesJson);

        setState(() {
          favoritePlaces = favorites;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return favoritePlaces.isEmpty
        ? Center(
            child: LottieBuilder.asset(
              "assets/no_result.json",
              repeat: false,
              frameRate: const FrameRate(120),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: favoritePlaces.length,
            itemBuilder: (context, index) {
              final place = favoritePlaces[index];
              return Stack(
                children: [
                  GridTile(
                    child: GestureDetector(
                      onTap: () {
                        // Handle tap on favorite item if needed
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://picsum.photos/seed/${place['name']}/600',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        removeFromFavorites(index);
                      },
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
