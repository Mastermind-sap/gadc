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

Future<String?> getImageUrl(String pageTitle) async {
  final contentUrl = Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&titles=$pageTitle&prop=pageimages&format=json&pithumbsize=500');
  final response = await http.get(contentUrl);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final pages = data['query']['pages'];
    if (pages.isNotEmpty) {
      final page = pages.entries.first.value;
      if (page.containsKey('thumbnail')) {
        return page['thumbnail']['source'];
      }
    }
  }
  return null;
}

Future<String?> getPlaceImageUrl(String placeName) async {
  // Step 1: Search for the place
  final searchUrl = Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=$placeName&format=json');
  final searchResponse = await http.get(searchUrl);

  if (searchResponse.statusCode == 200) {
    final searchData = json.decode(searchResponse.body);
    if (searchData['query']['search'].isNotEmpty) {
      final pageTitle = searchData['query']['search'][0]['title'];

      // Step 2: Get the image URL for the place
      final contentUrl = Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&titles=$pageTitle&prop=pageimages&format=json&pithumbsize=500');
      final contentResponse = await http.get(contentUrl);

      if (contentResponse.statusCode == 200) {
        final contentData = json.decode(contentResponse.body);
        final pages = contentData['query']['pages'];
        if (pages.isNotEmpty) {
          final page = pages.entries.first.value;
          if (page.containsKey('thumbnail')) {
            return page['thumbnail']['source'];
          }
        }
      }
    }
  }
  return null;
}
