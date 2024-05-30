import 'package:shared_preferences/shared_preferences.dart';

Future<bool?> readNavStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? temp = prefs.getBool('navStatus');
  return temp;
}

void writeNavStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? temp = prefs.getBool('navStatus');
  if (temp == null) {
    await prefs.setBool("navStatus", false);
    return;
  }
  await prefs.setBool("navStatus", !temp);
}
