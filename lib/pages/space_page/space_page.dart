import 'package:flutter/material.dart';
import 'package:gadc/functions/gemini/categories/imageSearch.dart';

class SpacePage extends StatefulWidget {
  SpacePage({super.key});

  @override
  _SpacePageState createState() => _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _searchImage(String placeName) async {
    setState(() {
      _isLoading = true;
    });

    final pageTitle = await searchPlace(placeName);
    if (pageTitle != null) {
      final imageUrl = await getImageUrl(pageTitle);
      setState(() {
        _imageUrl = imageUrl;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wikipedia Image Search'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter a place name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _searchImage,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : _imageUrl != null
                      ? Image.network(_imageUrl!)
                      : Text('No image found'),
            ],
          ),
        ),
      ),
    );
  }
}
