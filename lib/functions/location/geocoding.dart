import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<LatLng>> getCoordinatesFromAddress(String address) async {
    final Uri url =
        Uri.parse('$_baseUrl?q=$address&format=json&addressdetails=1&limit=1');

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        print(data);
        return data
            .map((location) => LatLng(
                  double.parse(location['lat']),
                  double.parse(location['lon']),
                ))
            .toList();
      }
    }
    return [];
  }
}
