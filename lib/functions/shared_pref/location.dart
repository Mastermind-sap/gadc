// write user last location in shared pref
import 'package:shared_preferences/shared_preferences.dart';

void writeMyLastLocation(double lat, double long) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
      'myLastLocation', <String>[lat.toString(), long.toString()]);
}

Future<List<String>?> readMyLastLocation() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? temp = prefs.getStringList('myLastLocation');
  return temp;
}
