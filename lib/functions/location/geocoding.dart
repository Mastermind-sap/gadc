import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<Map<String, dynamic>>> getCoordinatesFromAddress(
      String address) async {
    final Uri url =
        Uri.parse('$_baseUrl?q=$address&format=json&addressdetails=1&limit=10');

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

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    // Validate coordinates
    if (lat < -90.0 || lat > 90.0 || lon < -180.0 || lon > 180.0) {
      throw ArgumentError('Invalid coordinates: lat=$lat, lon=$lon');
    }

    final Uri url = Uri.parse(
        '$_baseUrl?format=json&lat=$lat&lon=$lon&addressdetails=1&limit=1');

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      print('Response body: ${response.body}');

      if (data is List && data.isNotEmpty) {
        final firstResult = data[0];
        if (firstResult.containsKey('display_name') &&
            firstResult['display_name'] is String) {
          return firstResult['display_name'] as String;
        }
      } else {
        print('Empty response data or invalid format: $data');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return ''; // Return an empty string or handle null case as needed
  }
}
