import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> searchPlace(String placeName) async {
  final searchUrl = Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=$placeName&format=json');
  final response = await http.get(searchUrl);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['query']['search'].isNotEmpty) {
      return data['query']['search'][0]['title'];
    }
  }
  return null;
}

Future<List<String>> fetchWikipediaImages(String title) async {
  final response = await http.get(Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&titles=$title&prop=images&format=json'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final pages = data['query']['pages'];
    final page = pages[pages.keys.first];
    final images = page['images'] as List<dynamic>;

    final imageTitles =
        images.map((image) => image['title'] as String).toList();
    return imageTitles;
  } else {
    throw Exception('Failed to load images');
  }
}

Future<List<String>> fetchImageUrls(List<String> imageTitles) async {
  List<String> imageUrls = [];

  for (String imageTitle in imageTitles) {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&titles=$imageTitle&prop=imageinfo&iiprop=url&format=json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pages = data['query']['pages'];
      final page = pages[pages.keys.first];
      final imageInfo = page['imageinfo'] as List<dynamic>;
      if (imageInfo != null && imageInfo.isNotEmpty) {
        imageUrls.add(imageInfo.first['url'] as String);
      }
    }
  }

  return imageUrls;
}

Future<String> getWikipediaImagesJson(String title) async {
  try {
    final imageTitles = await fetchWikipediaImages(title);
    final imageUrls = await fetchImageUrls(imageTitles);
    return json.encode({'images': imageUrls});
  } catch (e) {
    return json.encode({'error': e.toString()});
  }
}

Future<List<String>> getWikipediaImageUrls(String name) async {
  try {
    final title = await searchPlace(name);
    if (title != null) {
      final imageTitles = await fetchWikipediaImages(title);
      final imageUrls = await fetchImageUrls(imageTitles);
      return imageUrls;
    } else {
      throw Exception('Place not found');
    }
  } catch (e) {
    throw Exception('Failed to fetch image URLs: $e');
  }
}
