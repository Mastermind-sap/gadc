import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<Map<String, dynamic>>> getCoordinatesFromAddress(
      String address) async {
    final Uri url = Uri.parse(
        '$_baseUrl?q=$address&format=json&addressdetails=1&limit=10'); // increased limit to 10

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data.map((location) {
          return {
            'latLng': LatLng(
              double.parse(location['lat']),
              double.parse(location['lon']),
            ),
            'displayName': location['display_name'],
            'address': location['address'],
          };
        }).toList();
      }
    }
    return [];
  }
}
